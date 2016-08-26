# Depends on:
#   APP_NAME - project (github) name

SOURCEDIR = .

MAIN_APP_DIR ?= .

SHELL := /bin/bash

GOPATH := ${GOPATH}

FULL_APP_PATH := ${MAIN_APP_DIR}/${APP_NAME}

.DEFAULT_GOAL := ${FULL_APP_PATH}

.PHONY: run
run: ${FULL_APP_PATH}
	${FULL_APP_PATH}

.PHONY: test
test:
	go test -v $$(go list ./... | grep -v /vendor/)

.PHONY: clean_common
clean_common:
	rm -rf ${FULL_APP_PATH}
	rm -rf ${FULL_APP_PATH}_*
	rm -rf ${FULL_APP_PATH}.exe
