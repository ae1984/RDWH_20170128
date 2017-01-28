CREATE OR REPLACE TYPE U1."PAR_EFFECT_RATEOBJECT"                                          as object
(
 session_count number,
 session_active_count number,
 par_effect_rate number,
 OSUSER varchar(100),
 username varchar(100),
 MACHINE varchar(100),
 SQL_ID varchar(100),
 sec number,
 average_effect number
)
/

