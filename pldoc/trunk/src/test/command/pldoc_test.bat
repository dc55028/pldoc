REM $Id: pldoc_test.bat,v 1.3 2003/10/20 19:37:46 altumano Exp $

call ..\pldoc.bat -showSkippedPackages -doctitle \"TEST\" -overview testinput/overview1.html -d TestDoc1 testinput/*.sql
call ..\pldoc.bat -showSkippedPackages -doctitle \"TEST\" -overview testinput/overview1.html -d TestDoc2 -inputencoding utf-8 testinput/chinese.pks
call ..\pldoc.bat -showSkippedPackages -doctitle \"TEST\" -overview testinput/overview1.html -d TestDoc3 testinput/packages/*.* testinput/objecttypes/*.* testinput/datetime-source/*.* testinput/schemalevel/*.*  testinput/triggers/*.* testinput/xe-problems/*.* testinput/11g-source/*.* testinput/bugs/*.sql 

@REM rem Include Oracle jars in the classpath 
if "%ORACLE_HOME%" == "" ( echo INFO: Environment variable ORACLE_HOME not set. Skipping database tests 1>&2 && goto end )

@REM run against all Oracle XE schemas (Oracle XE 11g Beta) - including package and type bodies  
echo INFO: Environment variable ORACLE_HOME is set. Attempting database tests ... 1>&2 
call ..\pldoc.bat -showSkippedPackages -d TestDocXE-ALL -url jdbc:oracle:thin:@//192.168.100.158:1521/XE -user system -password oracle -sql "APEX_040000.%%%%,APPQOSSYS.%%%%,CTXSYS.%%%%,DBSNMP.%%%%,FLOWS_FILES.%%%%,HR.%%%%,MDSYS.%%%%,ORACLE_OCM.%%%%,OUTLN.%%%%,PUBLIC.%%%%,SYSTEM.%%%%,TESTUSER.%%%%,XDB.%%%%,SYS.%%%%"  -types "\"PROCEDURE,FUNCTION,TRIGGER,PACKAGE,TYPE,PACKAGE BODY,TYPE BODY\""

:end
PAUSE

