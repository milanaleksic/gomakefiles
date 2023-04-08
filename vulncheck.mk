# Depends on:
#   GOPATH

GOVULNCHECK := ${GOPATH}/bin/govulncheck

$(GOVULNCHECK):
	@echo "installing 'govulncheck' executable: $(GOVULNCHECK)GOVULNCHECK"
	@go install golang.org/x/vuln/cmd/govulncheck@latest

.PHONY: govulncheck
govulncheck:
	govulncheck ./...