FROM ubuntu:focal

# set version label
ARG BUILD_DATE
ARG VERSION
ARG S6_OVERLAY_VERSION=1.22.1.0

ARG TARGETPLATFORM

ENV TZ "America/Denver"

LABEL build_version="teknofile.org version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="teknofile <teknofile@teknofile.org>"

WORKDIR /

RUN apt-get update -y --no-install-recommends && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  bash \
  wget \
  tzdata \
  curl \
  ca-certificates && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Get the correct version of the s6 overlay and story it in /tmp
COPY ./build_scripts/get_s6.sh /tmp/
#RUN chmod u+x /tmp/get_s6.sh && /tmp/get_s6.sh $TARGETPLATFORM $S6_OVERLAY_VERSION

RUN echo "Downloading and installing S6-overlay for ${TARGETPLATFORM}"
RUN if [ `uname -m` == "aarch64" ] ; then \
      curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-aarch64.tar.gz ; \
  elif [ `uname -m` == "armv7l" ] ; then \
      curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-armhf.tar.gz ; \
  else \
      curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz ; \
  fi

RUN tar xzf /tmp/s6-overlay.tar.gz -C /

COPY root/ /

RUN echo "* create tkf user and make directories for the system to use*"
RUN groupmod -g 999 users
RUN useradd -u 999 -U -d /config -s /bin/false tkf
RUN usermod -G users tkf
RUN mkdir -p /config /defaults

VOLUME /config

ENTRYPOINT ["/init"]
