# Depends on:
#   GOPATH
#   SOURCEDIR - where is the root of the project

DATA_DIR ?= $(SOURCEDIR)/data

SOURCES_DATA := $(shell find $(DATA_DIR))

BINDATA_DEBUG_FILE ?= $(SOURCEDIR)/bindata_debug.go

BINDATA_RELEASE_FILE ?= $(SOURCEDIR)/bindata_release.go

prepare_bindata: ${GOPATH}/bin/go-bindata

${GOPATH}/bin/go-bindata:
	go get github.com/jteeuwen/go-bindata/go-bindata

${BINDATA_DEBUG_FILE}: ${SOURCES_DATA}
	rm -rf ${BINDATA_RELEASE_FILE}
	go-bindata --debug -o=${BINDATA_DEBUG_FILE} ${DATA_DIR}/...
	goimports -w ${BINDATA_DEBUG_FILE}

${BINDATA_RELEASE_FILE}: ${SOURCES_DATA}
	rm -rf ${BINDATA_DEBUG_FILE}
	go-bindata -nocompress=true -nomemcopy=true -o=${BINDATA_RELEASE_FILE} ${DATA_DIR}/...
	goimports -w ${BINDATA_RELEASE_FILE}

.PHONY: clean_bindata
clean_bindata: 
	rm -rf ${BINDATA_DEBUG_FILE}
	rm -rf ${BINDATA_RELEASE_FILE}