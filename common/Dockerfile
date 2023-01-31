FROM busybox as builder
WORKDIR /build
COPY *.sh .
RUN find -name "*.sh" | xargs -i -n 1 sh -c 'mv {} $(echo "{}" | sed -e "s#\([^/]*\).sh#dl-\1#g")'  

FROM scratch
COPY --from=builder /build/* /
