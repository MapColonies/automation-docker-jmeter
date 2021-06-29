#!/bin/bash
# Inspired from https://github.com/hhcordero/docker-jmeter-client
# Basically runs jmeter, assuming the PATH is set to point to JMeter bin-dir (see Dockerfile)
#
# This script expects the standdard JMeter command parameters.
#
set -e
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"

echo "START Running Jmeter on `date`"
echo "JVM_ARGS=${JVM_ARGS}"
echo "jmeter args=$@"

# Keep entrypoint simple: we must pass the standard JMeter arguments
jmeter $@
echo "END Running Jmeter on `date`"
echo "Generate now reports to result provided folder: "
echo " -ResponseTimesOverTime.png "
/opt/apache-jmeter-5.3/bin/JMeterPluginsCMD.sh --generate-png ${R_DIR}/ResponseTimesOverTime.png --generate-csv ${R_DIR}/wmtscsv-test-rtot.csv --input-jtl ${R_DIR}/wmtscsv-res.jtl --plugin-type ResponseTimesOverTime --width 800 --height 600
echo " -TimesVsThreads.png"
/opt/apache-jmeter-5.3/bin/JMeterPluginsCMD.sh --generate-png ${R_DIR}/TimesVsThreads.png --input-jtl "${R_DIR}/wmtscsv-res.jtl" --plugin-type TimesVsThreads
echo " -TransactionsPerSecond.png"
/opt/apache-jmeter-5.3/bin/JMeterPluginsCMD.sh --generate-png ${R_DIR}/TransactionsPerSecond.png --input-jtl "${R_DIR}/wmtscsv-res.jtl" --plugin-type TransactionsPerSecond
echo " -AggregateReport.csv"
/opt/apache-jmeter-5.3/bin/JMeterPluginsCMD.sh --generate-csv ${R_DIR}/AggregateReport.csv --input-jtl "${R_DIR}/wmtscsv-res.jtl" --plugin-type AggregateReport

#     -n \
#    -t "/tests/${TEST_DIR}/${TEST_PLAN}.jmx" \
#    -l "/tests/${TEST_DIR}/${TEST_PLAN}.jtl"
# exec tail -f jmeter.log
#    -D "java.rmi.server.hostname=${IP}" \
#    -D "client.rmi.localport=${RMI_PORT}" \
#  -R $REMOTE_HOSTS