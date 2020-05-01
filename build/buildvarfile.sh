buildNumber=$1
inskey=$2

#Removing previous file
rm /apps/DevOps/ArtifactoryInfo/EfuseBuild.info

#Storing new build info
echo "BuildNumber =" ${buildNumber} >> /apps/DevOps/ArtifactoryInfo/EfuseBuild.info

#Copying the Inskey File

echo "Inskey of the Product: " $inskey

#Removing Product Ins Key File
rm /apps/DevOps/ArtifactoryInfo/product_ins_key.txt

#Copying the Inskey into the Inskey File

echo "inskey = '"$inskey"'" > /apps/DevOps/ArtifactoryInfo/product_ins_key.txt
