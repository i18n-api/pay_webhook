#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -e

branch=$(git symbolic-ref --short -q HEAD)
gci
git pull
msg=$(git log -1 --pretty=format:'%B' $branch)

if ! [[ $msg =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  gme $@
  cargo v patch -y
  if [ "$branch" != "main" ]; then
    git push
    git checkout main
    git merge $branch
  fi
  git push
  msg=$(git log -1 --pretty=format:'%B' $branch)
  git push github $msg
fi

# ./setup.sh
#
# CONF=$(realpath $DIR/../../conf)
# . $CONF/env/dist_to.sh
#
# NAME=$(cargo metadata --format-version=1 --no-deps | jq -r '.packages[0].name')
# FILE_LI="/opt/bin/$NAME.sh /opt/bin/$NAME /etc/systemd/system/$NAME.service"
#
# for srv in $DIST_TO; do
#   for file in $FILE_LI; do
#     rsync --mkpath -avz $file $srv:$file &
#   done
#   wait
#   ssh $srv "set -ex && cd $CONF && git pull && systemctl daemon-reload && systemctl enable --now $NAME && systemctl restart $NAME"
# done
