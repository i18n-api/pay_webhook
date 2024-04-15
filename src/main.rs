mod hook;

use aok::{Result, OK};
use axum::{routing, Router};
use ping_ver::ping_ver;

genv::def!(PORT:u16 | 2005);

#[tokio::main]
async fn main() -> Result<()> {
  loginit::init();
  let app = Router::new().route("/", routing::post(re::FnAny(hook::post)));

  t3::srv(ping_ver!(app), PORT()).await;
  OK
}
