# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RESOURCES_DIR - where is bindata resources directory (where are bindata GO files generated)

.PHONY: metalinter
metalinter:
	@if [ -f go.work ]; \
	then \
		golangci-lint run --issues-exit-code=0 --out-format=github-actions -- $$(go work edit -json | jq -c -r '[.Use[].DiskPath] | map_values(. + "/...")[]'); \
	else \
		golangci-lint run --issues-exit-code=0; \
	fi

.PHONY: metalinter_strict
metalinter_strict:
	@if [ -f go.work ]; \
	then \
		golangci-lint run --issues-exit-code=1 --out-format=github-actions -- $$(go work edit -json | jq -c -r '[.Use[].DiskPath] | map_values(. + "/...")[]'); \
	else \
		golangci-lint run --issues-exit-code=1; \
	fi

.PHONY: metalinter_fix
metalinter_fix:
	@if [ -f go.work ]; \
	then \
		golangci-lint run --issues-exit-code=1 --fix --out-format=github-actions -- $$(go work edit -json | jq -c -r '[.Use[].DiskPath] | map_values(. + "/...")[]'); \
	else \
		golangci-lint run --issues-exit-code=1 --fix; \
	fi
