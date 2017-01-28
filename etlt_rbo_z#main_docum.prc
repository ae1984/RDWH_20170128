create or replace procedure u1.ETLT_RBO_Z#MAIN_DOCUM is
   v_day          date; --последний рабочий день предыдущего месяца/день загрузки
   i number;
   num number;
   e_user_exception exception;
begin
   select max(c_date_doc) into v_day from u1.RBO_Z#MAIN_DOCUM;
   select trunc(sysdate) - v_day into num from dual;
   --
   for i in 1..num loop
     insert into u1.RBO_Z#MAIN_DOCUM (
         id, state_id, c_req_man#inn, c_document_date, c_sum_nt, c_quit_doc, c_sum, c_rate_dt,
         c_sum_po, c_rate_kt, c_vid_doc, c_valuta, c_valuta_po, c_acc_dt, c_acc_kt, c_date_doc)
     select md.id, md.state_id, md.c_req_man#inn, md.c_document_date, md.c_sum_nt, md.c_quit_doc, md.c_sum, md.c_rate_dt,
            md.c_sum_po, md.c_rate_kt, md.c_vid_doc, md.c_valuta, md.c_valuta_po, md.c_acc_dt, md.c_acc_kt, md.c_date_doc
     from V_RBO_Z#MAIN_DOCUM@RDWH11 md
     where md.c_date_doc = v_day + i;
     commit;
   end loop;
end ETLT_RBO_Z#MAIN_DOCUM;
/

