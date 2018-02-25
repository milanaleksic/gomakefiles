# Depends on:
#   GOPATH
#   SOURCEDIR - where is the root of the project

include gomakefiles/goimports.mk

RESOURCES_DIR ?= $(SOURCEDIR)

DATA_DIR ?= $(RESOURCES_DIR)/data

PACKR_FILE ?= $(RESOURCES_DIR)/resources-packr.go

PACKR := ${GOPATH}/bin/packr

$(PACKR):
	go get -u github.com/gobuffalo/packr/...

${PACKR_FILE}: $(GOIMPORTS) $(PACKR)
	@echo building debug bindata
	@rm -rf ${PACKR_FILE}
	@$(PACKR)
	@$(GOIMPORTS) -w ${PACKR_FILE}

.PHONY: clean_packr
clean_packr: $(PACKR)
	@echo cleaning packr
	@packr clean
