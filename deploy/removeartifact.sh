#Removes the jar file after it has been sent to artifactory
buildNumber=$1


rm -rf /apps/DevOps/Products/Build_${buildNumber}
