use axum::http::StatusCode;
use paste::paste;
use stripe::EventObject;
use t3::HeaderMap;

genv::s!(STRIPE_WEBHOOK);

macro_rules! hook {
  (
    $(
      $kind:ident
      (
        $(
          $ev:ty
        )*
      )
    )*
  ) => {
    paste! {
      $(mod [<$kind:snake>];)*
    }

    pub async fn post(header: HeaderMap, body: String) -> re::msg!() {
      if let Some(sig) = header.get("stripe-signature") {

        match  stripe::Webhook::construct_event(
            &body,
            sig.to_str()?,
            &*STRIPE_WEBHOOK,
          )
        {
          Ok(event) => {
            let data = event.data.object;
            loop {
              paste!{
                match event.type_ {
                    $($(
                      stripe::EventType::[<$kind $ev>] => {
                        if let EventObject::$kind(data) = data {
                          tracing::info!("{} {}\n{:?}\n", stringify!($kind), stringify!($ev), data);
                          // dbg!((&event.type_, &data));
                          [<$kind:snake>]::[<$ev:snake>](data).await?;
                          return Ok("".to_owned());
                        }else{
                          break;
                        }
                      }
                    )*)*
                  _ => {
                    break;
                  }
                }
              }
            }
            tracing::warn!("未处理 {}\n{:?}", event.type_, data);
          }
          Err(e) => {
            tracing::error!("{}\n❌ {}",body, e);
            return re::err(StatusCode::INTERNAL_SERVER_ERROR, String::new())
          }
        }
      }

      re::err(StatusCode::NOT_IMPLEMENTED, String::new())
    }
  };
}

hook!(
  SetupIntent (
    Canceled
    SetupFailed
    Succeeded
  )
  PaymentIntent (
    Canceled
    Created
    PartiallyFunded
    PaymentFailed
    Processing
    Succeeded
  )
  PaymentMethod (
    Detached
  )
);
