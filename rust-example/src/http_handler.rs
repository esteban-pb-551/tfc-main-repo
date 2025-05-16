use crate::gemini::chat::ChatGemini;
use lambda_http::{Body, Error, Request, RequestExt, Response};

/// This is the main body for the function.
/// Write your code inside it.
/// There are some code example in the following URLs:
/// - https://github.com/awslabs/aws-lambda-rust-runtime/tree/main/examples
pub(crate) async fn function_handler(event: Request) -> Result<Response<Body>, Error> {
    // Extract some useful information from the request
    let prompt = event
        .query_string_parameters_ref()
        .and_then(|params| params.first("prompt"))
        .unwrap_or("no prompt");

    if prompt == "no prompt" {
        return Ok(Response::builder()
            .status(400)
            .header("content-type", "text/html")
            .body("No prompt provided".into())
            .map_err(Box::new)?);
    }
    
    let mut message = String::new();

    let llm = ChatGemini::new("gemini-2.0-flash-lite");

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
    let resp = Response::builder()
        .status(200)
        .header("content-type", "text/html")
        .body(message.into())
        .map_err(Box::new)?;
    Ok(resp)
}
