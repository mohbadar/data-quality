#!/bin/sh
TALEND_UPDATE_LINK="https://talend-update.talend.com/nexus/content/repositories/libraries/"

ARTIFACT_NAMES="carrier-1.85 \
 geocoder-2.95 \
 httpclient-4.5.1 \
 httpcore-4.4.3 \
 libphonenumber-8.9.6 \
 lucene-misc-4.10.4 \
 lucene-suggest-4.10.4 \
 prefixmapper-2.95"


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
