use crate::{gemini::chat::ChatGemini, MODEL_DEFAULT};
use crate::gemini::libs::ChatResponse;
use crate::output::output_handler;
use lambda_runtime::{tracing, Error, LambdaEvent};
use serde_json::{json, Value};
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(rename_all = "camelCase")]
pub struct LambdaResponse {
    pub status_code: u16,
    pub body: Option<String>,
    pub is_base64_encoded: bool,
}

pub(crate)async fn function_handler(event: LambdaEvent<Value>) -> Result<LambdaResponse, Error> {
    // Extract some useful information from the request
    tracing::info!("Event: {:?}", event);
    let model = event
        .payload["model"]
        .as_str()
        .unwrap_or(MODEL_DEFAULT);

    let system_prompt = event
        .payload["system_prompt"]
        .as_str()
        .unwrap_or("You are a helpful assistant.");

    let output_format = event
        .payload["output_format"]
        .as_str()
        .unwrap_or("text");

    let prompt = event
        .payload["prompt"]
        .as_str()
        .unwrap_or("no prompt");

    if prompt == "no prompt" {
        return Ok(LambdaResponse {
            status_code: 400,
            body: Some(json!({
                "message": "Prompt is required"
            }).to_string()),
            is_base64_encoded: false,
        });
    }
    
    let mut message = String::new();

    let llm = ChatGemini::new(model);
    let response: ChatResponse;

    if output_format == "text" {
        response = llm
            .with_max_tokens(2048)
            .with_system_prompt(system_prompt)
            .invoke(prompt)
            .await?;
    } else {
        let json_schema_rec = match output_handler(output_format) {
            Ok(schema) => schema,
            Err(e) => {
                return Ok(LambdaResponse {
                    status_code: 400,
                    body: Some(json!({
                        "message": format!("Error generating schema: {}", e)
                    }).to_string()),
                    is_base64_encoded: false,
                });
            }
        };
        response = llm
            .with_system_prompt(system_prompt)
            .with_json_schema(json_schema_rec)
            .invoke(prompt)
            .await?;
    }
   
    if let Some(candidates) = response.candidates {
        for candidate in candidates {
            if let Some(content) = candidate.content {
                for part in content.parts {
                    if let Some(text) = part.text {
                        message.push_str(&text);
                    }
                }
            }
        }
    };

    // Return something that implements IntoResponse.
    // It will be serialized to the right response event automatically by the runtime
    let resp = LambdaResponse {
        status_code: 200,
        body: Some(message),
        is_base64_encoded: false,
    };
    tracing::info!("Response: {:?}", resp);

    Ok(resp)
}
