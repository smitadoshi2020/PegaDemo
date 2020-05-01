#Release Notes Creation
en=$1
#en=${bamboo.ENV}
build=$2
#build=${bamboo.buildNumber}
pr=$3

bwd=$(pwd)

#Zero Out FeatureIDList.xml XML on bamboo server
echo > /apps/pegashared/other_apps/DevOps/Request/FeatureIDList.xml

#Remove FeatureIDList.xml from dev server 307
#ssh srcwgspg@va33dlvpeg307.wellpoint.com rm -rf /apps/pegashared/other_apps/DevOps/Request/FeatureIDList.xml
sftp srccompg@va33dlvpeg337.wellpoint.com <<EOF
cd /apps/pegashared/other_apps/DevOps/Request/
rm -rf FeatureIDList.xml
exit
EOF
