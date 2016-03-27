.PHONY: prepare_metalinter
prepare_metalinter: ${GOPATH}/bin/gometalinter

${GOPATH}/bin/gometalinter:
	go get github.com/alecthomas/gometalinter
	gometalinter --install --update