create or replace procedure u1.html_email_test2(
   p_mailserv varchar2,
   p_recipient_email varchar2,
 --  p_recipient_alias varchar2,
   p_subj varchar2,
   p_body varchar2
  ) is
    subj raw(2000) := utl_raw.cast_to_raw(convert('Subject: '||p_subj|| UTL_TCP.CRLF,'CL8MSWIN1251','UTF8'));
    bod raw(32000) := utl_raw.cast_to_raw(convert(p_body,'CL8MSWIN1251','UTF8'));
    c UTL_SMTP.CONNECTION;
    PROCEDURE send_header(name IN VARCHAR2, header IN VARCHAR2) AS
    BEGIN
      UTL_SMTP.WRITE_DATA(c, name || ': ' || header || UTL_TCP.CRLF);
    END;
  BEGIN
    c := UTL_SMTP.OPEN_CONNECTION(p_mailserv);
  --  UTL_SMTP.HELO(c, 'mail.mydomain.com');
    UTL_SMTP.MAIL(c, 'portal@mydomain.com');
    UTL_SMTP.RCPT(c, p_recipient_email);
    UTL_SMTP.OPEN_DATA(c);
    send_header('From','rdwh@kaspibank.kz');
    send_header('To',p_recipient_email);
    UTL_SMTP.write_raw_data(c,subj);
    send_header('Content-Type', 'text/html;charset=windows-1251');
    UTL_SMTP.write_raw_data(c, bod);
    UTL_SMTP.CLOSE_DATA(c);
    UTL_SMTP.QUIT(c);
  EXCEPTION
    WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
      BEGIN
        UTL_SMTP.QUIT(c);
      EXCEPTION
        WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR THEN
          NULL; 
      END;
      raise_application_error(-20000,
        'Failed to send mail due to the following error: ' || sqlerrm);
  END;
/

