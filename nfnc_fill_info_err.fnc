create or replace function u1.NFNC_Fill_Info_err(
                       p_errcode in number default null,
                       p_errmsg in varchar2 default null,
                       p_err_stack in varchar2 default null,
                       p_err_call_st in varchar2 default null,
                       p_err_backtr in varchar2 default null
                       ) return xmltype deterministic parallel_enable
 is
l_result xmltype;
begin
--RDWH2.0 парсер ошибок
  select XMLROOT(xmlelement("root",
                            xmlelement("action",
                                       case
                                         when p_errcode is not null then
                                          xmlelement("error",
                                                     xmlattributes(p_errcode as "sqlcode",
                                                                   p_errmsg as "sqlerrm"),
                                                     xmlelement("stacktrace", p_err_stack),
                                                     xmlelement("callstack", p_err_call_st),
                                                     xmlelement("backtrace", p_err_backtr))
                                       end)),
                 VERSION '1.0',
                 STANDALONE YES)
      into l_result
  from dual;
  return l_result;
end NFNC_Fill_Info_err;
/

