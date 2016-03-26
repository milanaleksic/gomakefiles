# Depends on:
#   APP_NAME - project (github) name
#   GOPATH

.PHONY: metalinter
metalinter: ${APP_NAME}
	gometalinter --exclude="bindata_*" --vendor --disable=gotype --deadline=10m ./...

.PHONY: prepare_metalinter
prepare_metalinter: ${GOPATH}/bin/gometalinter

${GOPATH}/bin/gometalinter:
	go get github.com/alecthomas/gometalinter
	gometalinter --install --update