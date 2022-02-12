# Depends on:
#   GOPATH

WAGO := ${GOPATH}/bin/wago

$(WAGO):
	go install github.com/milanaleksic/wago@latest

DIRECTORIES_WITH_GO_TO_WATCH := $(shell find $(SOURCEDIR) -maxdepth 1 -type d \
	-not -path ./gomakefiles \
	-not -path './vendor*' \
	-not -path './.*' \
	| xargs realpath | awk '{ print "(" $$1 "/[^.\\/]+\\.(go|toml))|" }' | paste -sd '' -)

.PHONY: tdd
tdd:
	$(WAGO) -cmd "$(MAKE) test" -watch '/[^\\.]+\.go": (CREATE|MODIFY$$)'

.PHONY: watch
watch: | $(WAGO)
	$(WAGO) -cmd '$(MAKE) run' -watch "$(DIRECTORIES_WITH_GO_TO_WATCH)nonexisting\": (CREATE|MODIFY$$)"