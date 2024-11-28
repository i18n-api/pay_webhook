#!/usr/bin/env bash

set -e

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

ver=$(cargo metadata --format-version=1 --no-deps | jq '.packages[0] | .version' -r)

curl -sSL https://raw.githubusercontent.com/i18n-ops/ops/refs/heads/main/srv/deploy.sh | sudo bash -s pay_webhook $ver
