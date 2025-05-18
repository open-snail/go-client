# 构建阶段
FROM golang:1.23.3-alpine AS builder

WORKDIR /app

# 复制依赖文件
COPY go.mod go.sum ./

# 下载依赖项
RUN go mod download

# 复制源代码
COPY . .

# 整理依赖关系
RUN go mod tidy

# 编译应用
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main

# 运行阶段
FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/main /app/main

EXPOSE 17889
CMD ["./main"]