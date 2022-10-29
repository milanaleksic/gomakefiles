#!/usr/bin/env bash

while read line
do
  if [[ $line =~ refs/tags/ ]]; then
    echo "Avoiding pre-push hook since we are pushing tags, not commits"
    exit 0
  fi
done < /dev/stdin

set -e

echo "Executing pre-push script: metalinter_strict"
make metalinter_strict

