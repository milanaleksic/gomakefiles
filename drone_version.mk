IS_DEFINED_VERSION := $(shell [ ! "${VERSION}" == "" ] && echo true)
ifneq ($(IS_DEFINED_VERSION),true)
VERSION := ${DRONE_TAG}
endif

IS_DEFINED_VERSION := $(shell [ ! "${VERSION}" == "" ] && echo true)
ifneq ($(IS_DEFINED_VERSION),true)
VERSION := $(shell git name-rev --tags --name-only `git rev-parse HEAD`)
endif

ifeq ($(IS_DEFINED_VERSION),true)
IS_REAL_VERSION := $(shell [ ! "${VERSION}" == "undefined" ] && echo true)
endif