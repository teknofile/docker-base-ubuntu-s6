FROM ubuntu:18.04

# set version label
ARG BUILD_DATE
ARG VERSION
ARG S6_OVERLAY_VERSION=1.22.1.0

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM" > /log


#ARG VERSION_WGET=1.19.4-1
#ARG VERSION_TZDATA=2019c-0
#ARG VERSION_CURL=7.58.0-2

ARG VERSION_WGET=1.19.4-1ubuntu2.2
ARG VERSION_TZDATA=2019c-0ubuntu0.18.04
ARG VERSION_CURL=7.58.0-2ubuntu3.8
ARG VERSION_CACERT=20180409

ENV TZ "America/Denver"

LABEL build_version="teknofile.org version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="teknofile <teknofile@teknofile.org>"

WORKDIR /

RUN apt-get update -y --no-install-recommends && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  wget=$VERSION_WGET \
  tzdata=$VERSION_TZDATA \
  curl=$VERSION_CURL \
  ca-certificates=$VERSION_CACERT && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*


# Get the correct version of the s6 overlay and story it in /tmp
COPY ./build_scripts/get_s6.sh /tmp/
RUN chmod u+x /tmp/get_s6.sh && /tmp/get_s6.sh $TARGETPLATFORM $S6_OVERLAY_VERSION

RUN echo "**** create abc user and make our folders ****" && \
  groupmod -g 1000 users && \
  useradd -u 911 -U -d /config -s /bin/false abc && \
  usermod -G users abc && \
  mkdir -p \
  /app \
  /config \
  /defaults

ENTRYPOINT ["/init"]
