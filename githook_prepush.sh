#!/usr/bin/env bash

echo "Executing pre-push script: goimports"
goimports -w .

echo "Executing pre-push script: metalinter_strict"
make metalinter_strict
