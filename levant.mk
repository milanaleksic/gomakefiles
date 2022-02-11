LEVANT := $(SOURCEDIR)/levant
$(LEVANT):
	@echo "installing 'levant' executable: $(LEVANT) version $(LEVANT_VERSION)"
	@curl -L -O https://releases.hashicorp.com/levant/$(LEVANT_VERSION)/levant_$(LEVANT_VERSION)_linux_amd64.zip
	@unzip levant*.zip && chmod +x levant

.PHONY: cd-levant
cd-levant: $(LEVANT)
	$(LEVANT) .github/workflows/thoughttrain.nomad
