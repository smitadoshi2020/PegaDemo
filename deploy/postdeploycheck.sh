#Post Deployment Check
ENV=$1
buildNumber=$2
INSKEY=$3
bwd=$(pwd)

#PostDeployRequestData_xml=PostDeployRequestData_$ENV.xml

PostDeployRequestData_xml="$(pwd)/build/Request/PostDeployRequestData_$ENV.xml"

# cp /local_home/srcwgspg/DevOPS/Request/${PostDeployRequestData_xml} .

if [[ ! -z $INSKEY ]]; 
then
echo "Updating Product INS Key into $PostDeployRequestData_xml"; 
sed -i -e "s|<ProductInsKey>.*</ProductInsKey>|<ProductInsKey>$INSKEY</ProductInsKey>|g" $PostDeployRequestData_xml
updatedinskey=$(cat $PostDeployRequestData_xml|grep ProductInsKey|cut -d">" -f2|cut -d"<" -f1|xargs)
if [[ "$INSKEY" != "$updatedinskey" ]] ; then echo "Product INS Key update to $PostDeployRequestData_xml file failed."; exit 3; fi
fi

cat $PostDeployRequestData_xml

curl --header "Content-Type: text/xml;charset=UTF-8" --cacert /apps/tomcat7/tomcat-client.jks --insecure --data  @${PostDeployRequestData_xml} https://va33dlvpeg337.wellpoint.com:8443/prweb/PRSOAPServlet/SOAP/RuleCountCompare/v1?WSDL > report_rulecountcompare.txt

cat report_rulecountcompare.txt

result=$(cat report_rulecountcompare.txt |grep PostDeployStatus|cut -d: -f1|cut -d">" -f2|xargs)

echo "Result from PostDeployment api call is: $result"

if [[ $result != "Success" ]] ; then echo "PostDeployment API call failed."; exit 3; fi

reportpath_name="/local_home/srccompg/DevOPS/Report/CompareResult*.xlsx"

echo "Report & its path: $reportpath_name"

report_path=$(dirname $reportpath_name)
report_name=$(basename $reportpath_name)

##Copy PostDeployment Report in working driectory to Define artifact
cd /apps/DevOps/Reports/
mkdir -p PostDeploymentReport/$ENV/Build_${buildNumber}
cd PostDeploymentReport/$ENV/
#ssh srcwgspg@va10tlvpeg310.wellpoint.com sudo /bin/chown -R srcwgspg /apps/pegashared/other_apps
#rsync -avzhe ssh srcwgspg@va10tlvpeg310.wellpoint.com:/apps/pegashared/other_apps/DevOps/Reports/$report_name .

sftp srccompg@va33dlvpeg337.wellpoint.com <<EOF
cd /apps/pegashared/other_apps/DevOps/Reports/
get $report_name
exit
EOF

cp -p `ls -rt *xlsx | tail -1` Build_${buildNumber}
rm -rf *.xlsx

#Begin Check for Post Deploy Rule Count Match
rm -rf /apps/DevOps/Reports/Deployment_Info.txt
cd ${bwd}
echo "Bamboo current working directory is: $bwd"
doesCountMatch=$(grep DoesRuleCountMatch report_rulecountcompare.txt | cut -d'>' -f2 | cut -d'<' -f1)
#doesCountMatch
echo "Does Rule Count match in Post Deploy Check: $doesCountMatch"
if [[ "$doesCountMatch" == "Yes" ]] ; then echo "Deployment is completed in $ENV Environment. And the rules count match in post deploy check." >>/apps/DevOps/Reports/Deployment_Info.txt; fi
if [[ "$doesCountMatch" != "Yes" ]] ; then echo "Rule count does not match."; exit 3; fi
#End Check for Post Deploy Rule Count Match
