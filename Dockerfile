ARG buildos=golang:1.17.0-alpine
ARG runos=alpine

# -- build dependencies with alpine --
FROM --platform=$BUILDPLATFORM $buildos AS builder

WORKDIR /build

COPY . .

ARG ARCH
ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "Running on $BUILDPLATFORM, building for $TARGETPLATFORM" && \
    go env GOOS GOARCH GOVERSION

RUN go env -w GOPROXY=https://goproxy.cn,direct && \
    go build -ldflags "-s -w" .

# run application with a small image
FROM --platform=$BUILDPLATFORM $runos

COPY --from=builder /build/testarch /bin/

EXPOSE 9999

ENTRYPOINT ["testarch"]
