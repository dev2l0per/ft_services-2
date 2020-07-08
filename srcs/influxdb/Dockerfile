FROM alpine:latest

RUN apk add influxdb --no-cache

EXPOSE 8086

# mkdir -p /run/influxd 를 만들고
# ENTRYPOINT ["influxd"] 실행하는거랑 같음.
ENTRYPOINT ["/usr/sbin/influxd"]
