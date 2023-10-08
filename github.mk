# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RELEASE_SOURCES - all sources, including release-only files (if applicable)
#   TAG (optional, if deploy is called directly)
#   PACKAGE - what is the full package name for this go application?
#   MAIN_APP_DIR - what is the location from this Makefile of the main package that we consider main deployment artifact?

GORELEASER := ${TOOLS_DIR}/goreleaser

$(GORELEASER):
	@echo "downloading 'goreleaser' executable version $(GORELEASER_VERSION)"
	export TMPDIR="$$(mktemp -d)" && \
		export TAR_FILE="$${TMPDIR}/goreleaser_$$(uname -s)_$$(uname -m).tar.gz" && \
		echo "using archive $${TAR_FILE}" && \
		curl -sfLo "$${TAR_FILE}" \
		  "https://github.com/goreleaser/goreleaser/releases/download/$(GORELEASER_VERSION)/goreleaser_$$(uname -s)_$$(uname -m).tar.gz"  && \
		tar -xf "$${TAR_FILE}" -C $$TMPDIR goreleaser && \
		mv $${TMPDIR}/goreleaser $(GORELEASER)

.PHONY: release-local
release-local: $(GORELEASER)
	$(GORELEASER) release --snapshot --skip-publish --rm-dist
	$(GORELEASER) build --single-target

.PHONY: ci
ci: $(GORELEASER)
	$(GORELEASER) release
