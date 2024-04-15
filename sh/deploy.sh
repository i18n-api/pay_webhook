#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

VER=$(cargo metadata --format-version=1 --no-deps | jq -r '.packages[0].version')

REPO=$(git config --get remote.origin.url | awk -F '[:/]' -v OFS='/' '{print $(NF-1), $NF}')

REPO=${REPO%.git}

URL=https://raw.githubusercontent.com/$REPO/main/sh/curl.setup.sh

for srv in $API_SRV; do
  ssh $srv "curl -sSf $URL|bash -s -- $REPO $VER"
done
