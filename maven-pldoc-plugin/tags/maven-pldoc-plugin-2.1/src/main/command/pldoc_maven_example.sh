
export MAVEN_OPTS="-server" #Force server JVM 
#Run against Example SQL files 
#As goal 
mvn -f pldoc-sqlfiles-pom.xml pldoc:pldoc  

# As site report plug-in 
mvn -f pldoc-sqlfiles-pom.xml site 

# rem Include Oracle jars in the classpath 
if [ "${ORACLE_HOME}" =  "" ]
then
	echo "INFO: Environment variable ORACLE_HOME not set. Skipping database example" 1>&2 
else
	set -xv
	#export JAVA_TOOL_OPTIONS=" -Dfile.encoding=UTF-8"
	#export JAVA_OPTS=" -Dfile.encoding=UTF-8"
	export NLS_LANG=.UTF8
	if [ -d ${ORACLE_HOME}/jdbc/lib ]
	then
	  export JDBC_HOME=${ORACLE_HOME}/jdbc/lib 
	elif [ -d ${ORACLE_HOME} ]
	then
	  export JDBC_HOME=${ORACLE_HOME} 
	fi 
	if [ "${JDBC_HOME}" =  "" ]
	then
		echo "WARN: Cannot locate JDBC directory. Ensure that JDBC_HOME is specified in ant_enterprise_example.properties" 1>&2 
		ant -f ant_enterprise_example.xml -propertyfile ant_enterprise_example.properties
	else
		#Run against all Oracle Enterprise schemas

		#As goal 
		mvn -f pldoc-enterprise-pom.xml pldoc:pldoc  

		# As site report plug-in 
		mvn -f pldoc-enterprise-pom.xml site 
	fi
fi


