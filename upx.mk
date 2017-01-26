# Depends on:
#   GOPATH

UPX_ARCH := $(shell if grep -q arm <(uname -m); then echo 'armeb'; else echo 'amd64'; fi)
UPX_VERSION := 3.92

.PHONY: prepare_upx
prepare_upx:
	if [ "$$(upx -V > /dev/null 2>&1 && echo OK)" == "OK" ]; \
	then \
		ln -s $(shell which upx) upx; \
	elif [ "${UPX_ARCH}" == "amd64" ]; \
	then \
		curl -L https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-${UPX_ARCH}_linux.tar.xz | tar xJvf - && \
		mv upx-${UPX_VERSION}-${UPX_ARCH}_linux/upx upx && \
		rm -rf upx-${UPX_VERSION}-${UPX_ARCH}_linux; \
	else \
		echo Please install UPX for your ARM server via apt-get or fix Makefile to work with your system; \
		exit 1; \
	fi
