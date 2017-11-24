FROM golang:1.9 AS builder

COPY Makefile out_redis.go /go/src/github.com/majst01/fluent-bit-go-redis-output/

RUN cd /go/src/github.com/majst01/fluent-bit-go-redis-output/ \
 && go get github.com/fluent/fluent-bit-go/output \
 && go get github.com/garyburd/redigo/redis \
 && make


FROM fluent/fluent-bit

COPY --from=builder /go/src/github.com/majst01/fluent-bit-go-redis-output/out_redis.so /fluent-bit/bin/

CMD ["/fluent-bit/bin/fluent-bit", "-c", "/fluent-bit/etc/fluent-bit.conf", "-e", "/fluent-bit/bin/out_redis.so", "-o", "redis", "-i", "cpu"]