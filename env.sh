#!/usr/bin/env bash

set -o allexport
RUST_LOG=debug,supervisor=warn,hyper=warn,rustls=warn,h2=warn,tower=warn,reqwest=warn,h3=warn,quinn_udp=warn,quinn_proto=warn,watchexec=warn,globset=warn,hickory_proto=warn,hickory_resolver=warn,fred=warn
RUST_BACKTRACE=short
source ../conf/env/stripe_webhook.sh
source ../conf/env/stripe.sh
source ../conf/env/db.sh
source ../conf/env/r.sh
set +o allexport
