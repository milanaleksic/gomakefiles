# Depends on:
#   APP_NAME - project name
#   GOPATH
#   TAG
#   _deploy - real logic of deployment (a task)

VERSION := $(shell git name-rev --tags --name-only `git rev-parse HEAD`)_$(shell git rev-parse --short HEAD)

.PHONY: deploy
deploy: metalinter
ifndef TAG
	$(error TAG parameter must be set: make TAG=<TAG_VALUE>)
endif
	echo Creating and pushing tag
	git tag ${TAG}
	git push --tags
	echo Deploying...
	$(MAKE) _deploy

.PHONY: scrap_release
scrap_release:
ifndef TAG
	$(error TAG parameter must be set: make TAG=<TAG_VALUE>)
endif
	git tag -d ${TAG} || true
	git push origin :${TAG} || true
