

CREATE OR REPLACE 
EDITIONABLE
PROCEDURE prc_accessible (pa_parameter_1 NUMBER) 
ACCESSIBLE BY ( FUNCTION other_schema.fn_function, PROCEDURE other_schema.prc_procedure, PACKAGE other_schema.pkg_package, TRIGGER other_schema.trg_trigger, TYPE other_schema.typ_type )
IS
 l_v NUMBER ;
BEGIN
  l_v :=  ps_parameter_1 * ps_parameter_1   ;
END prc_accessible;
/ 


