#syntax=docker/dockerfile:1.4
FROM ghcr.io/pawelchcki/docker-lib:latest as docker-lib

FROM busybox as fs-metadata-test
    WORKDIR /test-a
    COPY --from=docker-lib . /
    # scripts should exists and be executable
    RUN set -xe; \
        /usr/bin/dl-reset-fs-metadata -h; \
        /usr/bin/dl-bake-targets -h; \
        test -x /usr/bin/dl-isolate-cargo; \
        test -x /usr/bin/dl-test-compare-files;
    # Test dl-reset-fs-metadata
        # by default generated tars will differe due to different metadata
        RUN mkdir folder_a; cd folder_a; echo "contents" > file
        RUN mkdir folder_b; cd folder_b; echo "contents" > file
        RUN tar cf tar_a -C folder_a .; tar cf tar_b -C folder_b .

        RUN set -xe; \
            if dl-test-compare-files tar_a tar_b; then echo "files shouldn't match"; exit 1; fi
        
        RUN rm tar_*; dl-reset-fs-metadata -v **/* *
        RUN tar cf tar_a -C folder_a .; tar cf tar_b -C folder_b .

        # files with reset metadata are exactly the same
        RUN dl-test-compare-files tar_a tar_b



    

