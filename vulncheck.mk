# Depends on:
#   GOPATH

GOVULNCHECK := ${GOPATH}/bin/govulncheck

$(GOVULNCHECK):
	@echo "installing 'govulncheck' executable: $(GOVULNCHECK)GOVULNCHECK"
	@go install golang.org/x/vuln/cmd/govulncheck@latest

.PHONY: govulncheck
govulncheck: $(GOVULNCHECK)
	@if [ -f go.work ]; \
	then \
		go work edit -json | jq -r '.Use[].DiskPath' | xargs -I{} bash -c 'govulncheck -v {}/... || true'; \
	else \
		govulncheck $(SOURCEDIR)/... || true; \
	fi