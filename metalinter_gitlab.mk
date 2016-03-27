# Depends on:
#   APP_NAME - project (github) name
#   GOPATH

include $(dir $(lastword $(MAKEFILE_LIST)))/metalinter_common.mk

.PHONY: metalinter
metalinter: ${APP_NAME}
	gometalinter --exclude="bindata_*" --vendor --disable=gotype --concurrency=1 --deadline=10m ./...
