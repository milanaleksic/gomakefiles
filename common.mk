# Depends on:
#   APP_NAME - project (github) name

SOURCEDIR = .

MAIN_APP_DIR ?= .

SHELL := /bin/bash

GOPATH := ${GOPATH}

FULL_APP_PATH := ${MAIN_APP_DIR}/${APP_NAME}

GOMAKEFILES_DIR = $(notdir $(patsubst %/,%,$(dir $(abspath $(filter %/common.mk,$(MAKEFILE_LIST))))))

.DEFAULT_GOAL := ${FULL_APP_PATH}

RUN_APP_ARGS := ""

.PHONY: run
run: ${FULL_APP_PATH}
	${FULL_APP_PATH} ${RUN_APP_ARGS}

.PHONY: test
test:
	go test -v $$(go list ./... | grep -v /vendor/) -short

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

.PHONY: goimports_check
goimports_check:
	@BAD_FILES_COUNT="$$(goimports -l . | grep -v vendor | wc -l)"; \
	if [ "$$BAD_FILES_COUNT" != "0" ]; \
	then \
		echo -e "There is/are $$BAD_FILES_COUNT file(s) with bad formatting:"; \
		goimports -l . | grep -v vendor; \
		exit 1; \
	fi

.PHONY: copy_to_vagrant
copy_to_vagrant: $(MAIN_APP_DIR)/$(APP_NAME)
	ssh -p 2222 vagrant@localhost 'pgrep ${APP_NAME} | xargs kill > /dev/null 2>&1 || true'
	scp -P 2222 ${APP_NAME} vagrant@localhost:/home/vagrant/