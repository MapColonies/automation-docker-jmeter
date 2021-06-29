#!/bin/bash
#
# Run JMeter Docker image with options

NAME="jmeter"
IMAGE="jmeter:5.3"

# Finally run
docker stop ${NAME} > /dev/null 2>&1
docker rm ${NAME} > /dev/null 2>&1
docker run --net=host --name ${NAME} -i -e R_DIR=${R_DIR} -e T_DIR=${T_DIR} -v ${PWD}:${PWD} -w ${PWD} ${IMAGE} $@
