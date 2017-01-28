create or replace procedure u1.ETLEML_KN_APPR is
    v_message clob;
    
    v_subject varchar2(200);
    
    v_hour number;
    
    EMAIL_CODE constant varchar2(32) := 'KN_APPR';
    
    TAB1  constant varchar2(1) := chr(9);
    CRLF1 constant varchar2(2) := chr(13) || chr(10);
  
  begin
/*    v_hour := to_number(to_char(sysdate, 'hh24'));
    
    if (v_hour < 9 or v_hour > 20) then 
      return;
    end if;  */
    
    v_subject := '';
/*
DD
ISSUED_AMOUNT_MLN
ISSUE_RATE_AMOUNT
ISSUED_COUNT
ISSUE_RATE_COUNT
APPOVED_COUNT
APPR_RATE_COUNT
CONV_RATE
*/
    v_message := v_message || 
                 '|DD' || TAB1 || TAB1 || 
                 '|ISSUED_AMOUNT_MLN' || TAB1 || 
                 '|ISSUE_RATE_AMOUNT' || TAB1 || 
                 '|ISSUED_COUNT' || TAB1 || 
                 '|ISSUE_RATE_COUNT' || TAB1 ||
                 '|APPOVED_COUNT' || TAB1 || 
                 '|APPR_RATE_COUNT' || TAB1 || 
                 '|CONV_RATE' || TAB1 ||
                 CRLF1 || CRLF1;
                 
    for r in (select * from risk_sdastan.V_KN_STAT t)
    loop
      v_message := v_message || 
                   '|' || to_char(r.dd, 'dd-mm-yyyy') || TAB1 ||
                   '|' || r.ISSUED_AMOUNT_MLN || TAB1 || TAB1 || TAB1 || TAB1 ||
                   '|' || r.ISSUE_RATE_AMOUNT || TAB1 || TAB1 || TAB1 || TAB1 ||
                   '|' || r.ISSUED_COUNT || TAB1 || TAB1 || TAB1 ||
                   '|' || r.ISSUE_RATE_COUNT || TAB1 || TAB1 || TAB1 ||
                   '|' || r.APPOVED_COUNT || TAB1 || TAB1 || TAB1 ||
                   '|' || r.APPR_RATE_COUNT || TAB1 || TAB1 || TAB1 ||
                   '|' || r.CONV_RATE || TAB1 || 
                   CRLF1;
    end loop;
      
    pkg_mail.add_email(in_email_code => EMAIL_CODE,
                         in_email_body => v_message,
                         in_email_subject => v_subject);
end ETLEML_KN_APPR;
/

