#!/bin/bash

JMETER_VERSION="5.3"

# Example build line
# --build-arg IMAGE_TIMEZONE="Europe/Amsterdam"
docker build  --no-cache --build-arg JMETER_VERSION=${JMETER_VERSION} -t "jmeter:${JMETER_VERSION}" .
