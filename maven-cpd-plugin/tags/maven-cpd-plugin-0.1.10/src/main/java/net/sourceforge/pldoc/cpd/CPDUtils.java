package net.sourceforge.pldoc.cpd;

import java.io.*;
import java.util.Properties;
import net.sourceforge.pldoc.Utils;
// Use local version import net.sourceforge.pldoc.ResourceLoader;
import net.sourceforge.pldoc.SubstitutionReader;

/**
* Utilities supporting the main functionality
* @author Stuart Turton 
*/
public class CPDUtils 
{


  /**
  * Copies required static files into the source code directory.
  *
  * This allows the XSL and CSS hrefs to cope with relocation of the root output directory 
  * or access through a web browser.
  *
  * @param outputDirectory directory to copy files
  * @param relativePath the relative path to the location of the root output directory 
  */
  public static void copyStaticSourceDirectoryFiles(File outputDirectory, String relativePath) throws Exception {
    try {
      // Copy sourcecode.xsl, replacing the stylesheet href with the relative href
      Properties  replacementProperties = new Properties();
      replacementProperties.put("sourcestylesheet.css", relativePath + "sourcestylesheet.css");
      Utils.CopyReaderToFile(
	new BufferedReader(
	  new SubstitutionReader( 
	    new BufferedReader(
	      new InputStreamReader(
				    (new ResourceLoader()).getResourceStream("sourcecode.xsl")
				   )
		)
	       ,replacementProperties
	      )
	    )
      , new File(outputDirectory.getPath() + File.separator + "sourcecode.xsl")
      );
    } catch(FileNotFoundException e) {
      System.err.println("File not found. ");
      e.printStackTrace();
      throw e;
    }
  }

  /**
  * Copies required static files into the root output directory.
  *
  * @param outputDirectory directory to copy files
  * @param sourceStylesheet the relative path to the location of the root output directory 
  */
  public static void copyStaticRootDirectoryFiles(File outputDirectory, File stylesheet, File sourceStylesheet) throws Exception {
    try {
      // Copy sourcecode.xsl, replacing the stylesheet href with the relative href
      Utils.CopyStreamToFile(
	  (null != stylesheet && stylesheet.exists()) 
	  ? Utils.getBOMInputStream(new FileInputStream ( stylesheet ) , null )
	  : (new ResourceLoader()).getResourceStream("defaultstylesheet.css")
	, new File(outputDirectory, "stylesheet.css")
      );

      Utils.CopyStreamToFile(
	  (null != sourceStylesheet && sourceStylesheet.exists()) 
	  ? Utils.getBOMInputStream(new FileInputStream ( sourceStylesheet ) , null )
	  : (new ResourceLoader()).getResourceStream("defaultstylesheet.css")
	, new File(outputDirectory, "sourcestylesheet.css")
      );
    } catch(FileNotFoundException e) {
      System.err.println("File not found. ");
      e.printStackTrace();
      throw e;
    }
  }

 

  /**
  * Return an InputStream, stripping out any BOM if the specified or default chracter encoding is UTF*.
  *
  * @param inputStream Stream that may or may not contain a BOM
  * @param inputEncoding 
  * @throws IOEXception
  */
  public static InputStream getBOMInputStream(InputStream inputStream, String inputEncoding) throws IOException {

      return Utils.getBOMInputStream(inputStream, inputEncoding) ;
  }


}
