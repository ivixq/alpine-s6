FROM alpine:edge
LABEL maintainer=ivixq

ENV DEBUG_MODE=FALSE \ 
    ENABLE_ZABBIX=FALSE \
    ENABLE_CRON=FALSE \
    ENABLE_SMTP=FALSE \
    TIMEZONE=Asia/Shanghai \
    S6_OVERLAY_VERSION=v2.0.0.1 \
    TERM=xterm

RUN apk --no-cache upgrade ; \
    apk --no-cache add \
        bash \
        curl \
        iputils \
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
    cp -R /usr/share/zoneinfo/${TIMEZONE} /etc/localtime ; \
    echo ${TIMEZONE} > /etc/timezone ; \
    \   
    curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar xzf - -C / ; \
    mkdir -p /assets/cron

ADD /install /

EXPOSE 10050/TCP

ENTRYPOINT ["/init"]

CMD []
