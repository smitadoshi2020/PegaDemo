##Check version format

ENV=$1
BUILDVERSION=$2
PIPELINE=$3

##Check version format

if [[ $BUILDVERSION == [0-9]* ]]; then  echo "Version supplied is $BUILDVERSION"; else echo "Please follow the version format(For instance BUILDVERSION=<Build_Number of Bamboo>";exit 3; fi

if [ "${PIPELINE}" = "Major" ]
then 
	bamboo_Artifactory="/Build_${BUILDVERSION}"
	echo "Deploying from Major Pipeline Build (https://bamboo.anthem.com/browse/SC-BP)."
elif [ "${PIPELINE}" = "Minor" ]
then 
	bamboo_Artifactory="Minor/Build_${BUILDVERSION}"
	echo "Deploying from Minor Pipeline Build (https://bamboo.anthem.com/browse/SC-CCIB)."
elif [ "${PIPELINE}" = "EandB" ]
then 
	bamboo_Artifactory="EandB/Build_${BUILDVERSION}"
	echo "Deploying from EandB CI Pipeline Build (https://bamboo.anthem.com/browse/SC-CCIB)."
elif [ "${PIPELINE}" = "OffCycle" ]
then 
	bamboo_Artifactory="OffCycle/Build_${BUILDVERSION}"
	echo "Deploying from OffCycle Pipeline Build (https://bamboo.anthem.com/browse/SC-HOTB)."
else 
	echo "Please follow the pipeline choice format. Options are Major, Minor, OffCycle, or EandB"
	exit 3
fi

#remove previous file
rm /local_home/srcwgspg/DevOPS/ArtifactoryInfo/Artifact_${ENV}.info
#Set Artifactory Path
echo "Artifactory =" ${bamboo_Artifactory} >> /local_home/srcwgspg/DevOPS/ArtifactoryInfo/Artifact_${ENV}.info
