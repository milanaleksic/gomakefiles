# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RELEASE_SOURCES - all sources, including release-only files (if applicable)
#   TAG (optional, if deploy is called directly)

VERSION := $(shell git name-rev --tags --name-only `git rev-parse HEAD`)
IS_DEFINED_VERSION := $(shell [ ! "${VERSION}" == "undefined" ] && echo true)

.PHONY: ci
ci: $(SOURCES)
	$(MAKE) clean
	$(MAKE) prepare
	./go-wrapper download .
	$(MAKE) test
	$(MAKE) metalinter_slow
	$(MAKE) ${APP_NAME}_linux_arm5
	$(MAKE) ${APP_NAME}_linux_arm6
	$(MAKE) ${APP_NAME}_linux_arm7
	$(MAKE) ${APP_NAME}_linux_amd64

${APP_NAME}_linux_arm5: $(SOURCES)
	echo Building Linux ARM5 version ${VERSION}
	GOOS=linux GOARCH=arm GOARM=5 go build -ldflags '-X main.Version=${VERSION}' -o ${APP_NAME}_linux_arm5
	PATH=$$PATH:. goupx ${APP_NAME}_linux_arm5

${APP_NAME}_linux_arm6: $(SOURCES)
	echo Building Linux ARM6 version ${VERSION}
	GOOS=linux GOARCH=arm GOARM=6 go build -ldflags '-X main.Version=${VERSION}' -o ${APP_NAME}_linux_arm6
	PATH=$$PATH:. goupx ${APP_NAME}_linux_arm6

${APP_NAME}_linux_arm7: $(SOURCES)
	echo Building Linux ARM7 version ${VERSION}
	GOOS=linux GOARCH=arm GOARM=7 go build -ldflags '-X main.Version=${VERSION}' -o ${APP_NAME}_linux_arm7
	PATH=$$PATH:. goupx ${APP_NAME}_linux_arm7

${APP_NAME}_linux_amd64: $(SOURCES)
	echo Building Linux AMD64 version ${VERSION}
	GOOS=linux GOARCH=amd64 go build -ldflags '-X main.Version=${VERSION}' -o ${APP_NAME}_amd64
	PATH=$$PATH:. goupx ${APP_NAME}_amd64

# test needs to be overriden since the original version doesn't work
.PHONY: test
test:
	go test -v $$(go list -f '{{ join .Deps  "\n"}}' . | grep milanaleksic.net | grep -v vendor/)

.PHONY: clean_gitlab
clean_gitlab:
	unlink $$GOPATH/src/$(shell cat .godir) 2>/dev/null || true

.PHONY: prepare_gitlab
prepare_gitlab:
	git submodule update --init