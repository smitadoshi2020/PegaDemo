#Check Pega Unit Test Coverage For Current Build
buildNumber=$1
env=$2
bwd=$(pwd)
PegaCoverageRequestData_xml="$(pwd)/build/Request/PegaCoverageRequestData.xml"


curl -v --header "Content-Type: text/xml;charset=UTF-8" --cacert /apps/tomcat7/tomcat-client.jks --insecure --data @$PegaCoverageRequestData_xml https://va33dlvpeg337.wellpoint.com:8443/prweb/PRSOAPServlet/SOAP/AntmPegaTestCoverage/V1?WSDL > report_pegacoverage.txt

cat report_pegacoverage.txt
##Copy Unit Test Coverage in working driectory to Define artifact

cd /apps/DevOps/Reports
mkdir -p PegaTestCoverageReport/$env/Build_${buildNumber}
cd PegaTestCoverageReport/$env/Build_${buildNumber}

sftp srccompg@va33dlvpeg337.wellpoint.com <<EOF
cd /apps/pegashared/other_apps/DevOps/Reports/
get PegaTestCoverageReport_COB.xls
exit
EOF

#ssh srcwgspg@va33dlvpeg307.wellpoint.com sudo /bin/chown -R srcwgspg /apps/pegashared/other_apps/DevOps/Reports/PegaTestCoverageReport_DevOps.xls
#rsync -avzhe ssh srcwgspg@va33dlvpeg307.wellpoint.com:/apps/pegashared/other_apps/DevOps/Reports/PegaTestCoverageReport_DevOps.xls .
#Done

