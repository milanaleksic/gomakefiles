# Depends on:
#   GOPATH

.PHONY: prepare_wago
prepare_wago: ${GOPATH}/bin/wago

${GOPATH}/bin/wago:
	go get github.com/milanaleksic/wago

wago-tdd:
	wago -cmd "$(MAKE) test" -watch '/[^\\.]+\.go": (CREATE|MODIFY$$)'