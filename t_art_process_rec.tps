CREATE OR REPLACE TYPE U1."T_ART_PROCESS_REC"                                          as object
(
  start_date varchar2(50),
  auth_err   NUMBER,
  trans_err  NUMBER,
  all_err    NUMBER,
  all_0      NUMBER,
  auth_ok    NUMBER,
  trans_ok   NUMBER,
  all_ok     NUMBER
)
/
grant execute on U1.T_ART_PROCESS_REC to ESB_USER;


