# Depends on:
#   SOURCEDIR - where is the root of the project

include gomakefiles/goimports.mk

RESOURCES_DIR ?= $(SOURCEDIR)

DATA_DIR ?= $(RESOURCES_DIR)/data

SOURCES_DATA := $(shell find $(DATA_DIR))

RESOURCES_SIGNAL_GO ?= $(RESOURCES_DIR)/signal.go

${RESOURCES_SIGNAL_GO}: $(SOURCES_DATA)
	@echo sinaling that changes have ocurred by updating signal.go
	@echo "package $$(basename `dirname ${RESOURCES_SIGNAL_GO}`)" > ${RESOURCES_SIGNAL_GO}
