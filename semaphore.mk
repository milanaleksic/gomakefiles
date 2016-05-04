# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RELEASE_SOURCES - all sources, including release-only files (if applicable)
#   TAG (optional, if deploy is called directly)
#   PACKAGE - what is the full package name for this go application?

VERSION := $(shell git name-rev --tags --name-only `git rev-parse HEAD`)
IS_DEFINED_VERSION := $(shell [ ! "${VERSION}" == "undefined" ] && echo true)

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
_release_to_github: ${RELEASE_SOURCES}
ifndef GITHUB_TOKEN
	$(error GITHUB_TOKEN parameter must be set)
endif
ifndef TAG
	$(error TAG parameter must be set: make TAG=<TAG_VALUE>)
endif
	github-release release -u milanaleksic -r ${APP_NAME} --tag "${TAG}" --name "v${TAG}"

	echo Building and shipping Windows
	GOOS=windows go build -ldflags '-s -w -X main.Version=${TAG}'
	./upx ${APP_NAME}.exe
	github-release upload -u milanaleksic -r ${APP_NAME} --tag ${TAG} --name "${APP_NAME}-${TAG}-windows-amd64.exe" -f ${APP_NAME}.exe

	echo Building and shipping Linux
	GOOS=linux go build -ldflags '-s -w -X main.Version=${TAG}'
	PATH=$$PATH:. goupx ${APP_NAME}
	github-release upload -u milanaleksic -r ${APP_NAME} --tag ${TAG} --name "${APP_NAME}-${TAG}-linux-amd64" -f ${APP_NAME}

.PHONY: ci
ci: ${RELEASE_SOURCES}
	rm $$GOPATH/src/$(PACKAGE) || true
	mkdir -p $$GOPATH/src/$(PACKAGE)
	rsync -ar --delete . $$GOPATH/src/$(PACKAGE)
	cd $$GOPATH/src/$(PACKAGE) && $(MAKE) metalinter
	cd $$GOPATH/src/$(PACKAGE) && $(MAKE) test
	cd $$GOPATH/src/$(PACKAGE) && go build -ldflags '-s -w -X main.Version=${TAG}' -o ${APP_NAME}

.PHONY: prepare_github_release
prepare_github_release: ${GOPATH}/bin/github-release

${GOPATH}/bin/github-release:
	go get github.com/aktau/github-release
