LEVANT := $(SOURCEDIR)/levant
$(LEVANT):
	@echo "installing 'levant' executable: $(LEVANT) version $(LEVANT_VERSION)"
	@curl -L -O https://releases.hashicorp.com/levant/$(LEVANT_VERSION)/levant_$(LEVANT_VERSION)_linux_amd64.zip
	@unzip levant*.zip && chmod +x levant

ifdef LEVANT_VAR_FILE
LEVANT_ARG_VAR_FILE := "-var-file=$(LEVANT_VAR_FILE)"
else
LEVANT_ARG_VAR_FILE :=
endif
ifdef LEVANT_CONSUL_LOCATION
LEVANT_ARG_CONSUL_ADDRESS := "-consul-address=$(LEVANT_CONSUL_LOCATION)"
else
LEVANT_ARG_CONSUL_ADDRESS :=
endif

.PHONY: cd-levant
cd-levant: $(LEVANT)
ifndef LEVANT_TARGET
	$(error LEVANT_TARGET parameter must be set: make LEVANT_TARGET=<LEVANT_TARGET_VALUE>)
endif
ifeq ($(IS_REAL_VERSION),true)
	export VERSION=${VERSION} && $(LEVANT) $(LEVANT_ARG_VAR_FILE) $(LEVANT_ARG_CONSUL_ADDRESS) deploy $(LEVANT_TARGET)
endif
