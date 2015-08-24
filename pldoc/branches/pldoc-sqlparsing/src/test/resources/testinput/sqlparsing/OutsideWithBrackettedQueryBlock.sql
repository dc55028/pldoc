CREATE OR REPLACE PACKAGE PKG_OUTSIDEWithBrackettedQueryBlock  AS
CURSOR c_cursor IS 
	  WITH with_query AS
	  (
		SELECT *
		FROM tableX
	  )
    (
     select id, selector from with_query
     )
    union all
     select id, selector from tableY
;
END;
/
