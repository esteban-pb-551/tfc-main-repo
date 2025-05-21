use lambda_runtime::{run, service_fn, tracing, Error};
pub mod gemini;
pub mod output;
mod event_handler;
use event_handler::function_handler;
use env_logger::Env;

pub const MODEL_DEFAULT: &str = "gemini-2.0-flash-lite";
pub const DEBUG_PRE: bool = false;
pub const DEBUG_POST: bool = false;

#[tokio::main]
async fn main() -> Result<(), Error> {
    tracing::init_default_subscriber();
    env_logger::Builder::from_env(Env::default().default_filter_or("info")).init();

    run(service_fn(function_handler)).await
}
