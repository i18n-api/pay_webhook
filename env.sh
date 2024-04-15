set -o allexport
RUST_LOG=debug,supervisor=warn,hyper=warn,rustls=warn,h2=warn,tower=warn,reqwest=warn,h3=warn,quinn_udp=warn,quinn_proto=warn,watchexec=warn,globset=warn,hickory_proto=warn,hickory_resolver=warn,fred=warn
RUST_BACKTRACE=short
source stripe_webhook.sh
source stripe.sh
source db.sh
source r.sh
set +o allexport
