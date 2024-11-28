#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
ROOT=${DIR%/*}
set -ex

curl https://mise.run | sudo MISE_INSTALL_PATH=/usr/bin/mise bash
mise settings set experimental true

../../srv/init.sh

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

$ROOT/../dist/encrypt.sh $DIROS $ROOT
