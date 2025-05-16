use lambda_http::{run, service_fn, tracing, Error};
pub mod gemini;
mod http_handler;
use http_handler::function_handler;
use env_logger::Env;

pub const DEBUG_PRE: bool = false;
pub const DEBUG_POST: bool = false;

#[tokio::main]
async fn main() -> Result<(), Error> {
    tracing::init_default_subscriber();
    env_logger::Builder::from_env(Env::default().default_filter_or("info")).init();

    run(service_fn(function_handler)).await
}
