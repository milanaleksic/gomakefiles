# Depends on:
#   GOPATH
#   modd.conf file in the project root

MODD := ${GOPATH}/bin/modd

$(MODD):
	go get github.com/cortesi/modd

.PHONY: dev
dev:
	$(MODD)
