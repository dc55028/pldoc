CREATE OR REPLACE
PACKAGE pldoc_bug.testcase_3473352_noescapes
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
        cUnicodeEscapePrefix  CONSTANT VARCHAR2(2) := '\'||'u'; -- Workaround to PLDoc Unicode Escape problem 
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
				--aBuffer := cUnicodeEscapePrefix || REPLACE(SUBSTR(TO_CHAR(ASCII(aBuffer), 'XXXX'), 2, 4), ' ', '0');
			ELSIF (theAsciiOutputFlag) THEN
				aBuffer := REPLACE(ASCIISTR(aBuffer), '\', '\u');
				--aBuffer := REPLACE(ASCIISTR(aBuffer), '\', cUnicodeEscapePrefix);
			END IF;
		END CASE;

		aString := aString || aBuffer;
	END LOOP;

	RETURN '"' || aString || '"';
END unicode_escape;
END;
/


