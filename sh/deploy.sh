#!/usr/bin/env bash

set -e

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

if [ -z "$1" ]; then
  echo "USAGE : $0 project_name"
  exit 1
else
  conf=$1
  . $conf/api_srv.sh
  key=$conf/ssh/id_ed25519
  chmod 600 $key
fi

set -x

VER=$(cargo metadata --format-version=1 --no-deps | jq -r '.packages[0].version')

REPO=$(git config --get remote.origin.url | awk -F '[:/]' -v OFS='/' '{print $(NF-1), $NF}')

REPO=${REPO%.git}

URL=https://raw.githubusercontent.com/i18n-ops/ops/main/curl.setup.sh

ssh="ssh -q -o StrictHostKeyChecking=no -F $conf/ssh_config -i $key"

for srv in $API_SRV; do
  $ssh root@$srv "curl -sSf $URL|bash -s -- $REPO $VER"
done
