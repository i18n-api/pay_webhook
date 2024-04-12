#!/usr/bin/env bash
set -ex
exec stripe listen --forward-to http://127.0.0.1:3000 --events payment_intent.canceled,payment_intent.created,payment_intent.partially_funded,payment_intent.payment_failed,payment_intent.processing,payment_intent.succeeded,setup_intent.succeeded,setup_intent.canceled,setup_intent.setup_failed,payment_method.detached

# payment_method.automatically_updated
