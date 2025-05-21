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

#[derive(Debug, JsonSchema, Serialize, Deserialize)]
pub struct GetTickerSymbol {
    pub ticker_symbol: String,
}

#[derive(Debug, JsonSchema, Serialize, Deserialize)]
pub struct IdentifySubject {
    pub subject: Subject,
}

#[derive(Debug, JsonSchema, Serialize, Deserialize)]
#[serde(rename_all = "lowercase")]
pub enum Subject {
    Travel,
    Company,
    Error
}

pub fn output_handler(output: &str) -> Result<Value, Box<dyn std::error::Error>> {
    match output {
        "geo_reference" => {
            // Generate schema for GeoReference
            let schema_recipe = schemars::schema_for!(GeoReference);
            let json_schema_rec = generate_schema(schema_recipe, false)?;
            Ok(json_schema_rec)
        }
        "ticker_symbol" => {
            // Generate schema for GetTickerSymbol
            let schema_recipe = schemars::schema_for!(GetTickerSymbol);
            let json_schema_rec = generate_schema(schema_recipe, false)?;
            Ok(json_schema_rec)
        }
        "identify_subject" => {
            // Generate schema for Subject
            let schema_subject = schemars::schema_for!(Subject);
            let json_schema_subject = generate_schema(schema_subject, true)?;

            // Generate schema for IdentifySubject
            let schema_recipe = schemars::schema_for!(IdentifySubject);
            let mut json_schema_rec = generate_schema(schema_recipe, false)?;
            json_schema_rec["properties"]["subject"] = json_schema_subject;
            Ok(json_schema_rec)
        }
        _ => Err("Tool not found".into()),
    }
}

