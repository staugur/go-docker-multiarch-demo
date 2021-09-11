ARG buildos=golang:1.17.0-alpine
ARG runos=scratch

# -- build dependencies with alpine --
FROM $buildos AS builder

WORKDIR /build

COPY . .

ARG TARGETARCH

RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH go build -ldflags "-s -w" .

# run application with a small image
FROM $runos

COPY --from=builder /build/testarch /bin/

EXPOSE 9999

ENTRYPOINT ["testarch"]
