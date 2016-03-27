# Depends on:
#   APP_NAME - project (github) name
#   GOPATH

include metalinter_common.mk

.PHONY: metalinter
metalinter: ${APP_NAME}
	gometalinter --exclude="bindata_*" --vendor --disable=gotype --deadline=10m ./...
