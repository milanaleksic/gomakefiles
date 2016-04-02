# Depends on:
#   APP_NAME - project (github) name
#   GOPATH

include $(dir $(lastword $(MAKEFILE_LIST)))/metalinter_common.mk

EXCLUDES_METALINTER := bindata_.*.go

.PHONY: metalinter
metalinter: ${APP_NAME}
	gometalinter --exclude="${EXCLUDES_METALINTER}" --vendor --disable=gotype --deadline=10m ./...
