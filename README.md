# docker-base-ubuntu-s6

Docker-cacti is an implementation of cacti inside of a docker container. This container is based off of s6-overlay and uses much of the same structure as the folks at [linuxserver.io](https://github.com/linuxserver). 
This container, when started stores it's data and state in /config. The cacti application runs behind nginx and the image itself is runs in an ubuntu based image. 

This is a bsae ubuntu image, currently being built from `ubuntu:18.04`. The intent really isn't to use this specifically as an image directly, but to inherit additional images from. This container, installs the s6-overlay system into the image. The current architecture should be respected when doing so too. 

When building images from this, create a `/etc/services.d/<servicename>/run` script to start it up. Additional configuratino scripts can be placed in `/etc/cont-init.d/<script name>`. 


## Multi-Arch
I'm building these images using the docker buildx plugin for arm, arm64 and amd64. Pulling `wtfo/docker-base-ubuntu-s6` should pull the correct arch through some manifest magic.

## Support
If you need help, open up an [issue on GitHub](https://github.com/teknofile/docker-docker-base-ubuntu-s6).


