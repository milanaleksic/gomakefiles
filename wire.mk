# Depends on:
#   APP_NAME - project (github) name
#   GOPATH
#   RESOURCES_DIR - where is bindata resources directory (where are bindata GO files generated)

WIRE := ${GOPATH}/bin/wire

$(WIRE):
	@echo "wire NOT FOUND: $(WIRE)"
	@go install github.com/google/wire/cmd/wire@$(WIRE_VERSION)
