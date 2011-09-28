CREATE OR REPLACE 
TYPE ty_ad_validation_status_obj
AS OBJECT (
    adseq             VARCHAR2(42) -- btdo_ad.ad_id%TYPE
   ,displayad_id      VARCHAR2(10) -- btdo_ad.displayad_id%TYPE
   ,status            VARCHAR2(40) -- btdo_ad.status%TYPE
   );
/

SHOW ERRORS
