FROM ubuntu:focal

# set version label
ARG BUILD_DATE
ARG VERSION
ARG S6_OVERLAY_VERSION=2.2.0.3

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
# ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.1/s6-overlay-amd64-installer /tmp/

RUN if [ "${TARGETPLATFORM}" == "linux/arm64" ] ; then \
      curl -o /tmp/s6-installer -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-aarch64-installer ; \
  elif [ "${TARGETPLATFORM}" == "linux/arm/v7" ] ; then \
      curl -o /tmp/s6-installer -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-armhf-installer ; \
  else \
      curl -o /tmp/s6-installer -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-amd64-installer ; \
  fi && \
  chmod +x /tmp/s6-installer && /tmp/s6-installer /

COPY root/ /

RUN echo "* create tkf user and make directories for the system to use*"
RUN groupmod -g 999 users
RUN useradd -u 999 -U -d /config -s /bin/false tkf
RUN usermod -G users tkf
RUN mkdir -p /config /defaults

VOLUME /config

ENTRYPOINT ["/init"]
