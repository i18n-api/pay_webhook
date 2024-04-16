#!/usr/bin/env bash

set -e

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

curl -sSf https://raw.githubusercontent.com/i18n-ops/ops/main/setup/deploy.sh | bash -s -- $@
