# Depends on:
#   GOPATH

GOIMPORTS := ${GOPATH}/bin/goimports

$(GOIMPORTS):
	go get -u golang.org/x/tools/cmd/goimports

.PHONY: goimports_check
goimports_check: | $(GOIMPORTS)
	@BAD_FILES_COUNT="$$($(GOIMPORTS) -l . | grep -v vendor | wc -l)"; \
	if [ "$$BAD_FILES_COUNT" != "0" ]; \
	then \
		echo -e "There is/are $$BAD_FILES_COUNT file(s) with bad formatting:"; \
		$(GOIMPORTS) -l . | grep -v vendor; \
		exit 1; \
	fi
