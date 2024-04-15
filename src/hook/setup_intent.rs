use aok::{Result, OK};
use futures::stream::{FuturesUnordered, StreamExt};
use pay_db::stripe::rm::rm_by_id as rm;
use stripe::SetupIntent;

pub async fn canceled(o: SetupIntent) -> Result<()> {
  let mut li = FuturesUnordered::new();
  if let Some(payment_method) = o.payment_method {
    li.push(rm(payment_method.id()));
  }

  if let Some(last_setup_error) = o.last_setup_error {
    if let Some(payment_method) = last_setup_error.payment_method {
      li.push(rm(payment_method.id));
    }
  }
  while let Some(result) = li.next().await {
    xerr::log!(result);
  }
  OK
}

pub use canceled as setup_failed;

pub async fn succeeded(o: SetupIntent) -> Result<()> {
  pay_db::stripe::setup_intent::new(o).await?;
  OK
}
