#!/bin/sh
DATAPREP_VERSION=2.4.0-SNAPSHOT
DATAPREP_CORE_VERSION=2.4.0

NEXUS_ENTERPRISE_RELEASE_LINK="https://artifacts-zl.talend.com/nexus/content/repositories/releases/"
NEXUS_ENTERPRISE_SNAPSHOT_LINK="https://artifacts-zl.talend.com/nexus/content/repositories/snapshots/"

DATAPREP_DOWNLOAD_LINK=$NEXUS_ENTERPRISE_SNAPSHOT_LINK
DATAPREP_CORE_DOWNLOAD_LINK=$NEXUS_ENTERPRISE_RELEASE_LINK

TALEND_UPDATE_LINK="https://talend-update.talend.com/nexus/content/repositories/libraries/"

ARTIFACT_NAMES="dataprep-backend-common  dataprep-actions"

# download dataprep-backend parent pom from artifacts-zl
mvn dependency:get \
  -DrepoUrl=$DATAPREP_DOWNLOAD_LINK \
  -DremoteRepositories=snapshots::default::$DATAPREP_DOWNLOAD_LINK \
  -DgroupId=org.talend.dataprep \
  -DartifactId=dataprep-backend \
  -Dversion=$DATAPREP_VERSION \
  -Dpackaging=pom

for element in $ARTIFACT_NAMES    
do   
      echo "-------------------------------------" 
      echo "|     " $element "    |" 
      echo "-------------------------------------" 

      # download from artifacts-zl
      mvn dependency:get \
        -DrepoUrl=$DATAPREP_CORE_DOWNLOAD_LINK \
        -DremoteRepositories=releases::default::$DATAPREP_CORE_DOWNLOAD_LINK \
        -DgroupId=org.talend.dataprep \
        -DartifactId=$element \
        -Dversion=$DATAPREP_CORE_VERSION \
        -Dpackaging=jar \
        -Ddest=./artifacts/$element/$element-$DATAPREP_CORE_VERSION.jar

      # prepare pom.xml file
      sed -i '' -e 's/<version>.*<\/version>/<version>'${DATAPREP_CORE_VERSION}'<\/version>/g' \
        ./artifacts/$element/pom.xml

      # upload to talend-update
      mvn deploy:deploy-file \
        -Durl=$TALEND_UPDATE_LINK \
        -DrepositoryId=talend-update \
        -DpomFile=./artifacts/$element/pom.xml \
        -DgroupId=org.talend.libraries \
        -DartifactId=$element \
        -Dversion=$DATAPREP_CORE_VERSION \
        -Dpackaging=jar \
        -Dfile=./artifacts/$element/$element-$DATAPREP_CORE_VERSION.jar 
done


echo "-------------------------------------" 
echo "|     dataprep-ee-actions-parser    |" 
echo "-------------------------------------" 

ACTIONS_PARSER_NAME="dataprep-ee-actions-parser"

# download dataprep-ee-backend parent pom from artifacts-zl
mvn dependency:get \
  -DrepoUrl=$DATAPREP_DOWNLOAD_LINK \
  -DremoteRepositories=snapshots::default::$DATAPREP_DOWNLOAD_LINK \
  -DgroupId=org.talend.dataprep \
  -DartifactId=dataprep-ee-backend \
  -Dversion=$DATAPREP_VERSION \
  -Dpackaging=pom

# download dataprep-ee-actions-parser from artifacts-zl
mvn dependency:get \
  -DrepoUrl=$DATAPREP_CORE_DOWNLOAD_LINK \
  -DremoteRepositories=releases::default::$DATAPREP_CORE_DOWNLOAD_LINK \
  -DgroupId=org.talend.dataprep \
  -DartifactId=$ACTIONS_PARSER_NAME \
  -Dversion=$DATAPREP_CORE_VERSION \
  -Dpackaging=jar \
  -Ddest=./artifacts/$ACTIONS_PARSER_NAME/$ACTIONS_PARSER_NAME-$DATAPREP_CORE_VERSION.jar

# prepare pom.xml file
sed -i '' -e 's/<version>.*<\/version>/<version>'${DATAPREP_CORE_VERSION}'<\/version>/g' \
  ./artifacts/$element/pom.xml

# upload to talend-update
mvn deploy:deploy-file \
  -Durl=$TALEND_UPDATE_LINK \
  -DrepositoryId=talend-update \
  -DgroupId=org.talend.libraries \
  -DartifactId=$ACTIONS_PARSER_NAME \
  -Dversion=$DATAPREP_CORE_VERSION \
  -DpomFile=./artifacts/$ACTIONS_PARSER_NAME/pom.xml \
  -Dfile=./artifacts/$ACTIONS_PARSER_NAME/$ACTIONS_PARSER_NAME-$DATAPREP_CORE_VERSION.jar 

