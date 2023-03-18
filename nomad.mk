NOMAD := $(SOURCEDIR)/nomad
$(NOMAD):
	@echo "installing 'nomad' executable: $(NOMAD) version $(NOMAD_VERSION)"
	@curl -L -O https://releases.hashicorp.com/nomad/$(NOMAD_VERSION)/nomad_$(NOMAD_VERSION)_linux_amd64.zip
	@unzip nomad*.zip && chmod +x nomad

.PHONY: cd-nomad
cd-nomad: $(NOMAD)
ifndef NOMAD_TARGET
	$(error NOMAD_TARGET parameter must be set: make NOMAD_TARGET=<NOMAD_TARGET_VALUE>)
endif
ifeq ($(IS_REAL_VERSION),true)
	export $(NOMAD) run \
			-var image_version=${VERSION} \
			$(NOMAD_EXTRA_ARGS) \
			$(NOMAD_TARGET)
endif
