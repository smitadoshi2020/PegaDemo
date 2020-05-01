env=$1
INSKEY=$2
bwd=$(pwd)
ExportProductRequestData_xml="$(pwd)/build/Request/ExportProductRequestData.xml"

if [[ ! -z $INSKEY ]];
then
echo "Updating Product INS Key into ExportProductRequestData.xml";
sed -i -e "s|<ProductInsKey>.*</ProductInsKey>|<ProductInsKey>$INSKEY</ProductInsKey>|g" $ExportProductRequestData_xml
updatedinskey=$(cat $ExportProductRequestData_xml|grep ProductInsKey|cut -d">" -f2|cut -d"<" -f1|xargs)
if [[ "$INSKEY" != "$updatedinskey" ]] ; then echo "Product INS Key update to $ExportProductRequestData_xml file failed."; exit 3; fi
fi
