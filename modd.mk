# Depends on:
#   GOPATH
#   modd.conf file in the project root

DEVD := ${GOPATH}/bin/devd
$(DEVD):
	go install github.com/milanaleksic/devd/cmd/devd@v1.0.3

MODD := ${GOPATH}/bin/modd
$(MODD):
	go install github.com/cortesi/modd/cmd/modd@v0.0.0-20210323234521-b35eddab86cc

.PHONY: dev
dev: $(DEVD) $(MODD)
	$(MODD)
