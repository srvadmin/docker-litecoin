FROM ubuntu:17.04
MAINTAINER Sadykh Sadykhov <sadykh.sadykhov@ya.ru>

RUN groupadd -r litecoin && useradd -r -m -g litecoin litecoin

ENV LITECOIND_VERSION	0.14.2
RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends dirmngr gosu gpg wget \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \

    && wget https://download.litecoin.org/litecoin-$LITECOIND_VERSION/linux/litecoin-$LITECOIND_VERSION-x86_64-linux-gnu.tar.gz --no-check-certificate \ 
    && tar -zvxf litecoin-$LITECOIND_VERSION-x86_64-linux-gnu.tar.gz \
    && mv litecoin-$LITECOIND_VERSION/bin/* /usr/bin

# create data directory
ENV LITECOIN_DATA /data
RUN mkdir $LITECOIN_DATA \
  && chown -R litecoin:litecoin $LITECOIN_DATA \
  && ln -sfn $LITECOIN_DATA	 /home/litecoin/.litecoin \
  && chown -h litecoin:litecoin /home/litecoin/.litecoin

VOLUME /data

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
EXPOSE 9333 19333 2339 23391