#多阶段构建  第一阶段：编译阶段
FROM golang:1.15-alpine as builder
WORKDIR /usr/src/app
ENV GOPROXY=https://goproxy.cn
COPY ./go.mod ./
COPY ./go.sum ./
RUN go mod download
#将宿主机所有文件copy到镜像中
COPY . .
RUN ls
RUN pwd
# 将main.go程序执行文件copy到镜像目录,不然go build无法编译
COPY ./cmd/  ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on  go build -o server
#第二阶段：运行阶段,最终以最后一个阶段为准
FROM golang:1.15-alpine
WORKDIR  /src
#COPY --from将编译阶段的产物copy到运行阶段
COPY --from=builder /usr/src/app/server /src/app/
COPY --from=builder /usr/src/app/config /src/config/
CMD ["/src/app/server"]

