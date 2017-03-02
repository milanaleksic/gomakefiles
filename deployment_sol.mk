.PHONY: deploy_sol
deploy_sol: ${RELEASE_SOURCES}
	@echo Building and shipping ${GOOS} ${GOARCH}
	cd ${MAIN_APP_DIR} && go build -ldflags '-s -w -X main.Version=${TAG}' -o ${APP_NAME}
	./upx -q $(FULL_APP_PATH)
	ssh sol 'mkdir -p /volume1/artifacts/${APP_NAME}/'
	scp $(FULL_APP_PATH) sol:/volume1/artifacts/${APP_NAME}/${APP_NAME}-${TAG}-${GOOS}-${GOARCH}
