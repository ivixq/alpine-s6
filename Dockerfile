FROM alpine:edge
LABEL maintainer=ivixq

ARG TZ=Asia/Shanghai 
ARG S6_OVERLAY_VERSION=v2.0.0.1

ENV DEBUG_MODE=FALSE \ 
    ENABLE_ZABBIX=FALSE \
    ENABLE_CRON=FALSE \
    ENABLE_SMTP=FALSE \
    TERM=xterm

RUN apk --no-cache upgrade ; \
    apk --no-cache add \
        bash \
        curl \
        logrotate \
        msmtp \
	mutt \
        su-exec \
        tzdata \ 
        zabbix-agent2 \
        zabbix-utils \
        ; \
    rm -rf /var/cache/apk/* ; \
    rm -rf /etc/logrotate.d/acpid ; \
    cp -R /usr/share/zoneinfo/$TZ /etc/localtime ; \
    echo $TZ > /etc/timezone ; \
    \   
    curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar xfz - -C / ; \
    mkdir -p /sfiles/cron

COPY rootfs /

EXPOSE 10050/TCP

ENTRYPOINT ["/init"]

CMD []
