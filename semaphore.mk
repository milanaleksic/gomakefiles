# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RELEASE_SOURCES - all sources, including release-only files (if applicable)
#   TAG (optional, if deploy is called directly)
#   PACKAGE - what is the full package name for this go application?
#   MAIN_APP_DIR - what is the location from this Makefile of the main package that we consider main deployment artifact?

VERSION := $(shell git name-rev --tags --name-only `git rev-parse HEAD`)
IS_DEFINED_VERSION := $(shell [ ! "${VERSION}" == "undefined" ] && echo true)

GITHUB_RELEASE := ${GOPATH}/bin/github-release

$(GITHUB_RELEASE):
	go get -u github.com/aktau/github-release

.PHONY: build_release_files
build_release_files: ${RELEASE_SOURCES}

.PHONY: deploy-if-tagged
deploy-if-tagged: ${RELEASE_SOURCES}
ifeq ($(IS_DEFINED_VERSION),true)
	$(MAKE) _release_to_github TAG=$(VERSION)
endif

.PHONY: deploy
deploy: ${RELEASE_SOURCES}
ifndef GITHUB_TOKEN
	$(error GITHUB_TOKEN parameter must be set)
endif
ifndef TAG
	$(error TAG parameter must be set: make TAG=<TAG_VALUE>)
endif
	echo Creating and pushing tag
	git tag ${TAG}
	git push --tags
	echo Sleeping 5 seconds before trying to create release...
	sleep 5
	echo Creating release
	$(MAKE) _release_to_github

.PHONY: _release_to_github
_release_to_github: ${RELEASE_SOURCES} | $(UPX) $(GITHUB_RELEASE)
ifndef GITHUB_TOKEN
	$(error GITHUB_TOKEN parameter must be set)
endif
ifndef TAG
	$(error TAG parameter must be set: make TAG=<TAG_VALUE>)
endif
	github-release release -u milanaleksic -r ${APP_NAME} --tag "${TAG}" --name "v${TAG}"

	echo Building and shipping Windows
	cd ${MAIN_APP_DIR} && (GOOS=windows go build -ldflags '-s -w -X main.Version=${TAG}' -o ${APP_NAME}.exe)
	$(UPX) -q $(FULL_APP_PATH).exe
	github-release upload -u milanaleksic -r ${APP_NAME} --tag ${TAG} --name "${APP_NAME}-${TAG}-windows-amd64.exe" -f ${FULL_APP_PATH}.exe

	echo Building and shipping Linux X64
	cd ${MAIN_APP_DIR} && (GOOS=linux go build -ldflags '-s -w -X main.Version=${TAG}' -o ${APP_NAME})
	$(UPX) -q $(FULL_APP_PATH)
	github-release upload -u milanaleksic -r ${APP_NAME} --tag ${TAG} --name "${APP_NAME}-${TAG}-linux-amd64" -f ${FULL_APP_PATH}

	echo Building and shipping Linux ARM
	cd ${MAIN_APP_DIR} && (GOOS=linux GOARCH=arm go build -ldflags '-s -w -X main.Version=${TAG}' -o ${APP_NAME})
	$(UPX) -q $(FULL_APP_PATH)
	github-release upload -u milanaleksic -r ${APP_NAME} --tag ${TAG} --name "${APP_NAME}-${TAG}-linux-arm" -f ${FULL_APP_PATH}

.PHONY: ci
ci: ${RELEASE_SOURCES} | $(GITHUB_RELEASE)
	rm $$GOPATH/src/$(PACKAGE) || true
	mkdir -p $$GOPATH/src/$(PACKAGE)
	rsync -ar --delete . $$GOPATH/src/$(PACKAGE)
	cd $$GOPATH/src/$(PACKAGE) && $(MAKE) metalinter
	cd $$GOPATH/src/$(PACKAGE) && $(MAKE) test
	cd $$GOPATH/src/$(PACKAGE) && $(MAKE) int
	cd $$GOPATH/src/$(PACKAGE)/$(MAIN_APP_DIR) && go build -ldflags '-s -w -X main.Version=${TAG}' -o ${APP_NAME}
	cd $$GOPATH/src/$(PACKAGE) && $(MAKE) deploy-if-tagged

.PHONY: scrap_release
scrap_release: | $(GITHUB_RELEASE)
ifndef TAG
	$(error TAG parameter must be set: make TAG=<TAG_VALUE>)
endif
	git tag -d ${TAG} || true
	git push origin :${TAG} || true
	github-release delete -u milanaleksic -r ${APP_NAME} --tag "${TAG}" || true

.PHONY: cd
cd:
ifndef BASTION_TOKEN
	$(error BASTION_TOKEN parameter must be set: make BASTION_TOKEN=<BASTION_TOKEN_VALUE>)
endif
ifeq ($(IS_DEFINED_VERSION),true)
	curl -X POST https://misc.milanaleksic.net/bastion/deploy?value=${VERSION} --header 'Authorization: Token ${BASTION_TOKEN}'
endif