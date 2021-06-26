# Depends on:
#   GOPATH

ESBUILD := ${GOPATH}/bin/esbuild

$(ESBUILD):
	go install github.com/evanw/esbuild/cmd/esbuild@$(ESBUILD_VERSION)
