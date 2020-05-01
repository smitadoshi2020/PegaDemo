env=$1
buildNumber=$2

echo "copying the files to local folder"

cp -p $(pwd)/PegaUtils/* /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_74/scripts/utils/

chmod 0777 /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_74/scripts/utils/*

product_path_new=/apps/DevOps/Products/Build_$buildNumber
product_name=$(ls -ltr $product_path_new/*.zip|tail -1|awk '{print $9}')

echo $product_path_new
echo $product_name
product_name_new=$(basename $product_name)

if [[ -z $product_name_new ]]; then echo "Could not get the product name. Exiting now"; exit 3; fi
productpath_name_new=${product_path_new}/${product_name_new}

sed -i -e '/import.archive.path=/ s|=.*|='$productpath_name_new'|' /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_74/scripts/utils/Efuse_prpcServiceUtils_${env}.properties
archive_path=$(grep ^import.archive.path /apps/pegashared/other_apps/DevOps/PRPCServiceUtils_74/scripts/utils/Efuse_prpcServiceUtils_${env}.properties |cut -d= -f2)

echo "Archive path is: $archive_path"

if [[ -z $archive_path ]]; then echo "Could not get the archive path. Exiting now"; exit 3; fi
