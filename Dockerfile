FROM ubuntu:18.04

# set version label
ARG BUILD_DATE
ARG VERSION
ARG S6_OVERLAY_VERSION=1.22.1.0

#ARG VERSION_WGET=1.19.4-1
#ARG VERSION_TZDATA=2019c-0
#ARG VERSION_CURL=7.58.0-2

ARG VERSION_WGET=1.19.4-1ubuntu2.2
ARG VERSION_TZDATA=2019c-0ubuntu0.18.04
ARG VERSION_CURL=7.58.0-2ubuntu3.8

ENV TZ "America/Denver"

LABEL build_version="teknofile.org version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="teknofile <teknofile@teknofile.org>"


WORKDIR /

RUN apt-get update -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  wget=$VERSION_WGET \
  tzdata=$VERSION_TZDATA \
  curl=$VERSION_CURL && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN curl -o /tmp/s6-overlay-amd64.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-amd64.tar.gz && \
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
