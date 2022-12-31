# Depends on:
#   SOURCEDIR - where is the root of the project

include gomakefiles/goimports.mk

RESOURCES_DIR ?= $(SOURCEDIR)

DATA_DIR ?= $(RESOURCES_DIR)/data

SOURCES_DATA := $(shell find $(DATA_DIR))
