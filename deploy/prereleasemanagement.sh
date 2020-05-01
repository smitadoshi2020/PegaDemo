#Release Notes Creation
en=$1
#en=${bamboo.ENV}
build=$2
#build=${bamboo.buildNumber}
pr=$3
bwd=$(pwd)

rmfile="$(pwd)/build/Request/RMRequestData_$en.xml"
rmfile_SIT="$(pwd)/build/Request/RMRequestData_SIT.xml"
rmfile_PERF="$(pwd)/build/Request/RMRequestData_PERF.xml"
rmfile_CI="$(pwd)/build/Request/RMRequestData_CI.xml"

#ssh srcwgspg@va33dlvpeg307.wellpoint.com sudo /bin/chown -R srcwgspg /apps/pegashared/other_apps
#ssh srcwgspg@va33dlvpeg307.wellpoint.com sudo /bin/chgrp -R suwgspg /apps/pegashared/other_apps
#ssh srcwgspg@va33dlvpeg307.wellpoint.com /bin/chmod 755 /apps/pegashared/other_apps/DevOps/Request/FeatureIDList.xml
#rsync -avzhe ssh srcwgspg@va33dlvpeg307.wellpoint.com:/apps/pegashared/other_apps/DevOps/Request/FeatureIDList.xml /apps/pegashared/other_apps/DevOps/Request/

sftp srccompg@va33dlvpeg337.wellpoint.com <<EOF
lcd /apps/pegashared/other_apps/DevOps/Request/
chmod 755 /apps/pegashared/other_apps/DevOps/Request/FeatureIDList.xml
cd /apps/pegashared/other_apps/DevOps/Request/
get FeatureIDList.xml
exit
EOF

update=$(cat /apps/pegashared/other_apps/DevOps/Request/FeatureIDList.xml)

echo $update

sed -i "/<RMTableInput>/a $update" ${rmfile}
echo $rmfile
sed -i "/<RMTableInput>/a $update" ${rmfile_SIT}
sed -i "/<RMTableInput>/a $update" ${rmfile_PERF}
sed -i "/<RMTableInput>/a $update" ${rmfile_CI}

