# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RESOURCES_DIR - where is bindata resources directory (where are bindata GO files generated)

EXCLUDES_METALINTER := ($(RESOURCES_DIR)/bindata_.*.go)|(.*_test.go)
EXTRA_ARGS_METALINTER :=
GOMETALINTER := ${GOPATH}/bin/gometalinter

$(GOMETALINTER):
	go get -u github.com/alecthomas/gometalinter
	$(GOMETALINTER) --install --update

.PHONY: metalinter
metalinter: $(SOURCES) | $(GOMETALINTER)
	$(GOMETALINTER) --exclude="${EXCLUDES_METALINTER}" --vendor --disable=gotype --deadline=10m ${EXTRA_ARGS_METALINTER} ./... | sed "s/^/[METALINTER_WARN] /" || true

.PHONY: metalinter_strict
metalinter_strict: $(SOURCES) | $(GOMETALINTER)
	$(GOMETALINTER) --exclude="${EXCLUDES_METALINTER}" --vendor --disable=gotype --deadline=10m ${EXTRA_ARGS_METALINTER} ./...
