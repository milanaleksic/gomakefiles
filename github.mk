# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RELEASE_SOURCES - all sources, including release-only files (if applicable)
#   TAG (optional, if deploy is called directly)
#   PACKAGE - what is the full package name for this go application?
#   MAIN_APP_DIR - what is the location from this Makefile of the main package that we consider main deployment artifact?

.PHONY: release-local
release-local:
	goreleaser release --snapshot --skip-publish --rm-dist
	goreleaser build --single-target

.PHONY: ci
ci:
	goreleaser release
