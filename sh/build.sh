#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex
export RUSTFLAGS='--cfg reqwest_unstable -C target-feature=+aes'
crate_build.sh
