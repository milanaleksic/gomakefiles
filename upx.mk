# Depends on:
#   GOPATH

.PHONY: prepare_upx
prepare_upx: ${GOPATH}/bin/goupx \
	upx

upx:
	curl http://upx.sourceforge.net/download/upx-3.91-amd64_linux.tar.bz2 | tar xjvf - && mv upx-3.91-amd64_linux/upx upx && rm -rf upx-3.91-amd64_linux

${GOPATH}/bin/goupx:
	go get github.com/pwaller/goupx