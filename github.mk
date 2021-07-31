# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RELEASE_SOURCES - all sources, including release-only files (if applicable)
#   TAG (optional, if deploy is called directly)
#   PACKAGE - what is the full package name for this go application?
#   MAIN_APP_DIR - what is the location from this Makefile of the main package that we consider main deployment artifact?

GORELEASER := ${GOPATH}/bin/goreleaser

$(GORELEASER):
	@echo "installing 'goreleaser' executable: $(GORELEASER) version $(GORELEASER_VERSION)"
	go install github.com/goreleaser/goreleaser@$(GORELEASER_VERSION)

.PHONY: release-local
release-local:
	$(GORELEASER) release --snapshot --skip-publish --rm-dist
	$(GORELEASER) build --single-target

.PHONY: ci
ci: ${RELEASE_SOURCES} | $(GORELEASER)
	$(GORELEASER) release

.PHONY: cd
cd:
ifndef BASTION_TOKEN
	$(error BASTION_TOKEN parameter must be set: make BASTION_TOKEN=<BASTION_TOKEN_VALUE>)
endif
ifeq ($(IS_REAL_VERSION),true)
	curl --fail -X POST https://misc.milanaleksic.net/bastion/deploy?value=${VERSION} --header 'Authorization: Token ${BASTION_TOKEN}'
endif
