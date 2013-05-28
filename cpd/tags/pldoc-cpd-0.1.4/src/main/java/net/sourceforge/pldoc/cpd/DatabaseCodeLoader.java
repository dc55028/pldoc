/**
 * BSD-style license; for more info see http://pmd.sourceforge.net/license.html
 */
package net.sourceforge.pldoc.cpd;

import java.io.Reader;
import net.sourceforge.pmd.cpd.SourceCode;

public class DatabaseCodeLoader extends SourceCode.CodeLoader {
	public static final String DEFAULT_NAME = "CODE_LOADED_FROM_DATABASE";

	private Reader code;

	private String name;

	public DatabaseCodeLoader(Reader code) {
	    this(code, DEFAULT_NAME);
	}

	public DatabaseCodeLoader(Reader code, String name) {
	    this.code = code;
	    this.name = name;
	}

	@Override
	public Reader getReader() {
	    return code;
	}

	@Override
	public String getFileName() {
	    return name;
	}
}


