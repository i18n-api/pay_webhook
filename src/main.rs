mod hook;

use aok::{Result, OK};
use axum::{routing, Router};

genv::def!(PORT:u16 | 3000);

#[tokio::main(flavor = "multi_thread")]
async fn main() -> Result<()> {
  loginit::init();
  let app = Router::new().route("/", routing::post(re::FnAny(hook::post)));
  t3::srv(app, PORT()).await;
  OK
}
