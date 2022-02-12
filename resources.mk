# Depends on:
#   GOPATH
#   SOURCEDIR - where is the root of the project

include gomakefiles/goimports.mk

RESOURCES_DIR ?= $(SOURCEDIR)

DATA_DIR ?= $(RESOURCES_DIR)/data

SOURCES_DATA := $(shell find $(DATA_DIR))

PACKR_FILE ?= $(RESOURCES_DIR)/*resources-packr.go

PACKR := ${GOPATH}/bin/packr2

$(PACKR):
	go install github.com/gobuffalo/packr/v2/packr2@latest

${PACKR_FILE}: ${SOURCES_DATA} | $(GOIMPORTS) $(PACKR)
	@echo building debug bindata
	@rm -rf ${PACKR_FILE}
	@cd $(RESOURCES_DIR) && $(PACKR)
	@$(GOIMPORTS) -w ${PACKR_FILE}

.PHONY: clean_packr
clean_packr: $(PACKR)
	@echo cleaning packr
	@packr2 clean
