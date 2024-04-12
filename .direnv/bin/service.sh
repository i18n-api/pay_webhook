#!/usr/bin/env bash

set -ex

[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

if [ -z "$1" ]; then
  echo "USAGE : $0 name"
  exit 1
else
  export name=$1
fi

fp=/etc/systemd/system/$name.service
cp $name.service $fp

sed -i "s#DIR#$(pwd)#g" $fp

systemctl daemon-reload

systemctl enable --now $name
systemctl restart $name

systemctl status $name --no-pager

journalctl -u $name -n 10 --no-pager --no-hostname
