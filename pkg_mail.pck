create or replace package u1.pkg_mail is

  -- Author  : KIM_17004
  -- Created : 06.02.2014 10:04:35
  -- Purpose :

  /*
  Процедура запуска отправки email-оповещений.

  Данная процедура вызывается job_email_send, каждые 5 сек.
  Логика:
  Выбираются все неотправленные записи из email_log и передавая id записи вызывается send_email(in_email_id)
  */
  procedure send_email;

  /*
  Процедура отправки email-оповещения всем подписчикам.

  Логика:
  по входному id и запросам в таблицы email_recipient, email_code, формируется письмо
  и отправляется всем подписчикам.
  */
  procedure send_email(in_email_id number);
  
  procedure send_email_html(in_email_id number);

  /*
  Добавление письма в очередь на отправку.
  */
  procedure add_email(in_email_code varchar2,                      -- Код группы
                      in_email_body clob,                          -- Тело письма
                      in_email_subject varchar2 default null,      -- Тема письма
                      in_attach_dir varchar2 default null,         -- Oracle директория для файлов
                      in_attach_file varchar2 default null,        -- Имя файла относительно директории in_attach_dir
                      in_with_attach number default 0,             -- Признак письма с аттачем
                      in_with_html   number default 0              -- признак что текст писчьма в виде html
                      );
end pkg_mail;
/

create or replace package body u1.pkg_mail is
  SEND_SQL constant varchar2(2048) :=
'
begin
  if :rec_with_html = 1 then
     pkg_mail.send_email_html(:rec_id);
  else  
     pkg_mail.send_email(:rec_id);
  end if;   

exception when others then
  log_error(in_operation     => ''pkg_mail.send_email thread'',
            in_error_code    => sqlcode,
            in_error_message => substr(''rec_id =  '' || :rec_error_id || '', '' ||
                                sqlerrm||'' ''||dbms_utility.format_error_backtrace,1,2000));
end;
';

  CONST_0 constant number := 0;
  CONST_1 constant number := 1;
  CONST_2 constant number := 2;
  CONST_3 constant number := 3;
  CONST_4 constant number := 4;
  CONST_5 constant number := 5;
  CONST_6 constant number := 6;
  CONST_7 constant number := 7;
  CONST_8 constant number := 8;
  CONST_9 constant number := 9;
  CONST_10 constant number := 10;

  procedure send_email
  is
    v_cursor integer;
    v_execute_result integer;

  begin
    for r in (select * from email_log t
              where t.send_status = 0
              order by t.date_start)
    loop
      begin
        v_cursor := dbms_sql.open_cursor;

        dbms_sql.parse(v_cursor, SEND_SQL, dbms_sql.native);
        dbms_sql.bind_variable(v_cursor, 'rec_id', r.id);
        dbms_sql.bind_variable(v_cursor, 'rec_error_id', r.id);
        dbms_sql.bind_variable(v_cursor, 'rec_with_html', r.with_html);

        v_execute_result := dbms_sql.execute(v_cursor);

        dbms_sql.close_cursor(v_cursor);

      exception
        when others then
          if (dbms_sql.is_open(c => v_cursor)) then
            dbms_sql.close_cursor(v_cursor);
          end if;

          log_error(
            in_operation => 'pkg_mail.send_email, rec_id = ' || r.id,
            in_error_code => sqlcode,
            in_error_message => sqlerrm);
      end;
    end loop;
  end;


  procedure send_email(in_email_id number)
  is
    v_email_log EMAIL_LOG%ROWTYPE;

    v_from      VARCHAR2(128);
    v_recipient varchar2(128);
    v_subject   VARCHAR2(128);
    v_server    VARCHAR2(30);
    v_port number;
    v_conn      utl_smtp.Connection;
    v_crlf      VARCHAR2(2) := chr(13)||chr(10);

    v_message clob;

    v_indx number := 0;

    v_error varchar2(2048);


    v_handle_read UTL_FILE.FILE_TYPE;
    v_new_line clob;
    v_file_clob clob;
    v_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
    v_step        PLS_INTEGER  := 30000;

    l_len number;
    l_idx integer;
    l_buff_size number;
    l_raw       varchar2(32000);

  begin
    insert into T_TST_EMAIL
    values(in_email_id, sysdate, 1);
    commit;
    
    select * into v_email_log
    from email_log t
    where t.id = in_email_id;

    select t.value_str into v_server
    from s_email_param t
    where t.id = CONST_1;

    select t.value_num into v_port
    from s_email_param t
    where t.id = CONST_2;

    select t.value_str into v_from
    from s_email_param t
    where t.id = CONST_3;

/*    select t.email_box into v_recipient
    from email_recipient t
    where t.email_code = v_email_log.email_code
    and t.is_default = CONST_1;*/

    select 
         case 
          when coalesce(t.email_subject,'0') != coalesce(v_email_log.subject,'1') then substr(t.email_subject||' '||v_email_log.subject,1,128)
          else  substr(coalesce(v_email_log.subject,t.email_subject),1,128) end
      into v_subject
      from email_code t
     where t.code = v_email_log.email_code;


    begin
      v_conn := utl_smtp.open_connection(v_server, v_port);
      utl_smtp.Helo(v_conn, v_server);
      utl_smtp.Mail(v_conn, v_from);
      --utl_smtp.Rcpt(v_conn, v_recipient);

      v_message := --'Date: '   || to_char(systimestamp, 'dd/mm/yyyy hh24:mi:ss ') || v_crlf ||
                   'From: '   || v_from || v_crlf ||
                   'Subject: '|| v_subject || v_crlf;

      v_message := v_message || 'To: ';

      v_indx := 0;
      for r in (select * from email_recipient t
                where t.email_code = v_email_log.email_code
                and t.is_active = CONST_1)
      loop
        utl_smtp.Rcpt(v_conn, r.email_box);

        if (v_indx > 0) then
          v_message := v_message || ';';
        end if;

        v_message := v_message || r.email_box;

        v_indx := v_indx + 1;
      end loop;

      v_message := v_message || v_crlf;

      v_message := v_message ||  'MIME-Version: 1.0' || UTL_TCP.crlf;
      v_message := v_message ||  'Content-Type: multipart/mixed; boundary="' || v_boundary || '"'  || UTL_TCP.crlf || UTL_TCP.crlf;
      v_message := v_message ||  '--' || v_boundary || UTL_TCP.crlf;
      v_message := v_message ||  'Content-Type: text/plain; charset="utf-8"' ||  UTL_TCP.crlf || UTL_TCP.crlf;

      v_message := v_message || v_crlf || v_crlf;

      v_message := v_message || v_email_log.email_body || v_crlf;

      --add attach
      if v_email_log.with_attach = 1 then
         --dump file
         begin
           v_handle_read := utl_file.fopen(v_email_log.attach_dir,
                                           v_email_log.attach_file,
                                           'R',32767);
           loop
             begin
               utl_file.get_line(v_handle_read, v_new_line);
             exception when no_data_found then
               exit;
             end;

             v_file_clob := v_file_clob || chr(10) || v_new_line;
            end loop;

            utl_file.fclose(v_handle_read);

         exception
            when NO_DATA_FOUND then
                utl_file.fclose(v_handle_read);
                log_error(in_operation => 'File dump - NO_DATA_FOUND',
                          in_error_code => sqlcode,
                          in_error_message => sqlerrm);
            when others then
                log_error(in_operation => 'File dump - error',
                          in_error_code => sqlcode,
                          in_error_message => sqlerrm);

          end;

          --v_attach_file_name := substr(v_email_log.attach_file, instr(v_email_log.attach_file, ''));
          --add attach
          v_message := v_message ||  '--' || v_boundary || UTL_TCP.crlf;
          v_message := v_message ||  'Content-Type: ' || 'text/plain' || '; charset="utf-8"; name="' ||  v_email_log.attach_file || '"' || UTL_TCP.crlf;
          v_message := v_message ||  'Content-Disposition: attachment; filename="' || v_email_log.attach_file || '"' || UTL_TCP.crlf;

          --v_message := v_message || convert(l_clob, 'AL32UTF8');
          v_message := v_message || v_file_clob;

         -- v_message := v_message ||  UTL_TCP.crlf || UTL_TCP.crlf;
          --

         -- v_message := v_message ||  '--' || v_boundary || '--' || UTL_TCP.crlf;
      end if;


      utl_smtp.open_data(c => v_conn);
      --определяем длину всего сообщения
      l_len := dbms_lob.getlength(v_message);
      l_idx := 1;
      l_buff_size := 10000;
      --цикл необходим, так как сообщение может быть длинне 32000(когда содержит файлы особенно)
      while l_idx < l_len loop
       dbms_lob.read(lob_loc => v_message, amount => l_buff_size, offset => l_idx, buffer => l_raw);
       utl_smtp.write_raw_data(c => v_conn, data => utl_raw.cast_to_raw(l_raw));
       l_raw := null;
       l_idx := l_idx + l_buff_size;
      end loop;

      if v_email_log.with_attach = 1 then
      utl_smtp.write_data(c => v_conn,data => UTL_TCP.crlf);
      utl_smtp.write_data(c => v_conn,data => UTL_TCP.crlf);
      utl_smtp.write_data(c => v_conn,data => '--' || v_boundary || '--' || UTL_TCP.crlf);
      end if;

      utl_smtp.close_data(c => v_conn);
      utl_smtp.quit(v_conn);

      update email_log t
      set t.date_end = systimestamp,
          t.send_status = CONST_1
      where t.id = in_email_id;
      commit;

    exception
      when utl_smtp.Transient_Error or utl_smtp.Permanent_Error then
        v_error := sqlerrm;

        update email_log t
        set t.date_end = systimestamp,
            t.send_status = CONST_2,
            t.send_error_msg = v_error
        where t.id = in_email_id;
        commit;

        log_error(
            in_operation => 'Unable to send mail',
            in_error_code => sqlcode,
            in_error_message => sqlerrm);

      when others then
        v_error := sqlerrm;

        update email_log t
        set t.date_end = systimestamp,
            t.send_status = CONST_2,
            t.send_error_msg = v_error
        where t.id = in_email_id;
        commit;

        log_error(
            in_operation => 'Error send mail',
            in_error_code => sqlcode,
            in_error_message => substr(dbms_utility.format_error_backtrace||' '||sqlerrm,1,2000));
    end;
  end;
  
  --отправка пиьсма в виде html
  procedure send_email_html(in_email_id number)
  is
    v_email_log EMAIL_LOG%ROWTYPE;

    v_from      VARCHAR2(128);
    v_recipient varchar2(2000);
    v_subject   VARCHAR2(128);
    v_server    VARCHAR2(30);
    v_port number;
    
    v_error varchar2(2048);
    l_mail_conn      utl_smtp.Connection;
    v_crlf      VARCHAR2(2) := chr(13)||chr(10);
    v_indx number := 0;

    i     NUMBER(12);
    len   NUMBER (12);
    part  NUMBER(12) := 16384;
    
    -- разметка таблички в теле письма
    l_stylesheet CLOB := '
       <html><head>
       <style type="text/css">
                   body     { font-family     : Verdana, Arial;
                              font-size       : 10pt;}
 
                   .green   { color           : #00AA00;
                              font-weight     : bold;}
 
                   .red     { color           : #FF0000;
                              font-weight     : bold;}
 
                   pre      { margin-left     : 10px;}
 
                   table    { empty-cells     : show;
                              border-collapse : collapse;
                              width           : 75%;
                              border          : solid 2px #444444;}
 
                   td       { border          : solid 1px #444444;
                              font-size       : 8pt;
                              padding         : 2px;}
 
                   th       { background      : #EEEEEE;
                              border          : solid 1px #444444;
                              font-size       : 12pt;
                              padding         : 2px;}
 
                   dt       { font-weight     : bold; }
 
                  </style>
                 </head>
                 <body>';
                 
       
    /*v_message clob;

    

    


    v_handle_read UTL_FILE.FILE_TYPE;
    v_new_line clob;
    v_file_clob clob;
    v_boundary    VARCHAR2(50) := '----=*#abc1234321cba#*=';
    v_step        PLS_INTEGER  := 30000;

    l_len number;
    l_idx integer;
    l_buff_size number;
    l_raw       varchar2(32000);*/

  begin
    insert into T_TST_EMAIL
    values(in_email_id, sysdate, 2);
    commit;
    select * into v_email_log
    from email_log t
    where t.id = in_email_id;

    select t.value_str into v_server
    from s_email_param t
    where t.id = CONST_1;

    select t.value_num into v_port
    from s_email_param t
    where t.id = CONST_2;

    select t.value_str into v_from
    from s_email_param t
    where t.id = CONST_3;

    select 
         case 
          when coalesce(t.email_subject,'0') != coalesce(v_email_log.subject,'1') then substr(t.email_subject||' '||v_email_log.subject,1,128)
          else  substr(coalesce(v_email_log.subject,t.email_subject),1,128) end
      into v_subject
      from email_code t
     where t.code = v_email_log.email_code;
    
    l_mail_conn := utl_smtp.open_connection(v_server, v_port);
    utl_smtp.helo(l_mail_conn, v_server);
    utl_smtp.mail(l_mail_conn, v_from);
    
    --адресаты
   
    v_indx := 0;
    
      for r in (select email_box 
                  from email_recipient t
                 where t.email_code = v_email_log.email_code
                   and t.is_active = 1)
      loop
        utl_smtp.Rcpt(l_mail_conn, r.email_box);

        if (v_indx > 0) then
          v_recipient := v_recipient || ';';
        end if;

        v_recipient := v_recipient || r.email_box;

        v_indx := v_indx + 1;
      end loop;
      
 
    utl_smtp.open_data(l_mail_conn);
    utl_smtp.write_data(l_mail_conn,
     'MIME-version: 1.0' || v_crlf ||
     'Content-Type: text/html; charset="utf-8"' || v_crlf ||
     'Content-Transfer-Encoding: 8bit' || v_crlf ||
     'Date: '   || to_char(sysdate, 'Dy, DD Mon YYYY hh24:mi:ss') || v_crlf ||
     'From: '   || v_from || v_crlf ||
     'Subject: ' || F_SUBJECT_ENCODE(NVL(v_subject, '(no subject)')) || v_crlf ||
     'To: '     || v_recipient || v_crlf);
     
    utl_smtp.write_raw_data(l_mail_conn, utl_raw.cast_to_raw(l_stylesheet));
 
    i   := 1;
    len := DBMS_LOB.getLength(v_email_log.email_body);
    WHILE (i < len) LOOP
        utl_smtp.write_raw_data(l_mail_conn, utl_raw.cast_to_raw(DBMS_LOB.SubStr(v_email_log.email_body,part, i)));
        i := i + part;
    END LOOP;
    
    utl_smtp.write_raw_data(l_mail_conn, utl_raw.cast_to_raw('</body></html>'));

  -- прикроем соединение
    utl_smtp.close_data(l_mail_conn );
    utl_smtp.quit(l_mail_conn);

    begin
      
    ------------

      update email_log t
      set t.date_end = systimestamp,
          t.send_status = CONST_1
      where t.id = in_email_id;
      commit;

    exception
      when utl_smtp.Transient_Error or utl_smtp.Permanent_Error then
        v_error := sqlerrm;

        update email_log t
        set t.date_end = systimestamp,
            t.send_status = CONST_2,
            t.send_error_msg = v_error
        where t.id = in_email_id;
        commit;

        log_error(
            in_operation => 'Unable to send mail',
            in_error_code => sqlcode,
            in_error_message => sqlerrm);

      when others then
        v_error := sqlerrm;

        update email_log t
        set t.date_end = systimestamp,
            t.send_status = CONST_2,
            t.send_error_msg = v_error
        where t.id = in_email_id;
        commit;

        log_error(
            in_operation => 'Error send mail',
            in_error_code => sqlcode,
            in_error_message => substr(dbms_utility.format_error_backtrace||' '||sqlerrm,1,2000));
    end;
  end;

  procedure add_email(in_email_code varchar2,
                      in_email_body clob,
                      in_email_subject varchar2 default null,
                      in_attach_dir varchar2 default null,
                      in_attach_file varchar2 default null,
                      in_with_attach number default 0,
                      in_with_html   number default 0 
                      )
  is
    pragma autonomous_transaction;
  begin
    begin
      insert into email_log (email_code, date_start, send_status, email_body,subject,
                             attach_dir, attach_file, with_attach, with_html)
      values (in_email_code, systimestamp, CONST_0, in_email_body,in_email_subject,
              in_attach_dir, in_attach_file, in_with_attach, in_with_html);
      commit;

    exception when others then
      rollback;

      log_error(
            in_operation => 'pkg_mail.add_email',
            in_error_code => sqlcode,
            in_error_message => sqlerrm);
    end;
  end;



end pkg_mail;
/

