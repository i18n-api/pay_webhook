#!/usr/bin/env bash

set -e

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

META=$(cargo metadata --format-version=1 --no-deps | jq '.packages[0] | .name + ":" + .version' -r)

curl -sSf https://raw.githubusercontent.com/i18n-ops/ops/main/setup/deploy.sh | bash -s -- $META $@
