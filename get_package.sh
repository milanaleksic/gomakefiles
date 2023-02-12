#!/usr/bin/env bash

git config --get remote.origin.url \
    | sed 's/https*:\/\///g' \
    | sed 's/git:\/\///g' \
    | sed 's/.*@//g' \
    | sed 's/:/\//g' \
    | sed 's/.git//g' \
    | sed 's/git.milanaleksic.net\/milanaleksic/go.milanaleksic.net\/milanaleksic/g'
