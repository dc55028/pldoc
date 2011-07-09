# $Id: pldoc_test.sh,v 1.2 2003/10/28 17:30:28 altumano Exp $
../pldoc.sh -doctitle \"TEST\" -overview testinput/overview1.html -d TestDoc testinput/*.sql 
../pldoc.sh -showSkippedPackages -doctitle \"TEST\" -overview testinput/overview1.html -d TestDoc2 -inputencoding utf-8 testinput/chinese.pks
../pldoc.sh -showSkippedPackages -doctitle \"TEST\" -overview testinput/overview1.html -d TestDoc3 testinput/packages/*.* testinput/objecttypes/*.* testinput/datetime-source/*.* testinput/schemalevel/*.*  testinput/triggers/*.* testinput/xe-problems/*.* testinput/11g-source/*.* testinput/bugs/*.sql 


# rem Include Oracle jars in the classpath 
if [ "${ORACLE_HOME}" =  "" ]
then
	echo "INFO: Environment variable ORACLE_HOME not set. Skipping database tests" 1>&2 
else
	# Run against all Oracle XE schemas (Oracle XE 11g Beta) - including package and type bodies  
	echo "INFO: Environment variable ORACLE_HOME is set. Attempting database tests ..." 1>&2 
	../pldoc.sh -showSkippedPackages -d TestDocXE-ALL -url jdbc:oracle:thin:@//192.168.100.158:1521/XE -user system -password oracle -sql "APEX_040000.%%%%,APPQOSSYS.%%%%,CTXSYS.%%%%,DBSNMP.%%%%,FLOWS_FILES.%%%%,HR.%%%%,MDSYS.%%%%,ORACLE_OCM.%%%%,OUTLN.%%%%,PUBLIC.%%%%,SYSTEM.%%%%,TESTUSER.%%%%,XDB.%%%%,SYS.%%%%"  -types "\"PROCEDURE,FUNCTION,TRIGGER,PACKAGE,TYPE,PACKAGE BODY,TYPE BODY\""
fi


