create or replace procedure u1.ETLT_OUT_REPORT_FRAUD is
  p_result number;
  p_error varchar2(4000);
  e_user_exception exception;
begin
   P_OUT_REPORT_FRAUD(p_result => p_result,p_error => p_error);
   if p_result = 0 then
       insert into NT_ETLCHK_LOG (chk_name,descr) values ('ETLT_OUT_REPORT_FRAUD',substr(p_error,1,1000)); 
       commit;
       raise e_user_exception;                  
   end if; 
  
end ETLT_OUT_REPORT_FRAUD;
/

