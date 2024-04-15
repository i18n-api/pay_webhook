#!/usr/bin/env bash

if [ -z "$2" ]; then
  echo "USAGE : $0 org/project version"
  exit 1
else
  PROJECT=$1
  VER=$2
fi

case "$(uname -s)" in
"Darwin")
  OS="apple-darwin"
  ;;
"Linux")
  (ldd --version 2>&1 | grep -q musl) && clib=musl || clib=gun
  OS="unknown-linux-$clib"
  ;;
"MINGW*" | "CYGWIN*")
  OS="pc-windows-msvc"
  ;;
*)
  echo "Unsupported System"
  exit 1
  ;;
esac

ARCH=$(uname -m)

if [[ "$ARCH" == "arm64" || "$ARCH" == "arm" ]]; then
  ARCH="aarch64"
fi

TZT=$ARCH-$OS.tar.zst

echo $VER $TZT

tmp=/tmp/$PROJECT/$VER

rm -rf $tmp

mkdir -p $tmp

cd $tmp

wget -c https://github.com/$PROJECT/releases/download/$VER/$TZT

tar xvf $TZT

rm $TZT

rsync -av . /

systemctl daemon-reload

name=$(basename $PROJECT)
systemctl enable --now $name
systemctl restart $name
systemctl status $name --no-pager
