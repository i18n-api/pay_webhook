#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
ROOT=${ROOT%/*}
set -ex

./build.sh

DIROS=$DIR/dist/os
TO=$DIROS/opt/bin
mkdir -p $TO

cd dist
find . -type f | xargs -I {} mv {} os/opt/bin
cd ..

META=$(cargo metadata --format-version=1 --no-deps | jq '.packages[0] | .name + " " + .version' -r)
NAME=$(echo $META | cut -d ' ' -f1)
VER=$(echo $META | cut -d ' ' -f2)

boot=$TO/$NAME.sh

cat <<EOF >$boot
#!/usr/bin/env bash
set -e
cd /root/i18n/conf/env
$(cat ../env.sh)
exec /opt/bin/$NAME
EOF

chmod +x $boot

sys=$DIROS/etc/systemd/system

mkdir -p $sys

cp $NAME.service $sys/

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

cd $DIROS
ZSTD_CLEVEL=19 tar --owner=root --group=root -I zstd -cvpf ../$TZT .
cd ..

LOG=$ROOT/log/$VER.md

if [ -f "$LOG" ]; then
  NOTE="-F $LOG"
else
  NOTE="-n $VER"
fi

gh release create -d $VER $NOTE
gh release upload $VER $TZT
gh release edit $VER --draft=false
