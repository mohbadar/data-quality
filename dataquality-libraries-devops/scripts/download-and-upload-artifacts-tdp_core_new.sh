#!/bin/sh
DATAPREP_CORE_VERSION=1.2.26

NEXUS_ENTERPRISE_RELEASE_LINK="https://artifacts-zl.talend.com/nexus/content/repositories/releases/"
NEXUS_ENTERPRISE_SNAPSHOT_LINK="https://artifacts-zl.talend.com/nexus/content/repositories/snapshots/"

DATAPREP_DOWNLOAD_LINK=${NEXUS_ENTERPRISE_RELEASE_LINK}

TALEND_UPDATE_LINK="https://talend-update.talend.com/nexus/content/repositories/libraries/"

ARTIFACT_NAMES="dataprep-core  dataprep-core-actions  dataprep-actions-parser"

for element in ${ARTIFACT_NAMES}    
do   
    echo "-------------------------------------"
    echo "|     " ${element} "    |"
    echo "-------------------------------------"

    # download from artifacts-zl
    mvn dependency:get \
      -DrepoUrl=${DATAPREP_DOWNLOAD_LINK} \
      -DremoteRepositories=releases::default::${DATAPREP_DOWNLOAD_LINK} \
      -DgroupId=org.talend.dataprep \
      -DartifactId=${element} \
      -Dversion=${DATAPREP_CORE_VERSION} \
      -Dpackaging=jar \
      -Ddest=./artifacts/${element}/${element}-${DATAPREP_CORE_VERSION}.jar

    # prepare pom.xml file
    sed -i '' -e 's/<artifactId>'${element}'.*<\/artifactId>/<artifactId>'${element}'<\/artifactId>/g' \
      ./artifacts/${element}/pom.xml
    sed -i '' -e 's/<version>.*<\/version>/<version>'${DATAPREP_CORE_VERSION}'<\/version>/g' \
      ./artifacts/${element}/pom.xml

    # upload to talend-update
    mvn deploy:deploy-file \
      -Durl=${TALEND_UPDATE_LINK} \
      -DrepositoryId=talend-update \
      -DpomFile=./artifacts/${element}/pom.xml \
      -DgroupId=org.talend.dataprep \
      -DartifactId=${element} \
      -Dversion=${DATAPREP_CORE_VERSION} \
      -Dfile=./artifacts/${element}/${element}-${DATAPREP_CORE_VERSION}.jar
done
