#syntax=docker/dockerfile:1.4
FROM ghcr.io/pawelchcki/docker-lib:latest as docker-lib

FROM busybox as fs-metadata-test
    WORKDIR /test-a
    COPY --from=docker-lib . /
    COPY *.sh /usr/bin/
    # dl-reset-fs-metadata should exist and be executable
    RUN set -xe; /usr/bin/dl reset-fs-metadata -h
    # by default generated tars will differe due to different metadata
    RUN mkdir folder_a; cd folder_a; echo "contents" > file
    RUN mkdir folder_b; cd folder_b; echo "contents" > file
    RUN tar cf tar_a -C folder_a .; tar cf tar_b -C folder_b .

    RUN set -xe; \
        if dl test-compare-files.sh tar_a tar_b; then echo "files shouldn't match"; exit 1; fi
     
    RUN rm tar_*; dl reset-fs-metadata -v **/* *
    RUN tar cf tar_a -C folder_a .; tar cf tar_b -C folder_b .

    RUN dl test-compare-files.sh tar_a tar_b



    

