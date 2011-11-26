
set -x 

PLDOC_HOME=$( cd $(dirname "$0" ) && pwd )
if [ "${PLDOC_HOME}" == "" ]
then  
    echo "ERROR: Environment variable PLDOC_HOME not set." 1>&2 && exit 1 
fi

export ANT_OPTS="-server -Dpldoc.home=\"${PLDOC_HOME}\" ${ANT_OPTS}" #Force server JVM 

ant -f ant_example.xml

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
		#ant -DJDBC_HOME=${JDBC_HOME} -f ant_enterprise_example.xml
		ant -DJDBC_HOME=${JDBC_HOME} -f ant_enterprise_example.xml -propertyfile ant_enterprise_example.properties
	fi
fi


