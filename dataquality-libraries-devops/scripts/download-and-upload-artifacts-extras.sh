#!/bin/sh
TALEND_UPDATE_LINK="https://talend-update.talend.com/nexus/content/repositories/libraries/"

ARTIFACT_NAMES="carrier-1.101 \
 geocoder-2.111 \
 httpclient-4.5.6 \
 httpcore-4.4.10 \
 libphonenumber-8.10.5 \
 prefixmapper-2.111"


for element in ${ARTIFACT_NAMES}    
do
    echo "-------------------------------------"
    echo "|     " ${element} "    |"
    echo "-------------------------------------"

    element_short=`echo "${element}" | sed 's/-[0-9].*//'`
    # upload to talend-update
    mvn deploy:deploy-file \
        -Durl=${TALEND_UPDATE_LINK} \
        -DrepositoryId=talend-update \
        -DgroupId=org.talend.libraries \
        -DartifactId=${element} \
        -Dversion=6.0.0 \
        -DpomFile=./extras/${element_short}/pom.xml \
        -Dfile=./extras/${element_short}/${element}.jar
done
