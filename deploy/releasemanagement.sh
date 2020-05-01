#Release Notes Creation
en=$1
#en=${bamboo.ENV}
build=$2
#build=${bamboo.buildNumber}
pr=$3
ExportProductRequestData_xml=ExportProductRequestData_$en.xml
bwd=$(pwd)

rmfile="$(pwd)/build/Request/RMRequestData_$en.xml"

#ssh srcwgspg@va33dlvpeg307.wellpoint.com rm -rf /apps/pegashared/other_apps/DevOps/Reports/ReleaseNotes_MajorCI.xls
#ssh srcwgspg@va33dlvpeg307.wellpoint.com rm -rf /apps/pegashared/other_apps/DevOps/Reports/ReleaseNotes_MajorSIT.xls

#rsync -avzhe ssh srcwgspg@va33dlvpeg307.wellpoint.com:/apps/pegashared/other_apps/DevOps/Request/FeatureIDList.xml /apps/pegashared/other_apps/DevOps/Request/
sftp srccompg@va33dlvpeg337.wellpoint.com <<EOF
cd /apps/pegashared/other_apps/DevOps/Request/
get FeatureIDList.xml
exit
EOF


sed -i -e "s|<EnvName>.*</EnvName>|<EnvName>$en</EnvName>|g" $rmfile 
sed -i -e "s|<BuildNumber>.*</BuildNumber>|<BuildNumber>$build</BuildNumber>|g" $rmfile 

#pr=$(sed -n 's:.*<ProductInsKey>\(.*\)</ProductInsKey>.*:\1:p' /local_home/srcwgspg/DevOPS/Request/ExportProductRequestData_${en}.xml)
sed -i -e "s|<ProductForFeatureID>.*</ProductForFeatureID>|<ProductForFeatureID>$pr</ProductForFeatureID>|g" $rmfile

#update=$(cat /apps/pegashared/other_apps/DevOps/Request/FeatureIDList.xml)

#sed -i "/<RMTableInput>/a $update" ${rmfile}

cat $rmfile
cp $rmfile .
cat $rmfile

curl --header "Content-Type: text/xml;charset=UTF-8" --cacert /apps/tomcat7/tomcat-client.jks --insecure --data @RMRequestData_$en.xml https://va33dlvpeg337.wellpoint.com:8443/prweb/PRSOAPServlet/SOAP/ReleaseManagementPkg/V1?WSDL > report_RMRequestData_$en.txt

cat report_RMRequestData_$en.txt

result=$(cat report_RMRequestData_$en.txt |grep RMTableUpdateStatus|cut -d: -f1|cut -d">" -f2|xargs)

echo "Result from ReleaseManagment api call is: $result"

if [[ $result != "Success" ]] ; then echo "ReleaseManagement API call failed."; exit 3; fi

#reportpath_name=$(cat report_RMRequestData_$en.txt | grep RMTableUpdateStatus|cut -d"=" -f2|cut -d"<" -f1|cut -d- -f2|xargs)

reportpath_name="/local_home/srccompg/DevOPS/Report/${build}/ReleaseNotes_$en.xls"

echo "Report & its path: $reportpath_name"

#if [[ -z $reportpath_name ]]; then echo "Could not get the report path name. Exiting now"; exit 3; fi

report_path=$(dirname $reportpath_name)
report_name=$(basename $reportpath_name)

#if [[ $? -ne 0 ]] ; then echo "Error in Secure copy of Post Deployment Report"; exit 3; fi

#ssh srcwgspg@va33dlvpeg307.wellpoint.com sudo /bin/chown -R srcwgspg /apps/pegashared/other_apps 

#Copy Release Notes Report in working driectory to Define artifact
mkdir -p ReleaseNotesReport/Build_${build}

cd ReleaseNotesReport/Build_${build}
#rsync -avzhe ssh srcwgspg@va33dlvpeg307.wellpoint.com:/apps/pegashared/other_apps/DevOps/Reports/ReleaseNotes_${en}.xls .
sftp srccompg@va33dlvpeg337.wellpoint.com <<EOF
cd /apps/pegashared/other_apps/DevOps/Reports/
get ReleaseNotes_${en}.xls
exit
EOF

mkdir -p /local_home/srccompg/DevOPS/Report/Build_${build}/

cp -p ReleaseNotes_${en}.xls /local_home/srccompg/DevOPS/Report/Build_${build}

#Reset RMRequest XML

cp /local_home/srccompg/DevOPS/Request/RMRequestData.xml /local_home/srccompg/DevOPS/Request/RMRequestData_$en.xml
