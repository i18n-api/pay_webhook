#!/usr/bin/env bash

if [ ${#1} -eq 0 ]; then
  echo "❯ $0 事件名"
  exit 1
fi

exec stripe trigger $1
