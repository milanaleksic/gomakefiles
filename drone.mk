# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RELEASE_SOURCES - all sources, including release-only files (if applicable)
#   TAG (optional, if deploy is called directly)
#   PACKAGE - what is the full package name for this go application?
#   MAIN_APP_DIR - what is the location from this Makefile of the main package that we consider main deployment artifact?

VERSION := $(shell git name-rev --tags --name-only `git rev-parse HEAD`)
IS_DEFINED_VERSION := $(shell [ ! "${VERSION}" == "undefined" ] && echo true)

.PHONY: deploy-if-tagged
deploy-if-tagged: ${RELEASE_SOURCES}
ifeq ($(IS_DEFINED_VERSION),true)
	$(MAKE) _deploy_to_sol TAG=$(VERSION)
endif

.PHONY: deploy
deploy: ${RELEASE_SOURCES}
ifndef TAG
	$(error TAG parameter must be set: make TAG=<TAG_VALUE>)
endif
	echo Creating and pushing tag
	git tag ${TAG}
	git push --tags
	echo Sleeping 5 seconds before trying to create release...
	sleep 5
	echo Deploying release
	$(MAKE) _deploy_to_sol

.PHONY: _deploy_to_sol
_deploy_to_sol: ${RELEASE_SOURCES}
ifndef TAG
	$(error TAG parameter must be set: make TAG=<TAG_VALUE>)
endif
	deploy_sol GOOS=linux GOARCH=amd64
	deploy_sol GOOS=linux GOARCH=arm

# TODO: use webdav to put files
.PHONY: deploy_sol
deploy_sol: ${RELEASE_SOURCES}
	@echo Building and shipping ${GOOS} ${GOARCH}
	cd ${MAIN_APP_DIR} && go build -ldflags '-s -w -X main.Version=${TAG}' -o ${APP_NAME}
	./upx -q $(FULL_APP_PATH)
	ssh sol 'mkdir -p /volume1/artifacts/${APP_NAME}/'
	scp $(FULL_APP_PATH) sol:/volume1/artifacts/${APP_NAME}/${APP_NAME}-${TAG}-${GOOS}-${GOARCH}

.PHONY: ci
ci: ${RELEASE_SOURCES}
	rm $$GOPATH/src/$(PACKAGE) || true
	mkdir -p $$GOPATH/src/$(PACKAGE)
	rsync -ar --delete . $$GOPATH/src/$(PACKAGE)
	cd $$GOPATH/src/$(PACKAGE) && $(MAKE) metalinter
	cd $$GOPATH/src/$(PACKAGE) && $(MAKE) test
	cd $$GOPATH/src/$(PACKAGE)/$(MAIN_APP_DIR) && go build -ldflags '-s -w -X main.Version=${TAG}' -o ${APP_NAME}
	cd $$GOPATH/src/$(PACKAGE) && $(MAKE) deploy-if-tagged

.PHONY: scrap_release
scrap_release:
ifndef TAG
	$(error TAG parameter must be set: make TAG=<TAG_VALUE>)
endif
	git tag -d ${TAG} || true
	git push origin :${TAG} || true
