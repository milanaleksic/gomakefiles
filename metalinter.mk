# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RESOURCES_DIR - where is bindata resources directory (where are bindata GO files generated)

EXCLUDES_METALINTER := ($(RESOURCES_DIR)/*resources-packr.go)|(.*_test.go)
EXTRA_ARGS_METALINTER :=
GOMETALINTER := ./bin/gometalinter

$(GOMETALINTER):
	curl -fL https://git.io/vp6lP | sh

.PHONY: metalinter
metalinter: $(SOURCES) | $(GOMETALINTER)
	@PATH=$$PATH:./bin && $(GOMETALINTER) --exclude="${EXCLUDES_METALINTER}" --vendor --deadline=10m ${EXTRA_ARGS_METALINTER} ./... | sed "s/^/[METALINTER_WARN] /" || true

.PHONY: metalinter_strict
metalinter_strict: $(SOURCES) | $(GOMETALINTER)
	@PATH=$$PATH:./bin && $(GOMETALINTER) --exclude="${EXCLUDES_METALINTER}" --vendor --deadline=10m ${EXTRA_ARGS_METALINTER} ./...
