#syntax=docker/dockerfile:1.4
FROM ghcr.io/pawelchcki/docker-lib:latest as docker-lib

FROM busybox as cargo-isaltion
    COPY --from=docker-lib . /
    WORKDIR /test-a/1/

    COPY cargo .

    RUN dl-isolate-rust-cargo-tomls /isolated_1/

    WORKDIR /test-a/2/

    COPY cargo .

    RUN echo "//different src contents" > src/lib.rs
    RUN dl-isolate-rust-cargo-tomls /isolated_2/

    WORKDIR /test-a/verify

    RUN set -xe; \
        dl-reset-fs-metadata ../* ../**/*; \
        tar cf tar_1 -C /test-a/1 .; \
        tar cf tar_1_isolated -C /isolated_1 .; \
        tar cf tar_2 -C /test-a/2 .; \
        tar cf tar_2_isolated -C /isolated_2 .

    RUN if dl-test-compare-files tar_1 tar_2; then echo "sources shouldn't match"; exit 1; fi

    # isolated sources should compress to exactly same tar's
    RUN dl-test-compare-files tar_1_isolated tar_2_isolated