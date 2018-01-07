package net.sourceforge.pldoc.mojo;

/*
 * Copyright 2001-2005 The Apache Software Foundation.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import java.util.Locale;
import org.apache.maven.plugin.MojoExecutionException;

import java.io.IOException;
import java.io.File;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.MalformedURLException;
import java.util.List;
import java.util.ResourceBundle;
import net.sourceforge.pldoc.Settings;
import net.sourceforge.pldoc.ant.PLDocTask;

import org.apache.tools.ant.BuildException;

import org.apache.maven.execution.MavenSession;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.project.MavenProject;
import org.apache.maven.reporting.MavenReport;
import org.apache.maven.reporting.MavenReportException;
//Maven3 import org.apache.maven.settings.building.SettingsBuilder; 
import org.apache.maven.settings.Server; 
//..pldoc.Settings is already defined import org.apache.maven.settings.Settings; 
import org.apache.maven.shared.model.fileset.FileSet;
import org.apache.maven.shared.model.fileset.util.FileSetManager;
import org.apache.tools.ant.Project;

//import org.apache.tools.ant.types.FileSet;
import org.codehaus.doxia.sink.Sink;
import org.codehaus.plexus.util.StringUtils;

/* Support Maven encoded passwords */
import org.sonatype.plexus.components.cipher.DefaultPlexusCipher; 
import org.sonatype.plexus.components.cipher.PlexusCipher; 
import org.sonatype.plexus.components.cipher.PlexusCipherException; 
import org.sonatype.plexus.components.sec.dispatcher.DefaultSecDispatcher; 
import org.sonatype.plexus.components.sec.dispatcher.SecDispatcher; 
import org.sonatype.plexus.components.sec.dispatcher.SecDispatcherException; 
import org.sonatype.plexus.components.sec.dispatcher.SecUtil; 
import org.sonatype.plexus.components.sec.dispatcher.model.SettingsSecurity;

/**
 * Goal which touches a timestamp file.
 *
 * Here is a sample configuration for the plugin with the defaults:
 *<plugin>
<groupId>net.sourceforge.pldoc</groupId>
<artifactId>maven-pldoc-plugin</artifactId>
<version>2.1-SNAPSHOT</version>
<configuration>
<applicationTitle>project-name</applicationTitle>
<sourceDirectory>src/sql</sourceDirectory>
<includes>*.sql</includes>
<namesCase>default</namesCase>
<inputEncoding>ISO-8859-15</inputEncoding>
<reportOutputDirectory>target/site/apidocs</reportOutputDirectory>
<destDir>sql-apidocs<destDir>
<showSkippedPackages>true</showSkippedPackages>
<plscope>true</plscope>
<savesourcecode>true</savesourcecode>
<ignoreInformalComments>true</ignoreInformalComments>
<driverName>oracle.jdbc.OracleDriver</driverName>
<getMetadataStatement>CallableStatement text</getMetadataStatement>
<getMetadataStatementReturnType>2005</getMetadataStatementReturnType>
<dbUrl>jdbc:oracle:thin:@//192.168.100.22:1521/orcl</dbUrl>
<dbUser>system</dbUser>
<dbPassword>oracle</dbPassword>
<inputTypes>PROCEDURE,FUNCTION,TRIGGER,PACKAGE,TYPE,PACKAGE BODY,TYPE BODY</inputTypes>
<inputObjects>ANONYMOUS.%,APEX_040000.%,APEX_PUBLIC_USER.%,APPQOSSYS.%,BI.%,CACHEADM.%,CTXSYS.%,DBSNMP.%,DEMO.%,DIP.%,EXFSYS.%,FLOWS_FILES.%,HR.%,HR1.%,HR_TRIG.%,IX.%,MDDATA.%,MDSYS.%,MGMT_VIEW.%,OBE.%,OE.%,OE1.%,OLAPSYS.%,ORACLE_OCM.%,ORDDATA.%,ORDPLUGINS.%,ORDSYS.%,OUTLN.%,OWBSYS.%,OWBSYS_AUDIT.%,PHPDEMO.%,PLS.%,PM.%,SCOTT.%,SH.%,SI_INFORMTN_SCHEMA.%,SPATIAL_CSW_ADMIN_USR.%,SPATIAL_WFS_ADMIN_USR.%,SYS.%,SYSMAN.%,SYSTEM.%,TIMESTEN.%,TTHR.%,WMSYS.%,XDB.%,XDBMETADATA.%,XDBPM.%,XFILES.%,XS$NULL.%</inputObjects>
</configuration>                    
</plugin>

 *
 * @goal pldoc
 * @phase pldoc
 * @execute phase="generate-sources"
 *
 */
public class PLDoc
        extends AbstractMojo
implements MavenReport{

    /**
     * Specifies the application title
     *
     * @parameter expression="${application.title}" default-value="${project.name}"
     * @required
     */
    private String applicationTitle;

    /**
     * The name of the destination subdirectory.
     * <br/>
     *
     * @since 2.1
     * @parameter expression="${destDir}" default-value="sql-apidocs"
     */
    private String destDir;

    /**
     * Specifies the File summarising the documented application.
     *
     *
     * @parameter expression="${overviewFile}"
     * @since 2.17 
     */
    protected File overviewFile;

    /**
     * Specifies the CSS stylesheet file to reference in the generated HTML files.
     *
     * @parameter expression="${stylesheet}"
     * @since 2.17
     */
    private String stylesheet;
    
    /**
     * Specifies the destination directory where pldoc saves the generated HTML files.
     *
     *
     * @parameter expression="${destDir}" alias="destDir" default-value="${project.build.directory}/sql-apidocs"
     * @required
     */
    protected File outputDirectory;

    /**
     * Specifies the destination directory where pldoc saves the generated HTML files.
     *
     * @parameter expression="${project.reporting.outputDirectory}/sql-apidocs"
     * @required
     */
    private File reportOutputDirectory;
    
    /**
     * Specifies the source directory
     *
     * @parameter expression="${sourceDirectory}" 
     */
    private File sourceDirectory;

    /**
     * Specifies the included files
     *
     * @parameter expression="${includes}" 
     */
    private String includes;

    /**
     * Specifies the character encoding of the input files
     *
     * @since 2.6
     * @parameter expression="${inputEncoding}" 
     */
    private String inputEncoding = System.getProperty("file.encoding");

    /**
     * Specifies the desired case of names 
     *
     * @since 2.10
     * @parameter expression="${namesCase}" 
     */
    private String namesCase = "default";

    /**
     * JDBC URL
     *
     * @since 2.1
     * @parameter expression="${dbUrl}" 
     */
    private String dbUrl ;
    /**
     * Database user name 
     *
     * @since 2.1
     * @parameter expression="${dbUser}" 
     */
    private String dbUser ;
    /**
     * Database user password
     *
     * @since 2.1
     * @parameter expression="${dbPassword}" 
     */
    private String dbPassword ;
    /**
     * Comma-separated list of input Object Types to process, for example: "PACKAGE,TYPE,FUNCTION,PROCEDURE,TRIGGER"
     *
     * @since 2.1
     * @parameter expression="${inputTypes}" default-value="PACKAGE,TYPE,FUNCTION,PROCEDURE,TRIGGER"
     */
    private String inputTypes ;
    /**
     * Comma-separated list of input Objects to process, for example "SCOTT.%,HR.%,SH.%"
     *
     * @since 2.1
     * @parameter expression="${inputObjects}" 
     */
    private String inputObjects ;
    /**
     * Display parsing errors for failed packages in Generator.html.
     *
     * @since 2.1
     * @parameter expression="${showSkippedPackages}" default-value="false"
     */
    private boolean showSkippedPackages ;

    /**
     * Class name of JDBC driver.
     *
     * @since 2.15
     * @parameter expression="${driverName}" 
     */
    private String driverName ;

    /**
     * Callable statement to retrieve object source.
     *
     * @since 2.15
     * @parameter expression="${getMetadataStatement}" 
     */
    private String getMetadataStatement ;

    /**
     * Return Type (see java.sql.Types).
     *
     * @since 2.15
     * @parameter expression="${getMetadataStatementReturnType}" 
     */
    private Integer getMetadataStatementReturnType ;


    /**
     * Ignore informal PL/SQL comments (--) when searching for PLDoc comments.
     *
     * @since 2.16
     * @parameter expression="${ignoreInformalComments}" default-value="false"
     */
    private boolean ignoreInformalComments ;

    /**
     * Pull in PLScope infornmation from the database and include in generated documentation.
     *
     * @since 2.19
     * @parameter expression="${plscope}" default-value="false"
     */
    private boolean plscope ;

    /**
     * Save source code extracted from the database in the file system.
     *
     * @since 2.21
     * @parameter expression="${savesourcecode}" default-value="false"
     */
    private boolean savesourcecode ;

    /**
     * Specifies the CSS stylesheet file to reference in the generated source code XML files.
     *
     * @parameter expression="${sourcestylesheet}"
     * @since 2.21
     */
    private String sourcestylesheet;
    

    /**
     * The Maven Project Object
     *
     * @parameter expression="${project}"
     * @required
     * @readonly
     */
    private MavenProject project;


    /**
     * The name of the Javadoc report.
     *
     * @since 2.1
     * @parameter expression="${name}"
     */
    private String name;

    /**
     * The description of the Javadoc report.
     *
     * @since 2.1
     * @parameter expression="${description}"
     */
    private String description;

    /**
     * The files to be processed.
     *
     * @since 2.30
     * @parameter expression="${fileSets}"
     */
    private List<FileSet> fileSets;

    /**
     * Executing Maven Session
     *
     * @since 3.0.17
     *
     * @required
     * @readonly
     * @parameter
     * expression="${session}"
     */
    private MavenSession mavenSession;

    /* Support Maven Encoded Passwords */
    private PlexusCipher cipher; 
 
    private SettingsSecurity securitySettings; 
 
    private File securitySettingsPath; 

    /** {@inheritDoc} */

    public void execute()
            throws MojoExecutionException {
	
        try {
	    //RenderingContext = new RenderingContext (outputDirectory, getOutPutName + ".html" ); 
	    //SiteRendererSink = new SiteRendererSink (context);
	    Sink sink = null; 
	    Locale locale = Locale.getDefault();
            generate(sink, locale );
        } 
	catch (MavenReportException ex) {
            //throw new MavenReportException("Failed generating pldoc report",ex);
	    throw new MojoExecutionException( "An error has occurred in " + getName (Locale.ENGLISH ) + " report generation" , ex);
        }
	catch (RuntimeException ex) {
            //throw new MavenReportException("Failed generating pldoc report",ex);
	    throw new MojoExecutionException( "An error has occurred in " + getName (Locale.ENGLISH ) + " report generation" , ex);
        }


    }

    /** {@inheritDoc} 
        This implementation current ignore ignores both parameters  
    */

    public void generate(Sink sink, Locale locale) throws MavenReportException {

	outputDirectory = getReportOutputDirectory();
	getLog().debug( "outputDirectory=" + outputDirectory  ) ;
	getLog().debug( "destDir=" + destDir  ) ;
	getLog().debug( "reportOutputDirectory=" + reportOutputDirectory  ) ;
	getLog().debug( "applicationTitle=" + applicationTitle  ) ;
	getLog().debug( "sourceDirectory=" + sourceDirectory  ) ;
	getLog().debug( "includes=" + includes  ) ;
	getLog().debug( "inputEncoding=" + inputEncoding  ) ;
        getLog().debug( "overviewFile=" + overviewFile ) ;
        getLog().debug( "stylesheet=" + stylesheet  ) ;
        getLog().debug( "sourcestylesheet=" + sourcestylesheet  ) ;
	getLog().debug( "namesCase=" + namesCase  ) ;
	getLog().debug( "dbUrl=" + dbUrl  ) ;
	getLog().debug( "dbUser=" + dbUser  ) ;
	getLog().debug( "dbPassword=" + ((null == dbPassword) ? "undefined" : "defined" )   ) ;
	getLog().debug( "inputObjects=" + inputObjects  ) ;
	getLog().debug( "inputTypes=" + inputTypes  ) ;
	getLog().debug( "showSkippedPackages=" + showSkippedPackages ) ;
	getLog().debug( "ignoreInformalComments=" + ignoreInformalComments ) ;
	getLog().debug( "plscope=" + plscope ) ;
	getLog().debug( "savesourcecode=" + savesourcecode ) ;
	getLog().debug( "driverName=" + driverName ) ;
	getLog().debug( "getMetadataStatement=" + getMetadataStatement ) ;
	getLog().debug( "getMetadataStatementReturnType=" + getMetadataStatementReturnType ) ;

        try {
	    if (!outputDirectory.exists()) 
	    {
	      getLog().info( "Creating directory " + outputDirectory.toString()  ) ;
	      outputDirectory.mkdirs();
	    }
	    PLDocTask task = new PLDocTask();
	    task.init();
	    task.setDestdir(outputDirectory);
	    task.setDoctitle(applicationTitle);
	    System.err.println("dbUser="+dbUser);
	    System.err.println("dbPassword="+dbPassword);
	    if (null == dbUser || "".equals(dbUser) || null == dbPassword || "".equals(dbPassword) )
	    {
		System.err.println("Some credntials are missing: setting credentials from Server credentials" );
		setServerCredentials(dbUrl);
	    }
	    task.setDbUrl(dbUrl); 
	    task.setDbUser(dbUser);
	    task.setDbPassword(dbPassword);
	    task.setDbPassword(getDecryptedPassword(dbPassword));
	    task.setInputObjects(inputObjects);
	    task.setInputTypes(inputTypes);
	    task.setInputEncoding(inputEncoding);
	    task.setShowSkippedPackages(showSkippedPackages);
	    task.setIgnoreInformalComments(ignoreInformalComments);
	    task.setPlscope(plscope);
	    task.setSaveSourceCode(savesourcecode);
	    PLDocTask.NamesCase antNamesCase = new PLDocTask.NamesCase();
	    antNamesCase.setValue(namesCase);
	    task.setNamesCase(antNamesCase);

	    /* Set non-Oracle settings only if they are not null;
	     * otherwise, rely on the defaults  
	     */
            if (null != overviewFile) task.setOverview(overviewFile);
            if (null != stylesheet) task.setStylesheet(stylesheet);
            if (null != sourcestylesheet) task.setSourceStylesheet(sourcestylesheet);
	    if (null != driverName) task.setDriverName(driverName);
	    if (null != getMetadataStatement) task.setGetMetadataStatement(getMetadataStatement);
	    if (null != getMetadataStatementReturnType) task.setReturnType(getMetadataStatementReturnType);

	    if (null != sourceDirectory && null != includes)
	    {
	      org.apache.tools.ant.types.FileSet fset = new org.apache.tools.ant.types.FileSet();
	      fset.setDir(sourceDirectory);
	      fset.setIncludes(includes);
	      task.addFileset(fset);
	    }

	    FileSetManager fileSetManager = new FileSetManager(getLog());

	    for (FileSet fileSet : fileSets ) {
	      org.apache.tools.ant.types.FileSet fset = new org.apache.tools.ant.types.FileSet();
	      fset.setDir(new File (fileSet.getDirectory() )  );
	      
	      /* Maven FileSet includes are multiple include entries 
	       * ANT   FileSet include is single (it can contain multiple space-separated or comma-separated entries)
	       * 
	       * Convert Maven to ANT FileSet 
	       */ 
	      StringBuilder includesString = new StringBuilder();
	      for(String include : fileSet.getIncludesArray() )
	      {
		includesString.append(" ");
		includesString.append(include);
	      }
	      fset.setIncludes(includesString.toString().trim());
	      
	      /* Maven FileSet excludes are multiple include entries 
	       * ANT   FileSet exclude is single (it can contain multiple space-separated or comma-separated entries)
	       * 
	       * Convert Maven to ANT FileSet 
	       */ 
	      StringBuilder excludesString = new StringBuilder();
	      for(String exclude : fileSet.getExcludesArray() )
	      {
		excludesString.append(" ");
		excludesString.append(exclude);
	      }
	      fset.setExcludes(excludesString.toString().trim());
	      task.addFileset(fset);
	    }

	    Project proj = new Project();
	    proj.setBaseDir(outputDirectory);
	    proj.setName(applicationTitle);
	    task.setProject(proj);
	    task.execute();
        } 
	catch (BuildException ex) {
	  //Convert Ant Build Exception into expected Maven Exception 
	  throw new MavenReportException("Failed generating pldoc report",ex);
        }
	catch (RuntimeException ex) {
	  throw new MavenReportException("Failed generating pldoc report",ex);
        }
    }

    /** {@inheritDoc} */

    public String getOutputName() {
        return destDir + "/index";
    }

    /** {@inheritDoc} */

    public String getName(Locale locale) {
        if ( StringUtils.isEmpty( name ) )
        {
            return getBundle( locale ).getString( "report.pldoc.name" );
        }

        return name;
    }

    /** {@inheritDoc} */

    public String getCategoryName() {
        return CATEGORY_PROJECT_REPORTS;
    }

    /** {@inheritDoc} */

    public String getDescription(Locale locale) {
        if ( StringUtils.isEmpty( description ) )
        {
            return getBundle( locale ).getString( "report.pldoc.description" );
        }

        return description;
    }

    public void setDestDir(String destDir) {
      this.destDir = destDir; 

	getLog().debug( "setDestDir: param destDir=" + destDir  ) ;
	getLog().debug( "setDestDir: outputDirectory=" + this.outputDirectory  ) ;
	getLog().debug( "setDestDir: destDir=" + this.destDir  ) ;
	getLog().debug( "setDestDir: reportOutputDirectory=" + this.reportOutputDirectory  ) ;
      updateReportOutputDirectory(reportOutputDirectory, destDir) ;
    }


    public void setReportOutputDirectory(File reportOutputDirectory) {

	getLog().debug( "setReportOutPutDirectory: param reportOutputDirectory=" + reportOutputDirectory  ) ;
	getLog().debug( "setReportOutPutDirectory: outputDirectory=" + this.outputDirectory  ) ;
	getLog().debug( "setReportOutPutDirectory: destDir=" + this.destDir  ) ;
	getLog().debug( "setReportOutPutDirectory: reportOutputDirectory=" + this.reportOutputDirectory  ) ;
      updateReportOutputDirectory(reportOutputDirectory, destDir) ;
    }

    private void updateReportOutputDirectory(File reportOutputDirectory, String destDir) {
        if ( ( reportOutputDirectory != null ) 
	     && ( destDir != null ) 
	     && ( !reportOutputDirectory.getAbsolutePath().endsWith( destDir ) ) 
	   )
        {
            this.reportOutputDirectory = new File( reportOutputDirectory, destDir );
        }
        else
        {
            this.reportOutputDirectory = reportOutputDirectory;
        }
	getLog().debug( "updateReportOutPutDirectory: reportOutputDirectory=" + this.reportOutputDirectory  ) ;
    }

    /** {@inheritDoc} */

    public File getReportOutputDirectory() {
        if ( reportOutputDirectory == null )
        {
            return outputDirectory;
        }
        return reportOutputDirectory;
    }

    /** {@inheritDoc} */

    public boolean isExternalReport() {
         return true;
    }

    /** {@inheritDoc} */

    public boolean canGenerateReport() {
        return true;
    }

     /**
     * Gets the resource bundle for the specified locale.
     *
     * @param locale The locale of the currently generated report.
     * @return The resource bundle for the requested locale.
     */
    private ResourceBundle getBundle( Locale locale )
    {
        return ResourceBundle.getBundle( "pldoc-report", locale, getClass().getClassLoader() );
    }

    /**
     * get DBPassword
     *
     * Specified
     *  Not Encrypted - use as given
     *  Encrypted - decrypt using standard Maven mechanism
     *
     * Not Specified - fall back using DBURL 
     *  
     */
    private String getDecryptedPassword ( String password )
    throws MavenReportException //MojoExecutionException
    {

	final DefaultSecDispatcher securityDispatcher = new DefaultSecDispatcher();

	String configurationFilePath = securityDispatcher.getConfigurationFile();
	System.err.println("configurationFilePath \""+ configurationFilePath + "\"");

	try
	{

	    File configurationFile =  new File ( configurationFilePath) ;

	    if ( configurationFilePath.startsWith( "~" ) )
	    {
		configurationFilePath = System.getProperty( "user.home" ) + configurationFilePath.substring( 1 );
		configurationFile =  new File ( configurationFilePath) ;

		System.err.println(" Amended configurationFilePath \""+ configurationFilePath + "\"");

	    }
	    
	    //Fallback to Maven default file location if the Plexus default file location does not exist or is unreadable
	    if ( ! ( configurationFile.exists() && configurationFile.canRead() ) )
	    {
		
		configurationFile =  new File ( System.getProperty( "user.home" ) + "/.m2/settings-security.xml" ) ;
		System.err.println("configurationFilePath \""+ configurationFilePath + "\"");

		if ( configurationFile.exists() && configurationFile.canRead() ) 
		{
		    //Set configurationFilePath, replacing any Windows style directory separators
		    configurationFilePath = configurationFile.getCanonicalPath().replace("\\", "\\\\" ) ;   
		    System.err.println(" Fallback Maven configurationFilePath \""+ configurationFilePath + "\"");
		    securityDispatcher.setConfigurationFile(configurationFilePath);
		}
	    }

	}
	catch ( final IOException ex )
	{
	    throw new MavenReportException( "Failed to decrypt password: "+ password, ex );
	}

	final String file = System.getProperty( DefaultSecDispatcher.SYSTEM_PROPERTY_SEC_LOCATION, configurationFilePath );

	String master = null;

	try
	{

	    final DefaultPlexusCipher cipher = new DefaultPlexusCipher();

	    /* If the provided DB password is not encrypted - use it directly*/
	    if (!cipher.isEncryptedString(password))
	    {
	        System.err.println("Unencrypted password \""+ password  + "\"");
	        System.out.println("Unencrypted password \""+ password  + "\"");
		return password ;
	    }

	    final SettingsSecurity sec = SecUtil.read( file, true );
	    if ( sec != null )
	    {
		master = sec.getMaster();
	        System.err.println("SettingsSecurity exists ");
	        System.out.println("SettingsSecurity exists ");
	    }

	    if ( master == null )
	    {
		throw new IllegalStateException( "Master password is not set in the setting security file: " + file );
	    }

	    System.err.println("Master exists ");
	    System.out.println("Master exists ");

	    final String masterPassword =
		cipher.decryptDecorated( master, DefaultSecDispatcher.SYSTEM_PROPERTY_SEC_LOCATION );

	    System.err.println("Master password \""+ masterPassword  + "\"");
	    System.out.println("Master password \""+ masterPassword  + "\"");

	    final String result = cipher.decryptDecorated( password, masterPassword );
	    //logger.info( result );

	    System.err.println("Decrypted password \""+ result  + "\"");
	    System.out.println("Decrypted password \""+ result  + "\"");
	    return result;
	}
	catch ( final PlexusCipherException ex )
	{
	    //throw new MojoExecutionException( "Failed to decrypt password: "+ password, ex );
	    throw new MavenReportException( "Failed to decrypt password: "+ password, ex );
	}
	catch ( final SecDispatcherException ex )
	{
	    //throw new MojoExecutionException( "Failed to decrypt password: "+ password, ex );
	    throw new MavenReportException( "Failed to decrypt password: "+ password, ex );
	}
    }
    
    /**
     * Get Server Credentials Username and Password
     *
     * Not Specified - fall back using DBURL 
     *  
     */
    private void setServerCredentials ( String dbUrl )
    throws MavenReportException //MojoExecutionException
    {

	try
	{

	    //Maven3 Settings mavenSettings = new SettingsBuilder().buildDefaultSettings(); 
	    
	    org.apache.maven.settings.Settings mavenSettings = mavenSession.getSettings();

	    final URI uri = getURI(dbUrl);
	    uri.parseServerAuthority();
	    dump("After parseServerAuthority", uri);


	    //Create a list of ID search
	    // Full URL
	    //
	    //
	    System.err.println("dbUrl \"" + dbUrl + "\" ..." );
	    System.err.println("Protocol \"" + uri.getScheme() + "\" " );
	    System.err.println("Authority \"" + uri.getAuthority() + "\" " );
	    System.err.println("UserInfo \"" + uri.getUserInfo() + "\" " );
	    System.err.println("Host \"" + uri.getHost() + "\" " );
	    System.err.println("Port \"" + uri.getPort() + "\" " );

	    /*
	     * Create a list of ID candidates for server credentials from the dbUrl string
	     * The list runs in decreasing detail
	     */
	    String [] idCandidates = { 
					dbUrl //  Full dbUrl
					 // JDBC specific 
					,"jdbc:"+ uri.getSchemeSpecificPart() // 
					,"jdbc:"+ uri.getAuthority() // UserInfo + Host + Port 
					,"jdbc:"+ uri.getUserInfo() +"@"+ uri.getHost() +":"+ Integer.toString(uri.getPort() ) 
					,"jdbc:"+ uri.getHost() +":"+ Integer.toString(uri.getPort() ) 
					,"jdbc:"+ uri.getHost() 
					//Host specific 
					,uri.getHost() +":"+ Integer.toString(uri.getPort() ) 
					,uri.getHost() 
	                             };

	    for ( int id = 0 ; id < idCandidates.length ; id++ )
	    {	
		Server server = mavenSettings.getServer(idCandidates[id]); 

		if ( null == server )
		{
		    System.err.println("Server (" + id +"/"+ idCandidates[id] +") is null"); 
		}
		else
		{
		    final String serverUser = server.getUsername();
		    final String serverPassword = server.getPassword();
		    System.err.println("Server credentials for " + dbUrl + " from Server (" + id +"/"+ idCandidates[id] + ") : username=" + serverUser + "; password=" + serverPassword ); 


		    if (!"".equals(serverUser) && !"".equals(serverPassword) )
		    {
			if (!"".equals(serverUser) && !"".equals(dbUser) && !serverUser.equals(dbUser) )
			{
			    throw new MavenReportException( "Mismatched Server credentials for dbUrl: "+ dbUrl 
				                            + " - usernames do not match (project DBUser=\"" 
							    + dbUser + "\" != Server.username =\"" 
							    + serverUser  + "\""
							  );
			}
			else
			{
			    System.err.println("Assigning plugin credentials from Server (" + id +"/"+ idCandidates[id] + ")" ); 
			    dbUser = serverUser;
			    dbPassword = serverPassword;
			}
		    }

		    //Stop search
		    return; 

		}
	    }	

	}
	catch ( final URISyntaxException ex )
	{
	    ex.printStackTrace();
	    throw new MavenReportException( "Failed to identify credentials for dbUrl: "+ dbUrl, ex );
	}
	
    }
    
    /**
     * Populate the URI from the original string
     *
     * @throws URISyntaxException
     */
    private URI getURI(String url) throws URISyntaxException {
        if (url.startsWith("jdbc:")) {
            // java.net.URI is intended for "normal" URLs
            URI jdbcURI = new URI(url);
	    /*
	     * scheme:[//[user[:password]@]host[:port]][/path][?query][#fragment]
	     *
	     * jdbc:oracle:thin:[<user>/<password>]@//<host>[:<port>]/<service>
	     * jdbc:oracle:oci:[<user>/<password>]@//<host>[:<port>]/<service>
	     *
	     *
	    */

            System.err.println( "setFields - URL=" + url );
            dump("jdbcURL", jdbcURI);

            jdbcURI = new URI(url.substring(5));

            System.err.println( "setFields - substr(jdbcURL,5)=" + url.substring(5) );
            dump("substr(jdbcURL,5)", jdbcURI);

            jdbcURI = new URI(jdbcURI.getSchemeSpecificPart().replace("@//","@") );

            dump("jdbcURI.getSchemeSpecificPart.replace(1)", jdbcURI);

            jdbcURI = new URI("http://"+jdbcURI.getSchemeSpecificPart().replace("@//","@") );

            dump("jdbcURI.getSchemeSpecificPart.replace(2)", jdbcURI);

            // jdbc:subprotocol:subname
            String[] uriParts = url.split(":");
            for (String part : uriParts) {
                System.err.println( "JDBCpart=" + part );
            }

            /*
             * Expect jdbc : subprotocol [ : subname ] : connection details
             * uriParts.length < 3 Error 
	     * uriParts.length = 3 Driver information may be inferred from part[1] 
	     * - the subprotocol 
	     * uriParts.length >= 4 Driver information may be inferred from part[2]- the first part
             * of the subname
             */
            if (3 == uriParts.length) {
                System.err.println( "subprotocol = " + uriParts[1] );
		//jdbcURI = new URI( uriParts[0] +":"+ uriParts[1] , 
		//	jdbcURI.getUserInfo(), jdbcURI.getHost(), jdbcURI.getPort(), jdbcURI.getPath(), jdbcURI.getQuery(), jdbcURI.getFragment()) ;
		//dump("Scheme with Subprotocol", jdbcURI);
            } else if (4 <= uriParts.length) {
                System.err.println( "subprotocol =" + uriParts[1] );
                System.err.println( "subnamePrefix =" +  uriParts[2] );
		//jdbcURI = new URI( uriParts[0] +":"+ uriParts[1] +":"+ uriParts[2], 
		//	jdbcURI.getUserInfo(), jdbcURI.getHost(), jdbcURI.getPort(), jdbcURI.getPath(), jdbcURI.getQuery(), jdbcURI.getFragment()) ;
		//dump("Scheme with Subprotocol and subnamePrefix", jdbcURI);

            } else {
                throw new URISyntaxException(url, "Could not understand JDBC URL", 1);
            }

	    return jdbcURI ;
        } else 
	{
                throw new URISyntaxException(url, "This is not a JDBC URL", 1);
	}

    }


    /**
     * Dump this URI.
     *
     * @param description
     * @param dburi
     */
    static void dump(String description, URI dburi) {

        String dumpString = String.format(
                "dump (%s)\n: isOpaque=%s, isAbsolute=%s Scheme=%s,\n SchemeSpecificPart=%s,\n Authority=%s,\n UserInfo=%s,\n Host=%s,\n Port=%s,\n Path=%s,\n Fragment=%s,\n Query=%s\n",
                description, dburi.isOpaque(), dburi.isAbsolute(), dburi.getScheme(), dburi.getSchemeSpecificPart(),
                dburi.getAuthority(), dburi.getUserInfo(), dburi.getHost(), dburi.getPort(), dburi.getPath(), dburi.getFragment(), dburi.getQuery());

        System.err.println(dumpString);

        String query = dburi.getQuery();
        if (null != query && !"".equals(query)) {
            String[] params = query.split("&");
            for (String param : params) {
                String[] splits = param.split("=");
                String name = splits[0];
                String value = null;
                if (splits.length > 1) {
                    value = splits[1];
                }
                System.err.println(String.format("name=%s,value=%s\n", name, value));
            }
        }
    }


}
