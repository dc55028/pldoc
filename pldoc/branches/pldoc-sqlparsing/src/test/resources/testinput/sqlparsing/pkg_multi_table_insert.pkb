


DECLARE 
	l_dummy VARCHAR2(1);
BEGIN

--INSERT ALL

INSERT ALL
     --<>--
     INTO object_owners (owner, object_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     INTO table_owners (owner, table_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     INTO index_owners (owner, index_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     INTO view_type (owner, view_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     INTO mview_type (owner, mview_type, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
  SELECT owner
  ,      object_type
  ,      object_name
  ,      object_id
  ,      created
  FROM   all_objects
  WHERE  ROWNUM <= 50
  ;

/* Apparently not allowed with conditional clause
--INSERT FIRST

INSERT FIRST
     --<>--
     INTO object_owners (owner, object_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     INTO table_owners (owner, table_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     INTO index_owners (owner, index_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     INTO view_type (owner, view_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     INTO view_type (owner, mview_type, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     --<>--
  SELECT owner
  ,      object_type
  ,      object_name
  ,      object_id
  ,      created
  FROM   all_objects
  WHERE  ROWNUM <= 50
  ;

*/

--INSERT ALL

INSERT ALL
     WHEN 1 = 1  THEN
     --<>--
     INTO object_owners (owner, object_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     WHEN object_type = 'TABLE' THEN
     INTO table_owners (owner, table_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     WHEN object_type = 'INDEX' THEN
     INTO index_owners (owner, index_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     WHEN object_type = 'VIEW' THEN
     INTO view_type (owner, view_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     WHEN object_type = 'MATERIALIZED VIEW' THEN
     INTO mview_type (owner, mview_type, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     ELSE
     INTO other_type (owner, mview_type, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
  SELECT owner
  ,      object_type
  ,      object_name
  ,      object_id
  ,      created
  FROM   all_objects
  WHERE  ROWNUM <= 50
  ;

--INSERT FIRST

INSERT FIRST
     --<>--
     WHEN 1 = 1 THEN
     INTO object_owners (owner, object_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     WHEN object_type = 'TABLE' THEN
     INTO table_owners (owner, table_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     WHEN object_type = 'INDEX' THEN
     INTO index_owners (owner, index_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     WHEN object_type = 'VIEW' THEN
     INTO view_type (owner, view_name, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     WHEN object_type = 'MATERIALIZED VIEW' THEN
     INTO mview_type (owner, mview_type, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
     ELSE
     INTO other_type (owner, mview_type, object_id)
     VALUES  (owner, object_name, multi_table_seq.NEXTVAL)
     --<>--
  SELECT owner
  ,      object_type
  ,      object_name
  ,      object_id
  ,      created
  FROM   all_objects
  WHERE  ROWNUM <= 50
  ;


END;
/

