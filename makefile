# Arquivo Go
GO_FILE := ./main.go

GOPATH := $(shell go env GOPATH)

deploy:
	cd ./lambda/users/persist-user && env GOARCH=amd64 GOOS=linux CGO_ENABLED=0 go build -ldflags="-s -w" -o ../../../bin/persist_user/main $(GO_FILE)
	cd ./lambda/proxy && env GOARCH=amd64 GOOS=linux CGO_ENABLED=0 go build -ldflags="-s -w" -o ../../bin/proxy/main $(GO_FILE)
	zip -j ./bin/proxy/proxy.zip ./bin/proxy/main
	zip -j ./bin/persist_user/persist_user.zip ./bin/persist_user/main
	cd terraform && tflocal plan
