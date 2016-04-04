# Depends on:
#   APP_NAME - project (github) name
#   GOPATH

EXCLUDES_METALINTER := bindata_.*.go
EXTRA_ARGS_METALINTER := 

.PHONY: prepare_metalinter
	prepare_metalinter: ${GOPATH}/bin/gometalinter

${GOPATH}/bin/gometalinter:
	go get github.com/alecthomas/gometalinter
	gometalinter --install --update

.PHONY: metalinter
metalinter: ${APP_NAME}
	gometalinter --exclude="${EXCLUDES_METALINTER}" --vendor --disable=gotype --deadline=10m ${EXTRA_ARGS_METALINTER} ./... | sed "s/^/[METALINTER_WARN] /" || true

.PHONY: metalinter_strict
metalinter_strict: ${APP_NAME}
	gometalinter --exclude="${EXCLUDES_METALINTER}" --vendor --disable=gotype --deadline=10m ${EXTRA_ARGS_METALINTER} ./...
