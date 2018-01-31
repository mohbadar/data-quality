#!/bin/sh
DAIKON_VERSION=0.20.0

NEXUS_RELEASE_LINK="https://artifacts-zl.talend.com/nexus/content/repositories/TalendOpenSourceRelease/"
NEXUS_SNAPSHOT_LINK="https://artifacts-zl.talend.com/nexus/content/repositories/TalendOpenSourceSnapshot/"

TALEND_UPDATE_LINK="https://talend-update.talend.com/nexus/content/repositories/libraries/"

ARTIFACT_NAMES="daikon \
 daikon-tql-core \
 multitenant-core"


for element in $ARTIFACT_NAMES    
do   
	echo "-------------------------------------" 
	echo "|     " $element "    |" 
	echo "-------------------------------------" 

	# download from artifacts-zl
	mvn dependency:get \
        -DrepoUrl=$NEXUS_RELEASE_LINK \
        -DgroupId=org.talend.daikon \
        -DartifactId=$element \
        -Dversion=$DAIKON_VERSION \
        -Dpackaging=jar \
        -Ddest=./artifacts/$element/$element-$DAIKON_VERSION.jar

        # prepare pom.xml file
        sed -i '' -e 's/<version>.*<\/version>/<version>'${DAIKON_VERSION}'<\/version>/g' \
          ./artifacts/$element/pom.xml

	# upload to talend-update
	mvn deploy:deploy-file \
        -Durl=$TALEND_UPDATE_LINK \
        -DrepositoryId=talend-update \
        -DgroupId=org.talend.libraries \
        -DartifactId=$element \
        -Dversion=$DAIKON_VERSION \
        -DpomFile=./artifacts/$element/pom.xml \
        -Dfile=./artifacts/$element/$element-$DAIKON_VERSION.jar 
done
