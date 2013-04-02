/* Copyright (C) 2002 Albert Tumanov

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

*/

package net.sourceforge.pldoc.cpd;

import java.io.*;
import java.util.*;
import java.text.DateFormat;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.dom.DOMResult;


import net.sourceforge.pmd.util.FileFinder;
import net.sourceforge.pmd.cpd.*;


import net.sourceforge.pldoc.parser.PLSQLParser;
import net.sourceforge.pldoc.parser.ParseException;
import net.sourceforge.pldoc.DbmsMetadata;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.w3c.dom.NamedNodeMap;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


/**
 * PL/SQL CPD documentation generator.
 * <p>
 *
 *
 * @author Stuart Turton
 * </p>
 */
public class CPD
{
  // The exception is used when system exit is desired but "finally" clause need also to be run.
  private static class SystemExitException extends RuntimeException {
    /** Serial UID */
    static final long serialVersionUID = 1L;

    /** Default-Konstruktor */
    SystemExitException() {
      super();
    }

    /** Konstruktor with cause */
    SystemExitException(Throwable t) {
      super(t);
    }
  }

  private static final String lineSeparator = System.getProperty("line.separator");
  private static String programName = "PLDoc(CPD) version: " + Version.id();
  private static HashMap hashMap = new HashMap();
  static {
    /*
    Put mappings for object types where the DBMS_METADATA.GET_DDL(OBJECT_TYPE) parameter
    differs from the contents of the dba_objects.object_type column,
    either because the  because we just want the spcification
    */
    hashMap.put( "PACKAGE", "PACKAGE_SPEC" );
    hashMap.put( "TYPE", "TYPE_SPEC" );
    hashMap.put( "PACKAGE BODY", "PACKAGE_BODY" );
    hashMap.put( "TYPE BODY", "TYPE_BODY" );

  }
  
  
  
private Map<String, SourceCode> source = new TreeMap<String, SourceCode>();
private CPDListener listener = new CPDNullListener();
private Tokens tokens = new Tokens();
private MatchAlgorithm matchAlgorithm;


  // Helper objects for retrieving resources relative to the installation.

  // Runtime settings
  public Settings settings;

  /**
  * Constructor.
  */
  public CPD(Settings settings)
  {
    this.settings = settings;
  }

  /** All processing is via the main method */
  public static void main(String[] args) throws Exception
  {
    long startTime = System.currentTimeMillis();
    System.err.println("");
    System.err.println(programName);

    // process arguments
    Settings settings = new Settings();
    settings.processCommandString(args);
    CPD cpd = new CPD(settings);

    // start running
    try {
      //Collect all the Source
      cpd.run();
      
      //
      cpd.go();
      if (cpd.getMatches().hasNext()) {
          File outputFile = settings.getOutputFile();
          PrintStream outputStream = System.out;
          
          if (null != outputFile )
          {
              System.err.println("Outputting CPD to to " + outputFile.getAbsolutePath());
              outputStream = new PrintStream(new FileOutputStream(outputFile));
          }

          outputStream.println(settings.renderer().render(cpd.getMatches()));
          
          File stylesheet = settings.getStylesheet() ;
          if (null != outputFile
              && null != stylesheet
              && "xml".equalsIgnoreCase(settings.getFormatString())
             )
          {
              System.err.println("Fenerating CPD HTML  to " + outputFile.getAbsolutePath());
             settings.generateHtml(outputFile);
          }
          System.exit(4);
      }
    } catch (SystemExitException e) {
      System.exit(-1);
    }

    long finishTime = System.currentTimeMillis();
    System.err.println("Done (" + (finishTime-startTime)/1000.00 + " seconds).");
  }

  /**
  * Runs CPD using the specified settings.
  *
  */
  public void run() throws Exception
  {
    // Map with all the packages (like files or database objects) which were skipped
    final SortedMap skippedPackages = new TreeMap();
    // Counts all the packages (like files or database objects) which were processed successfully
    long processedPackages = 0;

            // open the input file
    if (settings.isVerbose() ) System.out.println("Run() ");

    // if the output directory do not exist, create it
    if (!settings.getOutputDirectory().exists()) {
      System.err.println("Directory \"" + settings.getOutputDirectory() + "\" does not exist, creating ...");
      settings.getOutputDirectory().mkdir();
    }

    // open the output file (named application.xml)
    try {

      // for all the input files
              // open the input file
      if (settings.isVerbose() ) System.out.println("Parsing files ...");

      Iterator it = settings.getInputFiles().iterator();
      while (it.hasNext()) {
        String inputFileName = (String) it.next();
        final String packagename = inputFileName;

        // open the input file
        if (settings.isVerbose() ) System.err.println("Parsing file " + inputFileName + " ...");

        try {
          if (settings.isVerbose() ) 
	  {
	  	System.err.println("Processing : " + inputFileName + " as inputEncoding=\"" + settings.getInputEncoding() 
	                     +"\""
	                    );
	  }

          add(
	      new File(inputFileName)
             );

        } catch(FileNotFoundException e) {
          System.err.println("File not found: " + inputFileName);
          throw new SystemExitException(e);
        }
      } // for all the input files.
        // open the input file
      if (settings.isVerbose() ) System.err.println("Finished parsing files.");


      // open the database object 
      if (settings.isVerbose() ) System.err.println("Parsing database source ...");

      // for all the specified packages from the dictionary
      if ( settings.getDbUrl() != null && settings.getDbUser() != null && settings.getDbPassword() != null ) {
        // Load the Required JDBC driver class.
	Class.forName(settings.getDriverName());

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
		  /* Move query generation before connecting in order to allow validation of the query with needing a valid datbae to connect to */
		  Collection inputTypes ;
		  String typeList = "" ;
		 /*
		 */
		  if ( null != ( inputTypes = settings.getInputTypes() ) && ! inputTypes.isEmpty() )  
                {
			for (Iterator tt = inputTypes.iterator(); tt.hasNext() ; )
			{
		     String inputType = ((String) tt.next());
			  //Convert the list into quoted, UPPER-cased comma-separated list string
			  typeList += ((0 == typeList.length()) ? "" : ",") // prefix type name with comma for all except first type name
							   + "'"  + inputType.toUpperCase() + "'" ;
			}
                }


                //Default List to procedural code only
                if (typeList.equals(""))
                {
			 typeList =  "'PACKAGE','TYPE','PROCEDURE','FUNCTION','TRIGGER','PACKAGE BODY','TYPE BODY'"  ;
		  }


		  String sqlStatement = "SELECT  object_name"+
                                        ", object_type"+
                                        " FROM all_objects"+
                                        " WHERE owner = ?"+
                                        " AND   object_name LIKE ?"+
                                        " AND  object_type in (" + typeList + ")"+
                                        " ORDER BY "+
                                        " object_name"
                                        ;
		   if (settings.isVerbose() ) System.err.println("Using \"" + sqlStatement + "\"" );

		   if (settings.isVerbose() ) System.err.println("Connecting ..");
           conn = DriverManager.getConnection( settings.getDbUrl(), settings.getDbUser(), settings.getDbPassword() );
		   if (settings.isVerbose() ) System.err.println("Connected");


          pstmt = conn.prepareStatement(sqlStatement);


          DbmsMetadata dbmsMetadata = new DbmsMetadata(conn,settings.getGetMetadataStatement(), settings.getReturnType());

          it = settings.getInputObjects().iterator();
          while (it.hasNext()) {
            String input[] = ((String) it.next()).split("\\."); /* [ SCHEMANAME . ] OBJECTNAME */

			if ( input.length == 0 || input.length > 2 )
			{
			continue;
			}

            String inputSchemaName = ( input.length == 2 ? input[0] : settings.getDbUser() );
            String inputObjectName = ( input.length == 2 ? input[1] : input[0] );

            // get the object name(s)
	    ResultSet rset = null;

	    try {
		pstmt.setString(1, inputSchemaName);
		pstmt.setString(2, inputObjectName);

		rset = pstmt.executeQuery();

		// If the object is not present return false
		if (!rset.next()) {
		    // package does not exist

		    System.err.println("Object(s) like " + inputSchemaName + "." + inputObjectName + " do not exist or " + settings.getDbUser() + " does not have enough permissions (SELECT_CATALOG_ROLE role).");
		} else {
		    do {
			  final String objectName =  rset.getString(1);
			  String objectType = rset.getString(2);
			  final String fullyQualifiedObjectName = inputSchemaName + "." + objectName;
			  if (settings.isVerbose() ) System.err.println("Parsing " + objectType + " name " + fullyQualifiedObjectName + " ...");

                //Remap DBA_OBJECTS.OBJECT_TYPE column contents to DBMS_METADATA.GET_DDL(OBJECT_TYPE) parameter if necessary
			if ( hashMap.containsKey(objectType) )
			{
			   objectType =  (String) hashMap.get(objectType) ;
			}


			if (settings.isVerbose() ) System.err.println("Extracting DBMS_METADATA DDL for (object_type,object_name,schema)=(" 
                                                                       + objectType 
                                                                       + "," +objectName 
                                                                       + "," +inputSchemaName 
                                                                       + ") ..."
                                                                     );

			// Open the reader first to prevent failure to retrieve the source code
			// crashing the application
			 BufferedReader bufferedReader = null;  
			try {
			      bufferedReader =  
                              new BufferedReader(
                                dbmsMetadata.getDdl(objectType,
						    objectName,
						    inputSchemaName,
						    "COMPATIBLE",
						    "ORACLE",
						    "DDL") 
				                 );


                            
			    Throwable throwable = add(
                                0
				,bufferedReader 
                                ,objectName
                                ,inputSchemaName 
                                ,objectType 
			    );

			  // Test the processing result
			  if (throwable == null) {
			    processedPackages++;
			  } else {
			    skippedPackages.put(fullyQualifiedObjectName, throwable);
			  } 
			} 
			catch (SQLException sqlE)
			{
			    skippedPackages.put(fullyQualifiedObjectName, sqlE);
			}
			finally
			{
			      bufferedReader = null;  
			}
	  } while (rset.next());
		}
	    } finally  {
		if( rset != null ) rset.close();
	    }
	  }
	} finally {
	    if( pstmt != null ) pstmt.close();
	    if ( conn != null ) conn.close();
	}
      } // for all the specified objects from the dictionary




    } catch(Exception e) {
      e.printStackTrace();
      throw new SystemExitException();
    } finally {
      }
            if (settings.isVerbose() ) System.err.println("Added  " 
                + tokens.size() + " Abstract Syntax Tree(s) from "
                + source.size() + " Source(s)."
            );
        if ( null == tokens || 0 == tokens.size() ) 
        {
            System.err.println("run(): no Abstract Syntax Trees to compare") ;
        }

    }
  
  

  
  
  /**
  * Processes a package.
  *
  * 2006-05-16 - Matthias Hendler - Rewritten exception handling and methode signature.
  *
  * @param packageSpec  Package specification to parse
  * @param xmlOut       XML writer
  * @param pPackageName The name of the package which is processed
  * @return             Null, if successfully processed or otherwise throwable which was encountered during processing.
  * @throws SystemExitException   Thrown if an error occurred and the user specified the halt on errors option.
  *                               All other throwables will be caught.
  */



  // CPD
  //
  

  public void setCpdListener(CPDListener cpdListener) {
        this.listener = cpdListener;
    }

    public void go() {
        if (settings.isVerbose() ) System.err.println("Checking  " 
                + tokens.size() + " Abstract Syntax Tree(s) from "
                + source.size() + " Source(s)."
            );
        if ( null == tokens || 0 == tokens.size() ) 
        {
            System.err.println("go(): no Abstract Syntax Trees to compare") ;
        }
        else 
        {

            TokenEntry.clearImages();
            matchAlgorithm = new MatchAlgorithm(
                            source, tokens, 
                            settings.minimumTileSize(), 
                            listener
                            );
            matchAlgorithm.findMatches();
        }
    }

    public Iterator<Match> getMatches() {
        return matchAlgorithm.matches();
    }

    public void add(File file) throws IOException {
        Throwable throwable = add(1, file);
        
    }

    public void addAllInDirectory(String dir) throws IOException {
        addDirectory(dir, false);
    }

    public void addRecursively(String dir) throws IOException {
        addDirectory(dir, true);
    }

    public void add(List<File> files) throws IOException {
        for (File f: files) {
            add(files.size(), f);
        }
    }

    private void addDirectory(String dir, boolean recurse) throws IOException {
        if (!(new File(dir)).exists()) {
            throw new FileNotFoundException("Couldn't find directory " + dir);
        }
        FileFinder finder = new FileFinder();
        // TODO - could use SourceFileSelector here
        add(finder.findFilesFrom(dir, settings.filenameFilter(), recurse));
    }

    private Set<String> current = new HashSet<String>();

    private Throwable add(int fileCount, File file) throws IOException {
        String filePath = file.getCanonicalPath();
        if (settings.skipDuplicates()) {
            // TODO refactor this thing into a separate class
            String signature = file.getName() + '_' + file.length();
            if (current.contains(signature)) {
                System.err.println("Skipping " + file.getAbsolutePath() + " since it appears to be a duplicate file and --skip-duplicate-files is set");
                return null;
            }
            current.add(signature);
        }

        if (!filePath.equals(new File(file.getAbsolutePath()).getCanonicalPath())) {
            System.err.println("Skipping " + file + " since it appears to be a symlink");
            return null;
        }

        Throwable result = null;
        try
        {
            listener.addedFile(fileCount, file);
            SourceCode sourceCode = settings.sourceCodeFor(file);
            settings.tokenizer().tokenize(sourceCode, tokens);
            source.put(sourceCode.getFileName(), sourceCode);
            if (settings.isVerbose() ) System.err.println("Tokenized " + sourceCode.getFileName());

        }
        catch (Throwable t)
        {
            System.err.println("Throwable at object <"+ filePath +">: "+t);
            t.printStackTrace(System.err);
            if (settings.isExitOnError()) {
                throw new SystemExitException(t);
            }
            System.err.println("Package " + filePath + " skipped.");
            result = t;
        }
        return result;
    }


   private Throwable add(int fileCount
                    , Reader codeReader
                    , String objectName
		    , String schemaName
                    , String objectType
           ) 
           throws IOException {
            String signature = schemaName + '/' + objectType + '/' + objectName ;

        if (settings.skipDuplicates()) {
            // TODO refactor this thing into a separate class
            if (current.contains(signature)) {
                System.err.println("Skipping " + signature + " since it appears to be a duplicate file and --skip-duplicate-files is set");
                return null;
            }
            current.add(signature);
        }

        Throwable result = null;

        try
        {
            if (settings.isVerbose() ) System.err.println("Tokenizing database source code " + signature);
            listener.addedFile(fileCount, new File(signature) ); //Fake a file 
            DatabaseCodeLoader codeLoader = new DatabaseCodeLoader(codeReader,signature);
            SourceCode sourceCode = new SourceCode(codeLoader);
            settings.tokenizer().tokenize(sourceCode, tokens);
            source.put(signature, sourceCode);
            if (settings.isVerbose() ) System.err.println("Tokenized database source code " + sourceCode.getFileName());
        }
        catch (IOException ioe)
        {
            result = ioe;
            if (settings.isVerbose() ) System.err.println("Problem tokenizing database source code " + signature);
            ioe.printStackTrace(System.err);
            
        }
        catch (Throwable t) 
        {
            System.err.println("Throwable at object <"+ objectName +">: "+t);
            t.printStackTrace(System.err);
            if (settings.isExitOnError()) {
                throw new SystemExitException(t);
            }
            System.err.println("Package " + objectName + " skipped.");
            result = t;
        } 
        
        return result;
   }



}
