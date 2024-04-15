#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

VER=$(cargo metadata --format-version=1 --no-deps | jq -r '.packages[0].version')

REPO=$(git config --get remote.origin.url | awk -F '[:/]' -v OFS='/' '{print $(NF-1), $NF}')

REPO=${REPO%.git}

URL=https://raw.githubusercontent.com/i18n-ops/ops/main/curl.setup.sh

ssh="sshpass -e ssh -q -o StrictHostKeyChecking=no -F ~/.ssh/config"

for srv in $API_SRV; do
  $ssh $srv "curl -sSf $URL|bash -s -- $REPO $VER"
done
