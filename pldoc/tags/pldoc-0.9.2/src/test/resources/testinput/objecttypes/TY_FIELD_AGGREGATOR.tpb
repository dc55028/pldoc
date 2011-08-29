CREATE OR REPLACE TYPE BODY ty_field_aggregator IS

  STATIC FUNCTION ODCIAggregateInitialize( listCtx       IN OUT 
ty_string_aggregator)
        RETURN NUMBER is

  BEGIN
        --Separate values with field (hash-'#') characters 
        /* initialize our persistent variables:
		   separator = pipe character
		   ,start_delimiter
		   ,end_delimiter
		   ,and list 
		*/
        listCtx := ty_string_aggregator('#',NULL,NULL,NULL);
        RETURN ODCIConst.success;
  END;
  
  
END;
/

