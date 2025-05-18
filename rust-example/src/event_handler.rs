use crate::{gemini::chat::ChatGemini, MODEL_DEFAULT};
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
    let prompt = event
        .payload["prompt"]
        .as_str()
        .unwrap_or("no prompt");

    let model = event
        .payload["model"]
        .as_str()
        .unwrap_or(MODEL_DEFAULT);

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

    let response = llm
        .with_max_tokens(1024)
        .with_system_prompt("You are a helpful assistant.")
        .invoke(prompt)
        .await?;
   
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
