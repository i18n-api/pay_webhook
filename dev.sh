#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

source ./sh/pid.sh

set -ex

if ! [ -x "$(command -v dasel)" ]; then
  go install github.com/tomwright/dasel/v2/cmd/dasel@master
fi

exec watchexec \
  --shell=none \
  --project-origin . \
  -w src/ -w Cargo.toml --exts rs,toml \
  -r \
  -- ./run.sh $arg
