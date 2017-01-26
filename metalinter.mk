# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RESOURCES_DIR - where is bindata resources directory (where are bindata GO files generated)

EXCLUDES_METALINTER := $(RESOURCES_DIR)/bindata_.*.go
EXTRA_ARGS_METALINTER := 

.PHONY: prepare_metalinter
prepare_metalinter: ${GOPATH}/bin/gometalinter

${GOPATH}/bin/gometalinter:
	go get github.com/alecthomas/gometalinter
	gometalinter --install --update

.PHONY: metalinter
metalinter: $(SOURCES)
	gometalinter --exclude="${EXCLUDES_METALINTER}" --vendor --disable=gotype --deadline=10m ${EXTRA_ARGS_METALINTER} ./... | sed "s/^/[METALINTER_WARN] /" || true

.PHONY: metalinter_strict
metalinter_strict: $(SOURCES)
	gometalinter --exclude="${EXCLUDES_METALINTER}" --vendor --disable=gotype --deadline=10m ${EXTRA_ARGS_METALINTER} ./...
