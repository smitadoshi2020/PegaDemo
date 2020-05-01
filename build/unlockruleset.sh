env=$1
INSKEY=$2

bwd=$(pwd)

HandleVersionRequestData_xml="$(pwd)/build/Request/HandleVersionRequestData$env.xml"


#Modify the INS key in the Request data file if any new key provided
if [[ ! -z $bamboo_INSKEY ]];
then
echo "Updating Product INS Key into $HandleVersionRequestData_xml";
sed -i -e "s|<ProductInsKey>.*</ProductInsKey>|<ProductInsKey>$INSKEY</ProductInsKey>|g" $HandleVersionRequestData_xml
updatedinskey=$(cat $HandleVersionRequestData_xml|grep ProductInsKey|cut -d">" -f2|cut -d"<" -f1|xargs)
if [[ "$INSKEY" != "$updatedinskey" ]] ; then echo "Product INS Key update to $HandleVersionRequestData_xml file failed."; exit 3; fi
fi

# Execute ruleset check
cp $HandleVersionRequestData_xml .


curl --header "Content-Type: text/xml;charset=UTF-8" --cacert /apps/tomcat7/tomcat-client.jks --insecure --data @$HandleVersionRequestData_xml https://va33dlvpeg337.wellpoint.com:8443/prweb/PRSOAPServlet/SOAP/PreBuildServicePackage/Service?WSDL > report_HandleVersion.txt
cat report_HandleVersion.txt
result=$(cat report_HandleVersion.txt |grep HandleVersionStatus|cut -d: -f1|cut -d">" -f2|xargs)
echo "Result from Handle unlock version api call is: $result"
if [[ $result != "Success" ]] ; then echo "Handle unlock API call failed."; exit 3; fi
#Done
