CONTAINER=mstodo
VERSION=1.0.0
PWD:=$(shell pwd)
PORT=3001

.PHONY: dockerimg
dockerimg:
	docker build --force-rm \
		-t ${CONTAINER}:${VERSION} \
		-t ${CONTAINER}:latest \
		.

.PHONY: docker-%
docker-%:
	docker run --rm -it \
		-v ${PWD}:/app \
		-p ${PORT}:${PORT} \
		${CONTAINER}:latest \
		make $*

.PHONY: build
build:
	dotnet build

.PHONY: run
run:
	dotnet run --project Website
