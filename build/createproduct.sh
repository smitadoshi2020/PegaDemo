#Create Product File
#BBWD=$1
#ENV=$2
#ssh srcwgspg@va33dlvihs333.wellpoint.com find  /apps/pegashared/other_apps/DevOps/Products -name '*.zip' | xargs rm -rf
#ExportProductRequestData_xml="$BBWD/xml/build/Upgrade/ExportProductRequestData_$ENV.xml"
#cp $ExportProductRequestData_xml .
#curl --header "Content-Type: text/xml;charset=UTF-8" --cacert /apps/tomcat7/tomcat-client.jks --insecure --data @$ExportProductRequestData_xml https://va33dlvihs333.wellpoint.com:8488/prweb/PRSOAPServlet/SOAP/ExportRAPPackage/Service?WSDL > report.txt
#ENV=$1
#BuildNum=$2
#ssh srcwgspg@va33dlvpeg307.wellpoint.com find  /apps/pegashared/other_apps/DevOps/Products -name '*.zip' | xargs rm -rf
#ExportProductRequestData_xml="/local_home/srcwgspg/DevOPS/Request/Upgrade/ExportProductRequestData_$ENV.xml"
#cp $ExportProductRequestData_xml .
#curl --header "Content-Type: text/xml;charset=UTF-8" --cacert /apps/tomcat7/tomcat-client.jks --insecure --data @$ExportProductRequestData_xml https://solutioncentral.dev.va.antheminc.com:443/prweb/PRSOAPServlet/SOAP/ExportRAPPackage/Service?WSDL > report.txt
#cat report.txt
#result=$(cat report.txt |grep ExportRAPStatus|cut -d: -f1|cut -d">" -f2|xargs)
#echo "Result from api call is: $result"
#if [[ $result != "Success" ]] ; then echo "Package creation failed."; exit 3; fi
#productpath_name=$(cat report.txt|grep ExportRAPStatus|cut -d">" -f2|cut -d"<" -f1|cut -d- -f2|cut -d'(' -f1|xargs)
#echo "Product & its path: $productpath_name"
#if [[ -z $productpath_name ]]; then echo "Could not get the product path. Exiting now"; exit 3; fi


BuildNum=$1
ENV=$2
inskey=$3


echo $inskey

product_path="/local_home/srccompg/DevOPS/Products"
productname=$(echo $inskey | cut -f2 -d' ')
echo "productname" $productname
product_name=$productname".zip"
echo "getting name"
#product_name="DEVOPSTESTING.zip"

echo $product_name
#product_name=$(basename $productpath_name)
#productpath_name=$($product_path/$product_name)
#echo "New product & its path: $productpath_name"

#ssh srcwgspg@va33dlvihs333.wellpoint.com sudo /bin/chown -R srcwgspg /apps/pegashared/other_apps

mkdir $product_path/Build_${BuildNum}

#mv $product_name $product_path/Build_${bamboo.buildNumber}
cp /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_74/scripts/utils/FinalProduct/$product_name $product_path/Build_${BuildNum}


product_path_new=${product_path}/Build_${BuildNum}

productpath_name_new=${product_path_new}/${product_name}

if [[ ${ENV} == "Major" ]]; then
	sed -i -e '/import.archive.path=/ s|=.*|='$productpath_name_new'|' /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_74/scripts/utils/Efuse_prpcServiceUtils_DEV.properties
	archive_path=$(grep ^import.archive.path /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_74/scripts/utils/Efuse_prpcServiceUtils_DEV.properties |cut -d= -f2)

	sed -i -e '/import.archive.path=/ s|=.*|='$productpath_name_new'|' /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_74/scripts/utils/Efuse_prpcServiceUtils_DEV.properties
	archive_path=$(grep ^import.archive.path /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_74/scripts/utils/Efuse_prpcServiceUtils_DEV.properties |cut -d= -f2)

else
	sed -i -e '/import.archive.path=/ s|=.*|='$productpath_name_new'|' /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_74/scripts/utils/Efuse_prpcServiceUtils_DEV.properties
	archive_path=$(grep ^import.archive.path /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_74/scripts/utils/Efuse_prpcServiceUtils_DEV.properties |cut -d= -f2)

	sed -i -e '/import.archive.path=/ s|=.*|='$productpath_name_new'|' /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_74/scripts/utils/Efuse_prpcServiceUtils_DEV.properties
	archive_path=$(grep ^import.archive.path /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_74/scripts/utils/Efuse_prpcServiceUtils_DEV.properties |cut -d= -f2)

fi

echo "Archive path is: $archive_path"

if [[ -z $archive_path ]]; then echo "Could not get the archive path. Exiting now"; exit 3; fi

#Save Product INS Key into Build_<BuildNumber> Directory with product artifact
#inskey=$(cat $ExportProductRequestData_xml|grep ProductInsKey|cut -d">" -f2|cut -d"<" -f1|xargs)
echo "inskey = '"$inskey"'" > ${product_path_new}/product_ins_key.txt

##Copy Product in working driectory to Define artifact
#mkdir -p PegaProduct/Build_${bamboo.buildNumber}
#mkdir -p com/anthem/set/solution-central/Build_${bamboo.buildNumber}

#cd PegaProduct/Build_${bamboo.buildNumber}
#cd com/anthem/set/solution-central/Build_${bamboo.buildNumber}

#cp -p $productpath_name_new .

#cd -
