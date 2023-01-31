FROM scratch as isolate-cargo
FROM scratch as reset-fs-metadata

FROM scratch as staging-area
COPY --from=isolate-cargo . .
COPY --from=reset-fs-metadata . .

FROM scratch as final
WORKDIR /usr/bin
COPY --from=staging-area . .