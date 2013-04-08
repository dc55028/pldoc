WITH caller AS 
(
  SELECT    
            OWNER,
            OBJECT_NAME ,
            OBJECT_TYPE ,
            Line,
            Col,
            NAME Name,
            TYPE   Type,
            USAGE  Usage,
            USAGE_ID,
            USAGE_CONTEXT_ID
            ,signature 
            ,dbms_utility.get_hash_value(owner||'~'||object_type||'~'||object_name, 1000000, 4194304  ) object_hash
            ,dbms_utility.get_hash_value(owner||'~'||object_type||'~'||object_name||'~'||line||'~'||col, 1000000, 4194304  ) line_column_hash
    FROM ALL_IDENTIFIERS
      WHERE USAGE = 'CALL' 
)
SELECT *
FROM
(
select 
caller.object_hash caller_object_hash,
caller.line_column_hash  caller_method_hash,
CALLER.OWNER CALLER_OWNER,
CALLER.OBJECT_NAME CALLER_OBJECT_NAME ,
CALLER.OBJECT_TYPE CALLER_OBJECT_TYPE ,
CALLER.LINE CALLER_LINE,
CALLER.Col CALLER_Col,
CALLER.NAME CALLER_NAME ,
CALLER.TYPE   CALLER_TYPE,
CALLER.USAGE  CALLER_USAGE,
CALLER.USAGE_ID CALLER_USAGE_ID,
CALLER.USAGE_CONTEXT_ID CALLER_USAGE_CONTEXT_ID
,CALLER.SIGNATURE CALLER_SIGNATURE
,CALLED.OWNER CALLED_OWNER
,CALLED.OBJECT_NAME CALLED_OBJECT_NAME
,CALLED.OBJECT_TYPE  CALLED_OBJECT_TYPE
,CALLED.LINE CALLED_LINE
,CALLED.COL CALLED_COL
,CALLED.NAME CALLED_NAME
,CALLED.TYPE   CALLED_TYPE
,CALLED.USAGE CALLED_USAGE 
,DENSE_RANK() OVER (PARTITION BY 
                       CALLER.OWNER 
                      ,CALLER.OBJECT_NAME 
                      ,CALLER.OBJECT_TYPE  
                      ,CALLER.LINE 
                      ,CALLER.COL 
                      ORDER BY 
                      CALLED.USAGE DESC /* Prefer DEFINITION (OBJECT BODY) to DECLARATION (OBJECT SPECIFICATION)*/
                      ) priority
FROM CALLER
JOIN ALL_IDENTIFIERS CALLED ON (CALLER.SIGNATURE = CALLED.SIGNATURE)
WHERE  CALLED.USAGE IN ( 'DECLARATION', 'DEFINITION') 
AND   CALLED.TYPE IN ( 'FUNCTION', 'PROCEDURE') 
)
WHERE PRIORITY = 1 
--AND CALLED_OWNER IN ( 'PLDOC','PLDOC_BUG','PM','PLS' ) 
--AND CALLED_OWNER IN ( 'PLDOC','PLDOC_BUG','PM','PLS' ) 
