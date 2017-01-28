create or replace procedure u1.P_GET_FRAUD_1C(p_date_load date default trunc(sysdate),
                                           p_result    out number) 
is
d_dateoperation   date;
out_xml           clob;
out_result        varchar2(32000);
l_result_xml      xmltype;
n_rdwh_esb_xml_id number;
s_object_name     varchar2(50) := 'P_SEND_FRAUD_1C';
e_user_exception  exception;
begin
  --определяем последнюю загруженную дату в t_out_fraud_1c
  select max(f.dateoperation)
    into d_dateoperation
    from T_OUT_FRAUD_1C f;
  if d_dateoperation is null then
     --return;
     --временно
     d_dateoperation := to_date('01-10-2015','dd-mm-yyyy') - 1;  
  end if;   
  --строим курсор по незагруженным дням от даты последней загрузки до p_date_load - 1
  for rec in (select d_dateoperation + level as rep_date
                from dual
               where d_dateoperation + level < p_date_load
              connect by rownum < p_date_load - d_dateoperation
                order by 1) loop
      out_xml := null;
      out_result := null;          
      --выгружаем данные за один день, так как xml слишком большой иначе и ошибки возникают          
      pkg_rdwh_esb.p_send_fraud_1c(date_begin  => rec.rep_date,
                                   date_end    => rec.rep_date,
                                   out_xml    => out_xml,
                                   out_result => out_result,
                                   l_result_xml => l_result_xml);                     
   if out_result = 'OK' then
      --сохраняем полученный xml для истории
      s_object_name := 'T_RDWH_ESB_XML';
      insert into T_RDWH_ESB_XML(XML_TYPE,XML_BODY,DATE_PERIOD_BEGIN,DATE_PERIOD_END)
      values ('SEND_FRAUD_1C',l_result_xml, rec.rep_date, rec.rep_date);
      commit;
      n_rdwh_esb_xml_id := T_RDWH_ESB_XML_SEQ.currval;
      s_object_name := 'T_OUT_FRAUD_1C';
      --распарсиваем полученный xml и сохраняем данные в спец таблицу для отчета
      insert into T_OUT_FRAUD_1C(t_rdwh_esb_xml_id,dateoperation,sumoperation,office,uid_num,document,os,provision) 
      select t.id,to_date(x.DateOperation,'yyyy-mm-dd'), to_number(x.SumOperation), x.Office, x."UID", x.document, x.os, x.provision
        from T_RDWH_ESB_XML t,
              XMLTABLE ('/GetOS_DWHRResponse/return/RowDWHR'
                        PASSING t.xml_body
                        COLUMNS DateOperation VARCHAR2(30) PATH 'DateOperation', 
                                SumOperation VARCHAR2(30) PATH 'SumOperation',
                                Office VARCHAR2(2000) PATH 'Office',
                                "UID" VARCHAR2(2000) PATH 'UID',
                                Document VARCHAR2(2000) PATH 'Document',
                                OS VARCHAR2(2000) PATH 'OS',
                                Provision VARCHAR2(30) PATH 'Provision') x
      where t.id = n_rdwh_esb_xml_id; 
      commit;
  else 
      out_result := out_result||',dateoperation='||to_char(rec.rep_date,'dd-mm-yyyy');
      raise e_user_exception;    
  end if;  
  end loop;
  p_result := 1;
exception
  when e_user_exception then
    p_result := 0;
    log_error(in_operation     => 'p_get_fraud_1c',
              in_error_code    => sqlcode,
              in_error_message => 'Ошибка в pkg_rdwh_esb.p_send_fraud_1c '||out_result,
              in_object_type   => s_object_name,
              in_object_id     => null);
  when others then
    p_result := 0;
    log_error(in_operation     => 'p_get_fraud_1c',
              in_error_code    => sqlcode,
              in_error_message => substr(sqlerrm||' '||dbms_utility.format_error_backtrace,1,2000),
              in_object_type   => s_object_name,
              in_object_id     => null);
end P_GET_FRAUD_1C;
/

