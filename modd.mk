# Depends on:
#   GOPATH
#   modd.conf file in the project root

DEVD := ${GOPATH}/bin/devd
$(DEVD):
	go get github.com/milanaleksic/devd/cmd/devd@v1.0.3

MODD := ${GOPATH}/bin/modd
$(MODD):
	go get github.com/cortesi/modd/cmd/modd

.PHONY: dev
dev: $(DEVD) $(MODD)
	$(MODD)
