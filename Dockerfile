FROM ubuntu:20.04

# set version label
ARG BUILD_DATE
ARG VERSION
ARG S6_OVERLAY_VERSION=1.22.1.0

ARG TARGETPLATFORM
ARG BUILDPLATFORM

ENV TZ "America/Denver"

LABEL build_version="teknofile.org version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="teknofile <teknofile@teknofile.org>"

WORKDIR /

RUN apt-get update -y --no-install-recommends && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  wget \
  tzdata \
  curl \
  ca-certificates && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Get the correct version of the s6 overlay and story it in /tmp
COPY ./build_scripts/get_s6.sh /tmp/
RUN chmod u+x /tmp/get_s6.sh && /tmp/get_s6.sh $TARGETPLATFORM $S6_OVERLAY_VERSION
#RUN rm -f /tmp/get_s6.sh

COPY root/ /

RUN echo "* create tkf user and make directories for the system to use*" && \
  groupmod -g 999 users && \
  useradd -u 999 -U -d /config -s /bin/false tkf && \
  usermod -G users tkf && \
  mkdir -p \
  /config \
  /defaults

VOLUME /config

ENTRYPOINT ["/init"]
