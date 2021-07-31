# Depends on:
#   GOPATH
#   modd.conf file in the project root

DEVD_VERSION := 'v1.0.3'

DEVD := ${GOPATH}/bin/devd
$(DEVD):
	@echo "installing 'devd' executable: $(DEVD) version $(DEVD_VERSION)"
	go install github.com/milanaleksic/devd/cmd/devd@$(DEVD_VERSION)

MODD_VERSION := 'v0.0.0-20210323234521-b35eddab86cc'

MODD := ${GOPATH}/bin/modd
$(MODD):
	@echo "installing 'modd' executable: $(MODD) version $(MODD_VERSION)"
	go install github.com/cortesi/modd/cmd/modd@$(MODD_VERSION)

.PHONY: dev
dev: $(DEVD) $(MODD)
	$(MODD)
