FROM alpine

ARG VERSION=0.18.1
ARG GLIBC_VERSION=2.22-r8

ENV FILENAME bitcoin-${VERSION}-arm-linux-gnueabihf.tar.gz
ENV DOWNLOAD_URL https://bitcoin.org/bin/bitcoin-core-${VERSION}/${FILENAME}

# Some of this was unabashadly yanked from
# https://github.com/szyhf/DIDockerfiles/blob/master/bitcoin/alpine/Dockerfile

RUN apk update \
  && apk --no-cache add wget tar bash ca-certificates \
  && wget https://github.com/armhf-docker-library/alpine-pkg-glibc/releases/download/2.22/glibc-${GLIBC_VERSION}.apk \
  && wget https://github.com/armhf-docker-library/alpine-pkg-glibc/releases/download/2.22/glibc-bin-${GLIBC_VERSION}.apk \
  && apk --no-cache --allow-untrusted add glibc-${GLIBC_VERSION}.apk \
  && apk --no-cache --allow-untrusted add glibc-bin-${GLIBC_VERSION}.apk \
  && rm -rf /glibc-${GLIBC_VERSION}.apk \
  && rm -rf /glibc-bin-${GLIBC_VERSION}.apk \
  && wget $DOWNLOAD_URL \
  && tar xzvf /bitcoin-${VERSION}-arm-linux-gnueabihf.tar.gz \
  && mkdir /root/.bitcoin \
  && mv /bitcoin-${VERSION}/bin/* /usr/local/bin/ \
  && rm -rf /bitcoin-${VERSION}/ \
  && rm -rf /bitcoin-${VERSION}-arm-linux-gnueabihf.tar.gz \
  && apk del tar wget ca-certificates

EXPOSE 8332 8333 18332 18333 28332 28333

ADD VERSION .
ADD ./bin/docker_entrypoint.sh /usr/local/bin/docker_entrypoint.sh
RUN chmod a+x /usr/local/bin/docker_entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker_entrypoint.sh"]
