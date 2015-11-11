create or replace PROCEDURE prc_extract_expression(p_1 IN VARCHAR2)
AS
    l_last_update_date test_table.last_update_date%TYPE;
    current_date test_table.last_update_date%TYPE;
    diff interval day to second;
    diff_min NUMBER;
  BEGIN
    current_date := SYSTIMESTAMP;
    SELECT last_update_date
      INTO l_last_update_date
        FROM test_table
        WHERE source = src;
    diff := current_date - l_last_update_date;
    diff_min := EXTRACT(DAY FROM diff)*24*60+EXTRACT(HOUR FROM diff)*60+EXTRACT(MINUTE FROM diff);
    -- 2 hours 2x60=120
    IF (diff_min > 120) THEN
    	UPDATE test_table set last_update_date = current_date WHERE source = src;
	commit;
    END IF;
  EXCEPTION
    when NO_DATA_FOUND then
      BEGIN
        INSERT INTO test_table VALUES (src, systimestamp);
	commit;
      END;
  END;

