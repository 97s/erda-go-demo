FROM golang:1.16-alpine3.14 as build
LABEL maintainer="AbyssViper<root@viper.run>"
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64 \
    GOPROXY=https://goproxy.cn

WORKDIR /build
COPY main.go ./go-web/main.go
COPY go.mod ./go-web/go.mod
RUN cd go-web \
    && go build -o /build/dist/server . \
    && rm -rf /build/antiddos

FROM alpine:3.12
LABEL maintainer="AbyssViper<root@viper.run>"
ENV LANG=en_US.UTF-8
COPY --from=build /build/dist/server /opt
RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main/" > /etc/apk/repositories \
    && apk add --no-cache -U bash

WORKDIR /opt
EXPOSE 8080

CMD ["./server"]
