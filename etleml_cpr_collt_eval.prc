create or replace procedure u1.etleml_cpr_collt_eval
  as
    EMAIL_CODE varchar2(32) := 'FOLDER_COLLT_EVAL';

    TAB1  varchar2(1) := chr(9);
    CRLF1 varchar2(2) := chr(13) || chr(10);

    v_message clob;
    v_error_count number;

    v_subject varchar2(200);

    v_hour number;

  begin
    v_hour := to_number(to_char(sysdate, 'hh24'));

    if (v_hour < 8 or v_hour > 20) then
      return;
    end if;

    v_error_count := 0;
    v_subject := 'Оценка залога на верификации';
    v_message := v_message || 'FOLDER_ID' || TAB1 || 'FOLDER_DATE_CREATE' || TAB1 || 'FOLDER_NUMBER' || TAB1 ||
                 'FOLDER_STATE' || TAB1 || 'BUSINESS_PROCESS' || TAB1 || CRLF1 || CRLF1;

    for r in (select *
              from RISK_VERIF.V_RFO_FOLDER_COLLT_EVAL f
              where --f.folder_date_create > trunc(sysdate) and
                    --f.folder_state_code in ('ACCEPT_CPR', 'CHECK_CPR') and
                    not exists (select null
                                from u1.T_FOLDER_COLLT_EVAL_SENDED ff
                                where ff.folder_id = f.folder_id and
                                      ff.date_create > trunc(sysdate)))
    loop
      v_error_count := v_error_count + 1;
      v_message := v_message || r.folder_id || TAB1 || to_char(r.folder_date_create, 'dd-mm-yyyy hh24:mi:ss') || TAB1 ||
                   r.folder_number || TAB1 || r.verif_state || TAB1 || r.business_process || CRLF1;

      insert into u1.T_FOLDER_COLLT_EVAL_SENDED (folder_id, date_create)
      values (r.folder_id, sysdate);
    end loop;

    if (v_error_count > 0) then
      pkg_mail.add_email(in_email_code => EMAIL_CODE,
                         in_email_body => v_message,
                         in_email_subject => v_subject);
    else
      delete from u1.T_FOLDER_CPR_DEP1_SENDED;
    end if;

    commit;

  end etleml_cpr_collt_eval;
/

