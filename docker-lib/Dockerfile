#syntax=docker/dockerfile:1.4
FROM scratch as common
FROM scratch as reset-fs-metadata

FROM scratch as staging-area
    WORKDIR /usr/bin
    COPY --from=common . .
    COPY --from=reset-fs-metadata . .

FROM scratch as final
    COPY --from=staging-area . .