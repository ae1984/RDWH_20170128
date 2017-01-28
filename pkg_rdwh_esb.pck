CREATE OR REPLACE PACKAGE U1.PKG_RDWH_ESB as

  -- Author  : MALAYEVA_26016
  -- Created : 03.02.2016 19:04:19
  -- Purpose :
  -- пакет для запроса данных через SOAP

  procedure p_send_fraud_1c(date_begin  in date,
                            date_end    in date,
                            out_xml    out clob,
                            out_result out varchar2,
                            l_result_xml out xmltype);

end PKG_RDWH_ESB;
/

create or replace package body u1.PKG_RDWH_ESB is

  -- Author  : MALAYEVA_26016
  -- Created : 03.02.2016 19:04:19
  -- Purpose :
  -- пакет для запроса данных через SOAP

  procedure p_send_fraud_1c(date_begin  in date,
                            date_end    in date,
                            out_xml    out clob,
                            out_result out varchar2,
                            l_result_xml out xmltype)
  as
  v_new_request_ex exception;
  v_invoke_ex exception;

  l_request   soap_api.t_request;
  l_response  soap_api.t_response;

  l_url          VARCHAR2(128);
  l_namespace    VARCHAR2(128);
  l_method       VARCHAR2(128);
  l_envelope_tag varchar2(128);
  l_soap_action  VARCHAR2(128);
  l_result_name  VARCHAR2(128);
  l_result_error_name  VARCHAR2(128);
  l_result_error_name2  VARCHAR2(128);

 -- l_result_xml xmltype;

  l_result_count number;
  l_result_error_count number;
  l_result_error2_count number;

  v_timeout number;


begin

/*  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:os="http://1c-web/os">
   <soapenv:Header/>
   <soapenv:Body>
      <os:GetOS_DWHR>
         <os:DateBegin>2015-09-01</os:DateBegin>
         <os:DateEnd>2015-11-30</os:DateEnd>
      </os:GetOS_DWHR>
   </soapenv:Body>
</soapenv:Envelope> */

--http://1c-web.hq.bc/os_test/ws/ws1.1cws
--  l_url         := 'http://1c-web.hq.bc/os_test/ws/ws1.1cws';
  l_url         := 'http://1c-web.hq.bc/os_ws/ws/ws1.1cws';
  l_namespace   := 'xmlns:os="http://1c-web/os"';
  l_method      := 'os:GetOS_DWHR';
  l_envelope_tag := 'soapenv';
  l_soap_action := 'http://1c-web/os#IBSO:GetOS_DWHR';
  --l_soap_action := 'http://1c-web/os#IBSO:GetOS_DWHR';
  l_result_name := 'GetOS_DWHRResponse';
--  l_result_error_name := 'internalException';
--  l_result_error_name2 := 'serviceException';

  begin
    l_request := soap_api.new_request(p_method       => l_method,
                                      p_namespace    => l_namespace,
                                      p_envelope_tag => l_envelope_tag);
  exception when others then
    log_error(in_operation => 'RDWH_ESB.p_send_fraud_1c soap_api',
              in_error_code => sqlcode,
              in_error_message => substr(sqlerrm||' '||dbms_utility.format_error_backtrace,1,2000));
    raise v_new_request_ex;
  end;

  soap_api.add_parameter(p_request => l_request,
                         p_name    => 'os:DateBegin',
                         p_value   => to_char(date_begin,'yyyy-mm-dd'));

  soap_api.add_parameter(p_request => l_request,
                         p_name    => 'os:DateEnd',
                         p_value   => to_char(date_end,'yyyy-mm-dd'));

  begin
    l_response := soap_api.invoke(p_request => l_request,
                                  p_url     => l_url,
                                  p_action  => l_soap_action);
  exception when others then
    log_error(in_operation => 'RDWH_ESB.p_send_fraud_1c soap_api',
              in_error_code => sqlcode,
              in_error_message => substr(sqlerrm||' '||dbms_utility.format_error_backtrace,1,2000));
    raise v_invoke_ex;
  end;

  out_xml := l_response.doc.getCLOBVal();
  --dbms_output.put_line(' out_xml='||length(out_xml));
  out_xml := replace(out_xml, 'xmlns:m="http://1c-web/os"');
  out_xml := replace(out_xml, 'm:');
  out_xml := replace(out_xml, 'xmlns="http://1c-web/os/dwhr"');
  
  --dbms_output.put_line(' out_xml='||length(out_xml));
  
  --soap_api.debug_on;
--  soap_api.show_envelope(p_env => out_xml,p_heading => 'last');
  
  l_result_xml := xmltype.createxml(out_xml);

  out_result := 'OK';
  
--  select EXTRACT(l_result_xml, '/' || l_result_name || '/return/text()').getStringVal() into  out_result from dual;
  
--  dbms_output.put_line(' out_result='||length( out_result));
  
--  insert into T_RDWH_ESB_XML(XML_TYPE,XML_BODY,DATE_PERIOD_BEGIN,DATE_PERIOD_END)
--  values ('SEND_FRAUD_1C',l_result_xml,date_begin, date_end);
--  commit;


  --select instr(out_xml, l_result_name) into l_result_count from dual;
  --dbms_output.put_line('l_result_count='||l_result_count);
 -- select EXTRACT(l_result_xml, '/' || l_result_name || '/return/text()').getStringVal() into  out_result from dual;
 --   select EXTRACT(l_result_xml, '/' || l_result_name || '/recordId/text()').getStringVal() into  out_record_id from dual;
 -- if l_result_count > 0 then
  --end if;
/*  log_error(in_operation => 'RDWH_ESB.p_send_fraud_1c',
                in_error_code => out_result,
                in_error_message => substr(out_xml,1,2000));*/
 -- dbms_output.put_line(out_result);
 -- dbms_output.put_line(out_xml);
/*  out_xml := l_response.doc.getStringVal();
  out_xml := replace(out_xml, 'xmlns="http://esb.kaspibank.kz/middleOffice"');
  l_result_xml := xmltype.createxml(out_xml);

  select instr(out_xml, l_result_name) into l_result_count from dual;
  select instr(out_xml, l_result_error_name) into l_result_error_count from dual;
  select instr(out_xml, l_result_error_name2) into l_result_error2_count from dual;

  if (l_result_count > 0) then
    select EXTRACT(l_result_xml, '/' || l_result_name || '/result/text()').getStringVal() into  out_result from dual;
    select EXTRACT(l_result_xml, '/' || l_result_name || '/recordId/text()').getStringVal() into  out_record_id from dual;
  elsif (l_result_error_count > 0) then
    select EXTRACT(l_result_xml, '/' || l_result_error_name || '/source/text()').getStringVal() into  out_result from dual;
    select EXTRACT(l_result_xml, '/' || l_result_error_name || '/message/text()').getStringVal() into  out_record_id from dual;
  elsif (l_result_error2_count > 0) then
    select EXTRACT(l_result_xml, '/' || l_result_error_name2 || '/source/text()').getStringVal() into  out_result from dual;
    select EXTRACT(l_result_xml, '/' || l_result_error_name2 || '/message/text()').getStringVal() into  out_record_id from dual;
  end if;*/
exception
  when v_invoke_ex then
    out_result := 'ERROR2';
  when v_new_request_ex then
    out_result := 'ERROR1';
  when others then
    out_result := 'ERROR';
    log_error(in_operation => 'RDWH_ESB.p_send_fraud_1c',
                in_error_code => sqlcode,
                in_error_message => substr(sqlerrm||' '||dbms_utility.format_error_backtrace,1,2000));
end;

end PKG_RDWH_ESB;
/

