# Depends on:
#   APP_NAME - project (github) name

SOURCEDIR = .

MAIN_APP_DIR ?= .

SHELL := bash
# maybe uncomment, but watchout for all the "cd" commands
#.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifndef GOPATH
GOPATH := ${HOME}/go
else
GOPATH := ${GOPATH}
endif

FULL_APP_PATH := ${MAIN_APP_DIR}/${APP_NAME}

GOMAKEFILES_DIR = $(notdir $(patsubst %/,%,$(dir $(abspath $(filter %/common.mk,$(MAKEFILE_LIST))))))

.DEFAULT_GOAL := ${FULL_APP_PATH}

RUN_APP_ARGS := ""

.PHONY: run
run: ${FULL_APP_PATH}
	${FULL_APP_PATH} ${RUN_APP_ARGS}

.PHONY: test
test:
	@if [ -f go.work ]; \
	then \
		go work edit -json | jq -r '.Use[].DiskPath' | xargs -I{} go test -v {}/... -short; \
	else \
		go test -v $$(go list ./... | grep -v /vendor/) -short; \
	fi

.PHONY: int
int:
	@if [ -f go.work ]; \
	then \
		go work edit -json | jq -r '.Use[].DiskPath' | xargs -I{} go test -v {}/... --tags integration --count=1; \
	else \
		go test $(SOURCEDIR)/... --tags integration --count=1; \
	fi

.PHONY: test_vendor
test_vendor:
	go test -mod=vendor -v $$(go list ./... | grep -v /vendor/) -short

.PHONY: test_full
test_full:
	go test -v $$(go list ./... | grep -v /vendor/)

.PHONY: clean_common
clean_common:
	rm -rf ${FULL_APP_PATH}
	rm -rf ${FULL_APP_PATH}.exe

.PHONY: prepare_githooks
prepare_githooks:
	rm .git/hooks/pre-push || true
	ln -s ../../$(GOMAKEFILES_DIR)/githook_prepush.sh .git/hooks/pre-push

.PHONY: copy_to_vagrant
copy_to_vagrant: $(MAIN_APP_DIR)/$(APP_NAME)
	ssh -p 2222 vagrant@localhost 'pgrep ${APP_NAME} | xargs kill > /dev/null 2>&1 || true'
	scp -P 2222 ${APP_NAME} vagrant@localhost:/home/vagrant/