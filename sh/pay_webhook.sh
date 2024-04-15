#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*/*}
cd $DIR

. env.sh
set -ex

exec /opt/bin/pay_webhook
