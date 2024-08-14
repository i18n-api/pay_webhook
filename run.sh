#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

exe=./target/debug/$name

rm -rf $exe

cargo build

if [ -f "$exe" ]; then
  GREEN='\033[0;92m'
  NC='\033[0m'
  echo -e "\n${GREEN}❯ $exe$NC\n"
  exec $exe
else
  exec direnv exec . cargo run
fi
