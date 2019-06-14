#!/bin/sh
DQ_LIB_VERSION=7.0.0 # change the version of DQ libs to upload

NEXUS_RELEASE_LINK="https://artifacts-zl.talend.com/nexus/content/repositories/releases/"
NEXUS_SNAPSHOT_LINK="https://artifacts-zl.talend.com/nexus/content/repositories/snapshots/"

NEXUS_LINK_FOR_DOWNLOAD=${NEXUS_RELEASE_LINK} # Switch between RELEASE/SNAPSHOT link here

TALEND_UPDATE_LINK="https://talend-update.talend.com/nexus/content/repositories/libraries/"

ARTIFACT_NAMES="dataquality-datamasking \
 dataquality-semantic \
 dataquality-semantic-model"

# download parent pom from TalendOpenSourceRelease repo
mvn dependency:get \
      -DrepoUrl=${NEXUS_RELEASE_LINK} \
      -DgroupId=org.talend.dataquality \
      -DartifactId=dataquality-parent \
      -Dversion=${DQ_LIB_VERSION} \
      -Dpackaging=pom

for element in ${ARTIFACT_NAMES}    
do   
	echo "-------------------------------------" 
	echo "|     " ${element} "    |" 
	echo "-------------------------------------" 

	# download from artifacts-zl
	mvn dependency:get \
        -DrepoUrl=${NEXUS_LINK_FOR_DOWNLOAD} \
        -DgroupId=org.talend.dataquality \
        -DartifactId=${element} \
        -Dversion=${DQ_LIB_VERSION} \
        -Dpackaging=jar \
        -Ddest=./artifacts/${element}/${element}-${DQ_LIB_VERSION}.jar

  # prepare pom.xml file
  sed -i '' -e 's/<artifactId>'${element}'-.*<\/artifactId>/<artifactId>'${element}'-'${DQ_LIB_VERSION}'<\/artifactId>/g' \
    ./artifacts/${element}/pom.xml


	# upload to talend-update
	mvn deploy:deploy-file \
        -Durl=${TALEND_UPDATE_LINK} \
        -DrepositoryId=talend-update \
        -DgroupId=org.talend.dataquality \
        -DartifactId=${element} \
        -Dversion=${DQ_LIB_VERSION} \
        -DpomFile=./artifacts/${element}/pom.xml \
        -Dfile=./artifacts/${element}/${element}-${DQ_LIB_VERSION}.jar 
done
