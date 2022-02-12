LEVANT := $(SOURCEDIR)/levant
$(LEVANT):
	@echo "installing 'levant' executable: $(LEVANT) version $(LEVANT_VERSION)"
	@curl -L -O https://releases.hashicorp.com/levant/$(LEVANT_VERSION)/levant_$(LEVANT_VERSION)_linux_amd64.zip
	@unzip levant*.zip && chmod +x levant

.PHONY: cd-levant
cd-levant: $(LEVANT)
ifndef LEVANT_TARGET
	$(error LEVANT_TARGET parameter must be set: make LEVANT_TARGET=<LEVANT_TARGET_VALUE>)
endif
	$(LEVANT) deploy -var-file=$(LEVANT_VAR_FILE) $(LEVANT_TARGET)
