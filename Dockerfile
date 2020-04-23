FROM ubuntu:18.04

# set version label
ARG BUILD_DATE
ARG VERSION
ARG S6_OVERLAY_VERSION=1.22.1.0

ENV TZ "America/Denver"

LABEL build_version="teknofile.org version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="teknofile <teknofile@teknofile.org>"


WORKDIR /

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget tzdata curl && \
    curl -o /tmp/s6-overlay-amd64.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz && \
    tar xzf /tmp/s6-overlay-amd64.tar.gz -C / && \
    rm /tmp/s6-overlay-amd64.tar.gz


RUN echo "**** create abc user and make our folders ****" && \
  groupmod -g 1000 users && \
  useradd -u 911 -U -d /config -s /bin/false abc && \
  usermod -G users abc && \
  mkdir -p \
  /app \
  /config \
  /defaults

ENTRYPOINT ["/init"]
