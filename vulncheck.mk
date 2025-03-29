.PHONY: govulncheck
govulncheck:
	@if [ -f go.work ]; \
	then \
		go work edit -json | jq -r '.Use[].DiskPath' | xargs -I{} bash -c 'echo "running govulncheck on {}" && cd {} && govulncheck -show verbose || true'; \
	else \
		govulncheck -show verbose || true; \
	fi