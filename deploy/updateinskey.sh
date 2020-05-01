ENV=$1
INSKEY=$2
BBWD=$3
PostDeployRequestData_xml="$BBWD/build/Request/PostDeployRequestData_$ENV.xml"

if [[ ! -z $INSKEY ]]; 
then
echo "Updating Product INS Key into $PostDeployRequestData_xml"; 
sed -i -e "s|<ProductInsKey>.*</ProductInsKey>|<ProductInsKey>$INSKEY</ProductInsKey>|g" $PostDeployRequestData_xml
updatedinskey=$(cat $PostDeployRequestData_xml|grep ProductInsKey|cut -d">" -f2|cut -d"<" -f1|xargs)
if [[ "$INSKEY" != "$updatedinskey" ]] ; then echo "Product INS Key update to $PostDeployRequestData_xml file failed."; exit 3; fi
fi

cat $PostDeployRequestData_xml
