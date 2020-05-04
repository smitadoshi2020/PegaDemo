#Check Pega Unit Test For Current Build
buildNumber=$1
env=$2
bwd=$(pwd)
PegaUnitRequestData_xml="$(pwd)/build/Request/PegaUnitRequestData.xml"

##curl -v --header "Content-Type: text/xml;charset=UTF-8" --cacert /apps/tomcat7/tomcat-client.jks --insecure --data @$PegaUnitRequestData_xml https://va33dlvpeg337.wellpoint.com:8443/prweb/PRSOAPServlet/SOAP/AntmPegaUnit/V1?WSDL > report_pegaunit.txt
cat report_pegaunit.txt

TestScore=$(cat report_pegaunit.txt |grep TestScore|cut -d: -f1|cut -d">" -f2|cut -d"<" -f1|xargs)
echo "TestScore for the Unit Test is: $TestScore"
compthreshold=30
if [[ $TestScore -lt "$compthreshold" ]] ; then echo "The Unit test score  $TestScore is less than the threshold $compthreshold. Build failed" >>/apps/DevOps/Reports/Info.txt; exit 3; fi

##Copy Unit Test Result in working driectory to Define artifact

##cd /apps/DevOps/Reports/
mkdir -p PegaUnitTest/Build_${BuildNum}
cd PegaUnitTest/Build_${BuildNum}

rm -rf $bwd/Reports/Unit-Test-Info.txt
mkdir -p $bwd/Reports

##sftp srccompg@va33dlvpeg337.wellpoint.com <<EOF
##cd /apps/pegashared/other_apps/DevOps/Reports/
##get PegaUnitReport.xlsx
##exit
##EOF

#Reading the test scores to send mail
cd ${bwd}
UnitTestScore=$(cat report_pegaunit.txt |grep TestScore|cut -d: -f1|cut -d">" -f2|cut -d"<" -f1|xargs)

#Writing the values to the file to send mail
echo -e "\n**********************Pega Unit Test Score***************************" >>$bwd/Reports/Unit-Test-Info.txt
echo -e "\nPega Unit Test Score = $UnitTestScore" >>$bwd/Reports/Unit-Test-Info.txt
echo -e "\n*****************************END*************************************" >>$bwd/Reports/Unit-Test-Info.txt
#End of the script
