use actix_web::{get, web, App, HttpResponse, HttpServer, Responder, Result};
use serde::Deserialize;

#[derive(Deserialize)]
struct Message {
    msg: String,
}

#[get("/health")]
async fn health() -> impl Responder {
    HttpResponse::Ok()
}

#[get("/{msg}/")]
async fn message_transcript(info: web::Path<Message>) -> Result<String> {
    Ok(format!(
        "Transcript {}!",
        info.msg
    ))
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(health)
            .service(message_transcript)
    })
    .bind("0.0.0.0:8000")?
    .run()
    .await
}
