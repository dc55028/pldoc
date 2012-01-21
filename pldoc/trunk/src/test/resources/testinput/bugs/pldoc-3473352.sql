CREATE OR REPLACE
PACKAGE pldoc_bug.testcase_3473352_noescapes
AS
	/** Marker for Unicode Escape Characters */
        gUnicodeEscapePrefix  CONSTANT VARCHAR2(2 CHAR) := '\u'; -- Workaround to PLDoc Unicode Escape problem 
	/** Linear B Stallion - {@link http://www.fileformat.info/info/unicode/char/10085/index.htm}
	 *<p>This is a 4 byte Unicode Character
	*/
        gLinearBStallionTwoChar      CONSTANT VARCHAR2(2 CHAR) := '\U0001\U0085'; 
        gLinearBStallionOneEscape    CONSTANT VARCHAR2(2 CHAR) := '\U00010085'; 

        /**  Æ 	U+00E6 æ 	Latin	As in modern English "hat" */
        gAsh	VARCHAR2(1 CHAR) := '\U00C6' ;  
        /**  Þ	U+00FE þ	Futharc	þorn: modern "th" (survives in Icelandic) */
        gThorn	VARCHAR2(1 CHAR) := '\U00DE' ;  
        /**  Ð	U+00F0 ð	Old Irish 	Eð, þæt: modern "th" (survives in Icelandic) */
        gEth	VARCHAR2(1 CHAR) := '\U00D0' ;  
        /**  Ȝ	U+021D ȝ	Old Irish	Y, gh, g, w (not to be confused with Ezh) */
        gYogh	VARCHAR2(1 CHAR) := '\U021C' ;  
        /**  Ƿ	U+01BF ƿ	Futharc	(or Wen): modern "w" */
        gWynn	VARCHAR2(1 CHAR) := '\U01F7' ;  


FUNCTION unicode_escape
/** Convert string to escaped version.
 *<p>
 *Successful processing of this test case relies on PLDOC being compiled with <code>JAVA_UNICODE_ESCAPE = false;</code>.
 *</p>
 *<p>Without this compilation flag setting, the "\" "u" character is interpreted within the low-lvel Java code 
 *as the indicator that the following characters are the Unicode codepoint and processing fails. 
 *</p>
 *@param theString Original, unescaped string 
 *@param theEscapeSolidusFlag Escape '/' character
 *@param theAsciiOutputFlag Escape all characters with Java-compatible escape codes
 *@return Escaped string 
 */
(theString IN VARCHAR2, theEscapeSolidusFlag IN BOOLEAN DEFAULT FALSE, theAsciiOutputFlag IN BOOLEAN DEFAULT TRUE) RETURN VARCHAR2
;
END;
/

CREATE OR REPLACE
PACKAGE BODY pldoc_bug.testcase_3473352_noescapes
AS
FUNCTION unicode_escape
/** Convert string to escaped version.
 *<p>
 *Successful processing of this test case relies on PLDOC being compiled with <code>JAVA_UNICODE_ESCAPE = false;</code>.
 *</p>
 *<p>Without this compilation flag setting, the "\" "u" character is interpreted within the low-lvel Java code 
 *as the indicator that the following characters are the Unicode codepoint and processing fails. 
 *</p>
 *@param theString Original, unescaped string 
 *@param theEscapeSolidusFlag Escape '/' character
 *@param theAsciiOutputFlag Escape all characters with Java-compatible escape codes
 *@return Escaped string 
 */
(theString IN VARCHAR2, theEscapeSolidusFlag IN BOOLEAN DEFAULT FALSE, theAsciiOutputFlag IN BOOLEAN DEFAULT TRUE) RETURN VARCHAR2
IS
	aString		VARCHAR2(32767);
	aBuffer		VARCHAR2(40);
	aNumber		NUMBER;
BEGIN
	IF (theString IS NULL) THEN
		RETURN '""';
	END IF;

	FOR i IN 1 .. LENGTH(theString) LOOP
		aBuffer := SUBSTR(theString, i, 1);
		CASE aBuffer
		WHEN CHR( 8) THEN aBuffer := '\b';
		WHEN CHR( 9) THEN aBuffer := '\t';
		WHEN CHR(10) THEN aBuffer := '\n';
		WHEN CHR(13) THEN aBuffer := '\f';
		WHEN CHR(14) THEN aBuffer := '\r';
		WHEN CHR(34) THEN aBuffer := '\"';
		WHEN CHR(47) THEN IF (theEscapeSolidusFlag) THEN aBuffer := '\/'; END IF;
		WHEN CHR(92) THEN aBuffer := '\\';
		ELSE
			IF (ASCII(aBuffer) < 32) THEN
				aBuffer := '\u' || REPLACE(SUBSTR(TO_CHAR(ASCII(aBuffer), 'XXXX'), 2, 4), ' ', '0');
			ELSIF (theAsciiOutputFlag) THEN
				aBuffer := REPLACE(ASCIISTR(aBuffer), '\', '\u');
			END IF;
		END CASE;

		aString := aString || aBuffer;
	END LOOP;

	RETURN '"' || aString || '"';
END unicode_escape;
END;
/


