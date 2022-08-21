# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RESOURCES_DIR - where is bindata resources directory (where are bindata GO files generated)

GOLANGCILINT_VERSION ?= v1.45.2
LINTER := ${GOPATH}/bin/golangci-lint

$(LINTER):
	@echo "installing 'golangci-lint' executable: $(LINTER) version $(GOLANGCILINT_VERSION)"
	@curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh |  sh -s -- -b $(GOPATH)/bin $(GOLANGCILINT_VERSION)

.PHONY: metalinter
metalinter: $(LINTER)
	@if [ -f go.work ]; \
	then \
		$(LINTER) run --issues-exit-code=0 --out-format=github-actions -- $$(go work edit -json | jq -c -r '[.Use[].DiskPath] | map_values(. + "/...")[]'); \
	else \
		$(LINTER) run --issues-exit-code=0; \
	fi

.PHONY: metalinter_strict
metalinter_strict: $(LINTER)
	@if [ -f go.work ]; \
	then \
		$(LINTER) run --issues-exit-code=1 --out-format=github-actions -- $$(go work edit -json | jq -c -r '[.Use[].DiskPath] | map_values(. + "/...")[]'); \
	else \
		$(LINTER) run --issues-exit-code=1; \
	fi

.PHONY: metalinter_fix
metalinter_fix: $(LINTER)
	@if [ -f go.work ]; \
	then \
		$(LINTER) run --issues-exit-code=1 --fix --out-format=github-actions -- $$(go work edit -json | jq -c -r '[.Use[].DiskPath] | map_values(. + "/...")[]'); \
	else \
		$(LINTER) run --issues-exit-code=1 --fix; \
	fi
