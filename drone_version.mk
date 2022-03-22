IS_DEFINED_VERSION := $(shell [ ! "${VERSION}" == "" ] && echo true)
ifneq ($(IS_DEFINED_VERSION),true)
VERSION := ${DRONE_TAG}
endif

ifeq ($(IS_DEFINED_VERSION),true)
IS_REAL_VERSION := $(shell [ ! "${VERSION}" == "undefined" ] && echo true)
endif