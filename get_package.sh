#!/bin/bash

git config --get remote.origin.url \
    | sed 's/(https*)|(git):\/\///g' \
    | sed 's/.*@//g' \
    | sed 's/:/\//g' \
    | sed 's/.git//g' \
    | sed 's/git.milanaleksic.net\/milanaleksic/go.milanaleksic.net/g'