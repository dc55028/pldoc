set CVS_RSH=ssh
call ant -DORACLE_HOME=c:/albie/pldoc/oracle -DJAVACC_HOME=%JAVACC_HOME% -Dversion=0 -Dsubversion=8 -Dsubsubversion=3 -buildfile release.xml %*
pause