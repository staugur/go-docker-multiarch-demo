ARG buildos=golang:1.17.0-alpine
ARG runos=scratch

# -- build dependencies with alpine --
FROM $buildos AS builder

WORKDIR /build

COPY . .

ARG TARGETARCH
ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "Running on $BUILDPLATFORM, building for $TARGETPLATFORM and $TARGETARCH" && \
    echo $(go env GOOS GOARCH GOVERSION)

RUN go env -w GOPROXY=https://goproxy.cn,direct && \
    CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH go build -ldflags "-s -w" .

# run application with a small image
FROM $runos

COPY --from=builder /build/testarch /bin/

EXPOSE 9999

ENTRYPOINT ["testarch"]
