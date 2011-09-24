package net.sourceforge.pldoc.ant;

import org.apache.tools.ant.*;
import org.apache.tools.ant.types.*;

import java.io.*;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Properties;

import net.sourceforge.pldoc.*;

/**
 * PLDoc Ant Task
 * <p>To define task in project:</p>
 * <pre>
 *   &lt;taskdef
 *     name="pldoc"
 *     classname="net.sourceforge.pldoc.ant.PLDocTask"
 *     classpath="pldoc.jar" /&gt;
 * </pre>
 *
 * <p>To use:</p>
 * <pre>
 *   &lt;pldoc
 *     verbose = "yes" | "no" (default: "no")
 *     doctitle = text
 *     destdir = dir-path
 *     overview = file-path
 *     stylesheet = file-path (default: stylesheet from library)
 *     namesCase = "upper" | "lower"
 *     inputEncoding = encoding (default: OS dependant) &gt;
 *     ignoreInformalComments = (false | true) 
 *     showSkippePackages = (false | true) 
 *     driver = text
 *     url = text
 *     user = text
 *     password = text
 *     types = text
 *     sql = text
 *     &lt;!-- fileset+ --&gt;
 *   &lt;/pldoc&gt;
 * </pre>
 * <p>Where:</p>
 * <dl>
 *  <dt>doctitle</dt><dd>Documentation title</dd>
 *  <dt>destdir</dt><dd>Directory to store documentation files (created if doesn't exist)</dd>
 *  <dt>overview</dt><dd>File with overview in HTML format</dd>
 *  <dt>stylesheet</dt><dd>File with CSS-stylesheet for the result documentation. If omitted, default CSS will be used.</dd>
 *  <dt>namesCase</dt><dd>Upper/lower case to format PL/SQL names. If omitted, no case conversion is done.</dd>
 *  <dt>inputEncoding</dt><dd>Input files encoding</dd>
 *  <dt>ignoreInformalComments</dt><dd> true if documentation should be generated from formal comments only</dd>
 *  <dt>showSkippedPackages</dt><dd>Dispplay list of packages which failed to parse</dd>
 *  <dt>driver</dt><dd>JDBC driver class to use to connect to the database</dd>
 *  <dt>url</dt><dd>Database connection URL</dd>
 *  <dt>user</dt><dd>Database username </dd>
 *  <dt>password</dt><dd>Database password</dd>
 *  <dt>types</dt><dd>Comma separated list of database types to parse from the database</dd>
 *  <dt>sql</dt><dd>Comma separated list of database objects to parse from the database</dd>
 *  <dt>fileset</dt><dd>Specifies files to be parsed. See <a href="http://ant.apache.org/manual/CoreTypes/fileset.html">Ant FileSet</a> for more details.</dd>
 * </dl>
 */
public class PLDocTask extends Task {
  private Settings settings;
  private boolean m_verbose;
  private File m_destdir;
  private String m_doctitle;
  private File m_overviewFile;
  private ArrayList m_filesets;
  private File m_stylesheet;
  private char m_namesCase;
  private String m_inEnc;
  private boolean m_exitOnError;
  private String m_dbUrl ;
  private String m_dbUser ;
  private String m_dbPassword ;
  private String m_inputTypes ;
  private String m_inputObjects ;
  private boolean m_showSkippedPackages ;



  public PLDocTask() {
    m_verbose = false;
    m_destdir = null;
    m_doctitle = null;
    m_overviewFile = null;
    m_filesets = new ArrayList();
    m_stylesheet = null;
    m_namesCase = '0';
    m_inEnc = null;
    m_exitOnError = false;
    m_dbUrl = null;
    m_dbUser = null;
    m_dbPassword = null;
    m_inputTypes =  null;
    m_inputObjects =  null;
    m_showSkippedPackages = false;
  }

  public void setVerbose(boolean verbose) {
    m_verbose = verbose;
  }
  public void setDestdir(File dir) {
    m_destdir = dir;
  }
  public void setDoctitle(String doctitle) {
    m_doctitle = doctitle;
  }
  public void setOverview(File file) {
    m_overviewFile = file;
  }
  public void addFileset(FileSet fset) {
    m_filesets.add(fset);
  }
  public void setStylesheet(File file) {
    m_stylesheet = file;
  }
  public void setInputEncoding(String enc) {
    m_inEnc = enc;
  }
  public void setExitOnError(boolean exitOnError) {
    m_exitOnError = exitOnError;
  }

  public void setDbUrl(String dbUrl) {
          this.m_dbUrl = dbUrl;
  }
  public void setDbUser(String dbUser) {
          this.m_dbUser = dbUser;
  }
  public void setDbPassword(String dbPassword) {
          this.m_dbPassword = dbPassword;
  }
  public void setInputObjects(String inputObjects) {
          this.m_inputObjects = inputObjects;
  }
  public void setInputTypes(String inputTypes) {
          this.m_inputTypes = inputTypes;
  }
  public void setShowSkippedPackages(boolean showSkippedPackages) {
    this.m_showSkippedPackages = showSkippedPackages;
  }


  public static class NamesCase extends EnumeratedAttribute {
    public String[] getValues() {
      return new String[] {"upper", "lower"};
    }
  }

  public void setNamesCase(NamesCase namesCase) {
    m_namesCase = Character.toUpperCase(namesCase.getValue().charAt(0));
  }

  public void execute()
      throws BuildException {
    // check args
    if (m_destdir == null)
      throw new BuildException("Property \"destdir\" (destination directory) MUST be specified");

    if (m_doctitle == null)
      m_doctitle = "PL/SQL";

    if (m_inEnc == null)
      m_inEnc = System.getProperty("file.encoding");

    // execute

    try {
      settings = new Settings();
      settings.setOutputDirectory(m_destdir);
      settings.setApplicationName(m_doctitle);
      switch (m_namesCase) {
        case 'U':
          settings.setNamesUppercase(true);
          break;
        case 'L':
          settings.setNamesLowercase(true);
          break;
      }
      settings.setInputEncoding(m_inEnc);
      settings.setExitOnError(m_exitOnError);
      settings.setDbUrl(m_dbUrl);
      settings.setDbUser(m_dbUser);
      settings.setDbPassword(m_dbPassword);
      settings.setInputTypes( (null == m_inputTypes) 
                              ? new ArrayList() 
			      :  Arrays.asList(m_inputTypes.split(","))
			     );
      settings.setInputObjects( (null == m_inputObjects) 
                                ? new ArrayList() 
			       :  Arrays.asList(m_inputObjects.split(","))
			     );
      settings.setShowSkippedPackages(m_showSkippedPackages);


      Collection inputPaths = new ArrayList(); 
      // Add all the input files to a collection 
      for (int fsetI = 0; fsetI < m_filesets.size(); fsetI++) {
	FileSet fset = (FileSet) m_filesets.get(fsetI);
	DirectoryScanner dirScan = fset.getDirectoryScanner(getProject());
	File srcDir = fset.getDir(getProject());
	String[] srcFiles = dirScan.getIncludedFiles();
	for (int fileI = 0; fileI < srcFiles.length; fileI++) {
	  File inputFile = new File(srcDir, srcFiles[fileI]);
	   inputPaths.add(inputFile.getCanonicalPath());
	}
      }
      settings.setInputFiles(inputPaths);
      inputPaths = null;

      //Validate the settings 
      Collection inputFiles = settings.getInputFiles();
      Collection inputTypes = settings.getInputTypes();
      Collection inputObjects = settings.getInputObjects();

      // XOR the input file(s) OR object name(s) MUST be given
      if ((inputFiles.isEmpty() && inputObjects.isEmpty()) ||
	  (!inputFiles.isEmpty() && !inputObjects.isEmpty())) {
	throw new BuildException("You must specify input file name(s) or object name(s)!");
      }

      // When object name(s) are supplied, the connect info must be supplied.
      if (!inputObjects.isEmpty() &&
	  (settings.getDbUrl() == null || settings.getDbUser() == null || settings.getDbPassword() == null)) {
	throw new BuildException("Database url, db schema and db password are mandatory when object name(s) are supplied!");
      }

      // After specifying all relevant settings, just run the PLDoc process
      PLDoc pldoc = new PLDoc(settings);

      // Start running
      try {
	pldoc.run();
      } catch (Exception e) {
	throw new BuildException(e);
      }

    } catch (java.io.IOException ioEx) {
      throw new BuildException(ioEx);
    } catch (Exception otherEx) {
      throw new BuildException(otherEx);
    }



    m_verbose = false;
    m_destdir = null;
    m_doctitle = null;
    m_overviewFile = null;
    m_stylesheet = null;
    m_namesCase = '0';
    m_inEnc = null;
    m_dbUrl = null;
    m_dbUser = null;
    m_dbPassword = null;
    m_inputTypes = null;
    m_inputObjects = null;
    m_showSkippedPackages = false;
  }
  
  private BufferedReader getInputReader(File file)
      throws java.io.IOException {
    return new BufferedReader(
        new InputStreamReader(new FileInputStream(file), m_inEnc));
  }
}
