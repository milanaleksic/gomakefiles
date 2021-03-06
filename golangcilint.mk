# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RESOURCES_DIR - where is bindata resources directory (where are bindata GO files generated)

LINTER_VERSION ?= v1.31.0
LINTER := ${GOPATH}/bin/golangci-lint

$(LINTER):
	@echo "LINTER NOT FOUND: $(LINTER)"
	@curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh |  sh -s -- -b $$GOPATH/bin ${LINTER_VERSION}

.PHONY: metalinter
metalinter: $(LINTER)
	$(LINTER) run --issues-exit-code=0

.PHONY: metalinter_strict
metalinter_strict: $(LINTER)
	$(LINTER) run --issues-exit-code=1

.PHONY: metalinter_fix
metalinter_fix: $(LINTER)
	$(LINTER) run --issues-exit-code=1 --fix