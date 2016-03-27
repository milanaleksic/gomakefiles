# Depends on:
#   GOPATH

UPX_ARCH := $(shell if grep -q arm <(uname -m); then echo 'armeb'; else echo 'amd64'; fi)

.PHONY: prepare_upx
prepare_upx: ${GOPATH}/bin/goupx \
	upx

upx:
	if [ "$$(upx -V > /dev/null 2>&1 && echo OK)" == "OK" ]; \
	then \
		ln -s $(shell which upx) tools/upx; \
	elif [ "${UPX_ARCH}" == "amd64" ]; \
	then \
		curl http://upx.sourceforge.net/download/upx-3.91-${UPX_ARCH}_linux.tar.bz2 | tar xjvf - && \
		mv upx-3.91-${UPX_ARCH}_linux/upx tools/upx && \
		rm -rf upx-3.91-${UPX_ARCH}_linux; \
	else \
		echo Please install UPX for your ARM server via apt-get or fix Makefile to work with your system; \
		exit 1; \
	fi

${GOPATH}/bin/goupx:
	go get github.com/pwaller/goupx
