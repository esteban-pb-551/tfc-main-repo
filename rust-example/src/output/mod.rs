use schemars::JsonSchema;
use crate::gemini::utils::generate_schema;
use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Debug, JsonSchema, Serialize, Deserialize)]
pub struct GeoReference {
    pub city: String,
    pub latitude: f64,
    pub longitude: f64,
}

pub fn output_handler(output: &str) -> Result<Value, Box<dyn std::error::Error>> {
    match output {
        "geo_reference" => {
            // Generate schema for GeoReference
            let schema_recipe = schemars::schema_for!(GeoReference);
            let json_schema_rec = generate_schema(schema_recipe, false)?;
            Ok(json_schema_rec)
        }
        _ => Err("Tool not found".into()),
    }
}