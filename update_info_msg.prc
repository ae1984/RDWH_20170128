create or replace procedure u1.UPDATE_INFO_MSG
as 
begin
pkg_mail.add_email(in_email_code =>'TEST1' /*'RDWH_DAILY_ERR'*/,
       --'TEST',
 in_email_body => 'тест',
 in_email_subject => 'тест');
end UPDATE_INFO_MSG ;
/

