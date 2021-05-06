#!/bin/bash

resultsDir=tests/mapproxy/results
requestsFile=tests/mapproxy/wmts_shaziri.csv
##################################### general User Defined Variables with JMeter #######################################
#export host=mapproxy-map-proxy-map-proxy-route-raster.apps.v0h0bdx6.eastus.aroapp.io

export port=80
export wmtsUrl=wmts
export layer=full_il
export gridName=newGrids
export version=1.0.0
export projection=newGrids
export imageFormat=png
export users=55
export runTimeMin=10
export runTimeSec=$(($runTimeMin * 60))
export throughputPeriod=60
export targetThroughput=1500
now=$(date +"%d-%m-%y-%T")
dir="${resultsDir}/stress/wmts/${now}"
mkdir -p ${dir}


T_DIR=tests/mapproxy
# Reporting dir: start fresh
R_DIR=${dir}/report
#rm -rf ${R_DIR} > /dev/null 2>&1
#/bin/rm -rf ${R_DIR}  > /dev/null 2>&1
#mkdir -p ${R_DIR}
/bin/rm -f ${T_DIR}/test-plan.jtl ${T_DIR}/jmeter.log  > /dev/null 2>&1

./run.sh -Dlog_level.jmeter=DEBUG \
	-JtargetHost=${host} -JtargetPort=${port} -Jusers=${users} \
	-JrunTimeSec=${runTimeSec} -Jlayer=${layer} \
	-Jversion=${version} -JwmtsUrl=${wmtsUrl} -Jprojection=${projection} -JimageFormat=${imageFormat} \
	-JgridName=${gridName} -JthroughputPeriod=${throughputPeriod} -JtargetThroughput=${targetThroughput} -JparamFile=${requestsFile} \
	-n -t ${T_DIR}/wmts_multi_users.jmx -l ${T_DIR}/test-plan.jtl -j ${T_DIR}/jmeter.log \
	-e -o ${R_DIR}

echo "==== jmeter.log ===="
#cat ${T_DIR}/jmeter.log

echo "==== Raw Test Report ===="
#cat ${T_DIR}/test-plan.jtl

echo "==== HTML Test Report ===="
echo "See HTML test report in ${R_DIR}/index.html"
