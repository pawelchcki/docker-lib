FROM ghcr.io/pawelchcki/docker-lib:latest as docker-lib

FROM busybox as build-extract-test-targets
COPY --from=docker-lib . /
WORKDIR /src
COPY docker-bake.hcl .

WORKDIR /output
RUN dl-bake-targets -g test /src/docker-bake.hcl | tee test-targets

FROM scratch as extract-test-targets
WORKDIR /build/extract-test-targets
COPY --from=build-extract-test-targets /output/test-targets .
