

CREATE 
TRIGGER 
/**
*<P>Comment placed between the TRIGGER keyword and the trigger name. </p>
*
*/
trg_before_keyword
AFTER INSERT ON T4
REFERENCING NEW AS newRow
FOR EACH ROW
WHEN (newRow.a <= 10)
BEGIN
INSERT INTO T5 VALUES(:newRow.b, :newRow.a);
END trg_before_keyword;
/

