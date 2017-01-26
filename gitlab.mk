# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RELEASE_SOURCES - all sources, including release-only files (if applicable)
#   PACKAGE - what is the full package name for this go application?

VERSION := $(shell git name-rev --tags --name-only `git rev-parse HEAD`)

.PHONY: ci
ci: $(RELEASE_SOURCES)
	$(dir $(lastword $(MAKEFILE_LIST)))/go-wrapper download .
	$(MAKE) test
	$(MAKE) metalinter
	$(MAKE) ${APP_NAME}_linux_arm5
	$(MAKE) ${APP_NAME}_linux_arm6
	$(MAKE) ${APP_NAME}_linux_arm7
	$(MAKE) ${APP_NAME}_linux_amd64

${APP_NAME}_linux_arm5: $(RELEASE_SOURCES)
	echo Building Linux ARM5 version ${VERSION}
	GOOS=linux GOARCH=arm GOARM=5 go build -ldflags '-s -w -X main.Version=${VERSION}' -o ${APP_NAME}_linux_arm5
	./upx -q ${APP_NAME}_linux_arm5

${APP_NAME}_linux_arm6: $(RELEASE_SOURCES)
	echo Building Linux ARM6 version ${VERSION}
	GOOS=linux GOARCH=arm GOARM=6 go build -ldflags '-s -w -X main.Version=${VERSION}' -o ${APP_NAME}_linux_arm6
	./upx -q ${APP_NAME}_linux_arm6

${APP_NAME}_linux_arm7: $(RELEASE_SOURCES)
	echo Building Linux ARM7 version ${VERSION}
	GOOS=linux GOARCH=arm GOARM=7 go build -ldflags '-s -w -X main.Version=${VERSION}' -o ${APP_NAME}_linux_arm7
	./upx -q ${APP_NAME}_linux_arm7

${APP_NAME}_linux_amd64: $(RELEASE_SOURCES)
	echo Building Linux AMD64 version ${VERSION}
	GOOS=linux GOARCH=amd64 go build -ldflags '-s -w -X main.Version=${VERSION}' -o ${APP_NAME}_amd64
	./upx -q ${APP_NAME}_amd64

# test needs to be overriden since the original version doesn't work
.PHONY: test
test:
	go test -v $$(go list -f '{{ join .Deps  "\n"}}' . | grep milanaleksic.net | grep -v vendor/)

.PHONY: clean_gitlab
clean_gitlab:
	unlink $$GOPATH/src/$(PACKAGE) 2>/dev/null || true
