create or replace procedure u1.check_tablespaces_size
as
v_mess varchar2(400);

begin

for i in (select /*+ noparallel */
                 tt.TABLESPACE_NAME,
                 trunc(tt.USED_PERCENT) as USED_PERCENT
            from dba_tablespace_usage_metrics tt
           where trunc(tt.USED_PERCENT) >= 93)

loop

v_mess := v_mess||chr(32)||rpad(i.tablespace_name,12,' ')||' '||i.used_percent||'%'||chr(10);

end loop;

if v_mess is not null
   then
     --dbms_output.put_line(1);
     v_mess := 'Высокий уровень заполнения следующих табличных провстранств:'||chr(10)||chr(10)||chr(32)||v_mess;
     pkg_mail.add_email(in_email_code => 'RDWH_CHECK',
                   in_email_body => v_mess,
                   in_email_subject => 'TABLESPACE WARNING');
end if;


end;
/

