Scripts for uploading necessary dependencies to Nexus server
===================

**What do they do?**

The 3 *.sh scripts in this folder are used to upload the following artifacts to "talend-update" nexus server:
- 2 daikon artifacts
- 3 dataprep-core artifacts
- 8 dataquality artifacts

They download the artifacts from "artifacts-zl" nexus server build by the jenkins jobs and upload them to "talend-update" server, so that the studio can download them for the tDataprepRun jobs. These 3 scripts can be executed independently.



**How to run them?**
- make sure the artifacts to upload are available on "artifacts-zl" server.
- specify the right version in the scripts, and also the pom.xml files. (An improvement can be made to avoid the manual modifications of the pom files)
- run the scripts one by one, or only the ones needed.


