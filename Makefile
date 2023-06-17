APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=TaRNaX
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARC=arm64

get:
	go get

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARC} go build -v -o kbot -ldflags "-X="github.com/TaRNaX/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t https://ghcr.io/${REGISTRY}/${APP}:${VERSION}-${TARGETARC}-${TARGETOS}

push:
	docker push https://ghcr.io/${REGISTRY}/${APP}:${VERSION}-${TARGETARC}-${TARGETOS}

clean:
	docker rmi https://ghcr.io/${REGISTRY}/${APP}:${VERSION}-${TARGETARC}-${TARGETOS}

linux: build TARGETARC=linux TARGETARC=arm64
	docker build . -t https://ghcr.io/${REGISTRY}/${APP}:${VERSION}-${TARGETARC}-${TARGETOS}

windows: build TARGETARC=windows TARGETARC=arm64
	docker build . -t https://ghcr.io/${REGISTRY}/${APP}:${VERSION}-${TARGETARC}-${TARGETOS}

macos: build TARGETARC=darwin TARGETARC=arm64
	docker build . -t https://ghcr.io/${REGISTRY}/${APP}:${VERSION}-${TARGETARC}-${TARGETOS}