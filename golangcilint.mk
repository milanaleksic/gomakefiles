# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RESOURCES_DIR - where is bindata resources directory (where are bindata GO files generated)

GOLANGCILINT_VERSION ?= v1.31.0
LINTER := ${GOPATH}/bin/golangci-lint

$(LINTER):
	@echo "installing 'golangci-lint' executable: $(LINTER) version $(GOLANGCILINT_VERSION)"
	@curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh |  sh -s -- -b $(GOPATH)/bin $(GOLANGCILINT_VERSION)

.PHONY: metalinter
metalinter: $(LINTER)
	$(LINTER) run --issues-exit-code=0

.PHONY: metalinter_strict
metalinter_strict: $(LINTER)
	$(LINTER) run --issues-exit-code=1

.PHONY: metalinter_fix
metalinter_fix: $(LINTER)
	$(LINTER) run --issues-exit-code=1 --fix