use aok::Result;
use pay_db::stripe::rm::rm_by_id as rm;
use stripe::PaymentMethod;

pub async fn detached(o: PaymentMethod) -> Result<()> {
  rm(o.id).await
}
