#!/usr/bin/env bash

set -e

echo "Executing pre-push script: goimports"
make goimports_check

echo "Executing pre-push script: metalinter_strict"
make metalinter_strict
