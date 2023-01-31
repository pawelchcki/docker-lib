FROM golang:1.18 as build

WORKDIR /go/src/app
COPY go.mod .

RUN go mod download
COPY . .
RUN go vet -v
RUN go test -v

RUN CGO_ENABLED=0 go build -o /go/bin/reset-fs-metadata

FROM scratch
COPY --from=build /go/bin/reset-fs-metadata ./dl-reset-fs-metadata
ENTRYPOINT ["/dl-reset-fs-metadata"]
