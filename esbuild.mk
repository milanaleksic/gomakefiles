# Depends on:
#   GOPATH

ESBUILD := ${GOPATH}/bin/esbuild

$(ESBUILD):
	@echo "installing 'esbuild' executable: $(ESBUILD) version $(ESBUILD_VERSION)"
	go install github.com/evanw/esbuild/cmd/esbuild@$(ESBUILD_VERSION)
