#Copy Build Variable file to current working directory
#pipeline=$1
buildKey=$1
bwd=$(pwd)

echo "Copying Build Info to the Directory"
cp -v /apps/DevOps/ArtifactoryInfo/EfuseBuild.info ${bwd}/
