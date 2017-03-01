# Depends on:
#   GOPATH

.PHONY: prepare_wago
prepare_wago: ${GOPATH}/bin/wago

${GOPATH}/bin/wago:
	go get github.com/milanaleksic/wago

DIRECTORIES_WITH_GO_TO_WATCH := $(shell find $(SOURCEDIR) -maxdepth 1 -type d \
	-not -path ./gomakefiles \
	-not -path './vendor*' \
	-not -path './.*' \
	| xargs realpath | awk '{ print "(" $$1 "/[^.\\/]+\\.(go|toml))|" }' | paste -sd '' -)

.PHONY: tdd
tdd:
	wago -cmd "$(MAKE) test" -watch '/[^\\.]+\.go": (CREATE|MODIFY$$)'

.PHONY: watch
watch:
	wago -cmd '$(MAKE) run' -watch "$(DIRECTORIES_WITH_GO_TO_WATCH)nonexisting\": (CREATE|MODIFY$$)"