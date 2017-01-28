create or replace package u1.pkg_mail_html_tmp is

  -- Author  : chipizneko
  -- Created : 22.09.2015
  -- Purpose :
  /*Временный объект для теста отвравки HTML в письме. После переноса в пакет pkg_mail_html_tmp удалитьс*/

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
  
  /*Процедура отправки email-оповещения всем подписчикам в формате HTML*/
  procedure send_email_html(in_email_id number);
  
  /*
  Добавление письма в очередь на отправку.
  */
  procedure add_email(in_email_code varchar2,                      -- Код группы
                      in_email_body clob,                          -- Тело письма
                      in_email_subject varchar2 default null,      -- Тема письма
                      in_attach_dir varchar2 default null,         -- Oracle директория для файлов
                      in_attach_file varchar2 default null,        -- Имя файла относительно директории in_attach_dir
                      in_with_attach number := 0,                  -- Признак письма с аттачем
                      in_html_body number default 0
                      );
                      
  
  
end pkg_mail_HTML_TMP;
/

create or replace package body u1.pkg_mail_html_tmp is
  SEND_SQL constant varchar2(2048) :=
'
begin
  pkg_mail_html_tmp.send_email(:rec_id);

exception when others then
  log_error(in_operation     => ''pkg_mail.send_email thread'',
            in_error_code    => sqlcode,
            in_error_message => ''rec_id =  '' || :rec_error_id || '', '' ||
                                sqlerrm);
end;
';

  SEND_SQL_HTML constant varchar2(2048) :=
'
begin
  pkg_mail_html_tmp.send_email_html(:rec_id);

exception when others then
  log_error(in_operation     => ''pkg_mail.send_email thread'',
            in_error_code    => sqlcode,
            in_error_message => ''rec_id =  '' || :rec_error_id || '', '' ||
                                sqlerrm);
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
    for r in (select * from email_log_tst t
              where t.send_status = 0
              order by t.date_start)
    loop
      begin
        v_cursor := dbms_sql.open_cursor;
        
        if r.is_html = 1 
          then dbms_sql.parse(v_cursor, SEND_SQL_HTML, dbms_sql.native);
          else dbms_sql.parse(v_cursor, SEND_SQL, dbms_sql.native);
        end if;
        
        dbms_sql.bind_variable(v_cursor, 'rec_id', r.id);
        dbms_sql.bind_variable(v_cursor, 'rec_error_id', r.id);

        v_execute_result := dbms_sql.execute(v_cursor);

        dbms_sql.close_cursor(v_cursor);

      exception
        when others then
          if (dbms_sql.is_open(c => v_cursor)) then
            dbms_sql.close_cursor(v_cursor);
          end if;

          log_error(
            in_operation => 'pkg_mail_html_tmp.send_email, rec_id = ' || r.id,
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

    select substr(t.email_subject||' '||v_email_log.subject,1,128)
      into v_subject
      from email_code t
     where t.code = v_email_log.email_code;



    begin
      v_conn := utl_smtp.open_connection(v_server, v_port);
      utl_smtp.Helo(v_conn, v_server);
      utl_smtp.Mail(v_conn, v_from);
      --utl_smtp.Rcpt(v_conn, v_recipient);

      v_message := 'Date: '   || to_char(systimestamp, 'dd-mm-yyyy hh24:mi:ss.ff') || v_crlf ||
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
                                           'R');
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

  procedure send_email_html(in_email_id number)
  is
  v_email_log EMAIL_LOG_TST%ROWTYPE;
  
  v_server    VARCHAR2(30);
  v_from      VARCHAR2(128);
  v_recipient VARCHAR2(128);
  v_subject   VARCHAR2(128);
  v_indx      NUMBER := 0;
  p_recipient_email VARCHAR2(1000);
  
  subj raw(2000);
  bod raw(32000);
  c UTL_SMTP.CONNECTION;
  
  v_error varchar2(2048);
  
  
  PROCEDURE send_header(name IN VARCHAR2, header IN VARCHAR2) AS
    BEGIN
      UTL_SMTP.WRITE_DATA(c, name || ': ' || header || UTL_TCP.CRLF);
    END;
  begin
    
    --инфо по письму
    select * into v_email_log
    from EMAIL_LOG_TST t
    where t.id = in_email_id;
    
    --сервер
    select t.value_str into v_server
    from s_email_param t
    where t.id = CONST_1;
    
    --от кого
    select t.value_str into v_from
    from s_email_param t
    where t.id = CONST_3;
    
    --тема
    select substr(t.email_subject||' '||v_email_log.subject,1,128) 
      into v_subject
      from email_code t
     where t.code = v_email_log.email_code;
     
    --получатели 
    /*for r in (select * from email_recipient t
                where t.email_code = v_email_log.email_code
                and t.is_active = CONST_1)
      loop
        
        p_recipient_email:= r.email_box||';'
        
      end loop;*/
    
    --перобразование темы и тела письма
    subj := utl_raw.cast_to_raw(convert('Subject: '||v_subject|| UTL_TCP.CRLF,'UTF8'));
    bod := utl_raw.cast_to_raw(convert(v_email_log.email_body,'UTF8'));
   
    --заполнение данными
    c := UTL_SMTP.OPEN_CONNECTION(v_server);
    UTL_SMTP.MAIL(c, v_from);
    
    --TEST
    --UTL_SMTP.RCPT(c, p_recipient_email);
    UTL_SMTP.RCPT(c,'denis.chipizhenko@kaspibank.kz');
    
    UTL_SMTP.OPEN_DATA(c);
    send_header('From',v_from);
    
    --TEST
    --send_header('To',p_recipient_email);
    send_header('To','denis.chipizhenko@kaspibank.kz');
    
    UTL_SMTP.write_raw_data(c,subj);
    send_header('Content-Type', 'text/html;charset="utf-8"');
    UTL_SMTP.write_raw_data(c, bod);
    UTL_SMTP.CLOSE_DATA(c);
    UTL_SMTP.QUIT(c);

  update email_log_tst t
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
  
  procedure add_email(in_email_code varchar2,
                      in_email_body clob,
                      in_email_subject varchar2 default null,
                      in_attach_dir varchar2 default null,
                      in_attach_file varchar2 default null,
                      in_with_attach number := 0,
                      in_html_body number default 0
                      )
  is
    pragma autonomous_transaction;
  begin
    begin
      insert into email_log_tst (email_code, date_start, send_status, email_body,subject, 
                             attach_dir, attach_file, with_attach, is_html)
      values (in_email_code, systimestamp, CONST_0, in_email_body,in_email_subject, 
              in_attach_dir, in_attach_file, in_with_attach, in_html_body);
      commit;

    exception when others then
      rollback;

      log_error(
            in_operation => 'pkg_mail_html_tmp.add_email',
            in_error_code => sqlcode,
            in_error_message => sqlerrm);
    end;
  end;



end pkg_mail_HTML_TMP;
/

