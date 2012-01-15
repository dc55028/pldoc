CREATE OR REPLACE
FUNCTION pldoc_bug.escapeString(theString IN VARCHAR2, theEscapeSolidusFlag IN BOOLEAN DEFAULT FALSE, theAsciiOutputFlag IN BOOLEAN DEFAULT TRUE) RETURN VARCHAR2
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
				--aBuffer := '\ u' || REPLACE(SUBSTR(TO_CHAR(ASCII(aBuffer), 'XXXX'), 2, 4), ' ', '0');
				aBuffer := cUnicodeEscapePrefix || REPLACE(SUBSTR(TO_CHAR(ASCII(aBuffer), 'XXXX'), 2, 4), ' ', '0');
			ELSIF (theAsciiOutputFlag) THEN
				--aBuffer := REPLACE(ASCIISTR(aBuffer), '\', \ u');
				aBuffer := REPLACE(ASCIISTR(aBuffer), '\', cUnicodeEscapePrefix);
			END IF;
		END CASE;

		aString := aString || aBuffer;
	END LOOP;

	RETURN '"' || aString || '"';
END escapeString;
/
