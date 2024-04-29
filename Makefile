APP=${shell basename $(shell git remote get-url origin)}
REGISTRY=PavloPryimachov
VERSION=${shell git describe --tags --abbrev=0}-${shell git rev-parse --short HEAD}
TARGETOS=linux
TARGETARCH=amd64

format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

test:
	go test -v

build:
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/PavloPryimachov/kbot/cmd.appVersion=${VERSION}

linux:
	${shell make build TARGETOS=linux TARGETARCH=${shell dpkg --print-architecture}} 

arm:
	${shell make build TARGETOS=linux TARGETARCH=${shell dpkg --print-architecture}}

macos:
	${shell make build TARGETOS=darwin TARGETARCH=${shell dpkg --print-architecture}}

windows:
	${shell make build TARGETOS=windows TARGETARCH=${shell dpkg --print-architecture}}

image: 
	docker build --platform=${TARGETOS}/${TARGETARCH} -t ${APP}:${VERSION}-${TARGETARCH} .

push:
	docker push ${APP}:${VERSION}-${TARGETARCH}

clean:
	docker rmi ${APP}:${VERSION}-${TARGETARCH}