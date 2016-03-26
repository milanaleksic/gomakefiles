# Depends on:
#   APP_NAME - project (github) name

SOURCEDIR = .

SHELL := /bin/bash

GOPATH := ${GOPATH}

.DEFAULT_GOAL := ${APP_NAME}

.PHONY: run
run: ${APP_NAME}
	./${APP_NAME}

.PHONY: test
test:
	go test -v $$(go list ./... | grep -v /vendor/)

.PHONY: clean_common
clean_common:
	rm -rf ${APP_NAME}
	rm -rf ${APP_NAME}.exe
