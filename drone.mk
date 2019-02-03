# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RELEASE_SOURCES - all sources, including release-only files (if applicable)
#   TAG (optional, if deploy is called directly)
#   PACKAGE - what is the full package name for this go application?
#   MAIN_APP_DIR - what is the location from this Makefile of the main package that we consider main deployment artifact?

include gomakefiles/drone_version.mk

.PHONY: ci
ci: ${RELEASE_SOURCES}
ifndef SOL_USERNAME
	$(error SOL_USERNAME parameter must be set: make SOL_USERNAME=<SOL_USERNAME_VALUE>)
endif
ifndef SOL_PASSWORD
	$(error SOL_PASSWORD parameter must be set: make SOL_PASSWORD=<SOL_PASSWORD_VALUE>)
endif
	rm $$GOPATH/src/$(PACKAGE) || true
	mkdir -p $$GOPATH/src/$(PACKAGE)
	rsync -ar --delete . $$GOPATH/src/$(PACKAGE)
	cd $$GOPATH/src/$(PACKAGE) && $(MAKE) metalinter
	cd $$GOPATH/src/$(PACKAGE) && $(MAKE) test_vendor
	cd $$GOPATH/src/$(PACKAGE)/$(MAIN_APP_DIR) && go build -mod=vendor -ldflags '-s -w -X main.Version=${TAG}' -o ${APP_NAME}
	cd $$GOPATH/src/$(PACKAGE) && $(MAKE) deploy-if-tagged

.PHONY: deploy-if-tagged
deploy-if-tagged: ${RELEASE_SOURCES}
ifeq ($(IS_REAL_VERSION),true)
	$(MAKE) _deploy_to_sol TAG=$(VERSION)
else
	@echo "No deployment since version is undefined"
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
	$(MAKE) deploy_sol GOOS=linux GOARCH=amd64
	$(MAKE) deploy_sol GOOS=linux GOARCH=arm
ifdef ARM5ALSO
	@echo "Making ARM5 binary also"
	$(MAKE) deploy_sol GOOS=linux GOARCH=arm GOARM=5
endif

.PHONY: deploy_sol
deploy_sol: ${RELEASE_SOURCES} | $(UPX)
	@echo Building and shipping ${GOOS} ${GOARCH}
	cd ${MAIN_APP_DIR} && go build -ldflags '-s -w -X main.Version=${TAG}' -o ${APP_NAME}
	$(UPX) -q $(FULL_APP_PATH)
	@curl -X MKCOL --anyauth --user '${SOL_USERNAME}:${SOL_PASSWORD}' '${SOL_LOCATION}/${APP_NAME}'
	@curl -X PUT --anyauth --user '${SOL_USERNAME}:${SOL_PASSWORD}' -T $(FULL_APP_PATH) '${SOL_LOCATION}/${APP_NAME}/${APP_NAME}-${TAG}-${GOOS}-${GOARCH}'

.PHONY: scrap_release
scrap_release:
ifndef TAG
	$(error TAG parameter must be set: make TAG=<TAG_VALUE>)
endif
	git tag -d ${TAG} || true
	git push origin :${TAG} || true

.PHONY: cd
cd:
ifndef BASTION_TOKEN
	$(error BASTION_TOKEN parameter must be set: make BASTION_TOKEN=<BASTION_TOKEN_VALUE>)
endif
ifeq ($(IS_REAL_VERSION),true)
	curl -X POST https://misc.milanaleksic.net/bastion/deploy?value=${VERSION} --header 'Authorization: Token ${BASTION_TOKEN}'
endif
