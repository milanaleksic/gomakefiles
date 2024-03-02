.PHONY: govulncheck
govulncheck:
	@if [ -f go.work ]; \
	then \
		go work edit -json | jq -r '.Use[].DiskPath' | xargs -I{} bash -c 'govulncheck -v {}/... || true'; \
	else \
		govulncheck $(SOURCEDIR)/... || true; \
	fi