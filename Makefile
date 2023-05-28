APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=tarnax
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

linux:

windows:

macos:


image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARC}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARC}

clean:
	docker rmi <IMAGE_TAG>
