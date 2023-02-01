FROM golang:1.18 as base
    WORKDIR /go/src/app
    COPY go.mod go.sum .

    RUN go mod download
    COPY . .

FROM base as build
    RUN CGO_ENABLED=0 go build -o /go/bin/bake-targets

FROM base as test
    RUN go test -v
    RUN echo 'group "group" { targets = ["target"] }' > docker-bake.hcl
    RUN set -xe; if [ "xx$(go run . -g 'group' docker-bake.hcl )" = "xx" ]; then echo "empty output"; exit 1; fi

FROM base as lint
    RUN go vet -v

FROM scratch
    COPY --from=build /go/bin/bake-targets ./dl-bake-targets
    ENTRYPOINT ["/dl-bake-targets"]
