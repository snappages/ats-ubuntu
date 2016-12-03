# Updated 12/03/2016
FROM ubuntu:16.04
MAINTAINER TJ Horlacher <tjhorlacher@me.com>

ENV TS_VERSION=${TS_VERSION:-7.0.0}
ENV TS_PKG=${TS_PKG:-trafficserver-$TS_VERSION.tar.bz2}
ENV TS_URL=${TS_URL:-http://www-us.apache.org/dist/trafficserver/$TS_PKG}
ENV TS_PATH=${TS_PATH:-/opt/trafficserver}
ENV PATH=$TS_PATH/bin:$PATH

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y wget build-essential locales bzip2 libssl-dev libxml2-dev libpcre3-dev tcl-dev libboost-dev supervisor \
    && mkdir -p $TS_PATH \
    && wget $TS_URL -O /tmp/$TS_PKG && tar -xjf /tmp/$TS_PKG -C /tmp && cd /tmp/trafficserver-$TS_VERSION \
    && ./configure --prefix=$TS_PATH \
    && make && make install \
    && mv $TS_PATH/etc/trafficserver /etc/trafficserver \
    && ln -sf /etc/trafficserver $TS_PATH/etc/trafficserver \
    && rm -rf /tmp/* && apt-get purge -y bzip2 build-essential

COPY config/* /etc/trafficserver/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod 0755 /docker-entrypoint.sh && chown -R nobody:nogroup /etc/trafficserver

EXPOSE 8080 8083

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/bin/supervisord"]
