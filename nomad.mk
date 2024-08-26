.PHONY: cd-nomad
cd-nomad:
ifndef NOMAD_TARGET
	$(error NOMAD_TARGET parameter must be set: make NOMAD_TARGET=<NOMAD_TARGET_VALUE>)
endif
ifeq ($(IS_REAL_VERSION),true)
	$(NOMAD) run \
			-var image_version=${VERSION} \
			$(NOMAD_EXTRA_ARGS) \
			$(NOMAD_TARGET)
endif
