create or replace procedure u1.ETLT_RBO_Z#MAIN_DOCUM_FRAUD is
  n_max_id_doc_fraud number;
begin
            for rec in (select id, c_quit_doc from T_RBO_Z#MAIN_DOCUM_FRAUD_PRE t) loop  
            insert into T_RBO_Z#MAIN_DOCUM_FRAUD
            select *
              from V_RBO_Z#MAIN_DOCUM_PRE@rdwh11 md
             where c_quit_doc = rec.id
               and not exists
                   (select 1 from T_RBO_Z#MAIN_DOCUM_FRAUD where id = md.id)
            union
            select *
              from V_RBO_Z#MAIN_DOCUM_PRE@rdwh11 md
             where id = nvl(rec.c_quit_doc,0) 
               and not exists
                   (select 1 from T_RBO_Z#MAIN_DOCUM_FRAUD where id = md.id)
            union 
            select *
              from V_RBO_Z#MAIN_DOCUM_PRE@rdwh11 md
             where id = rec.id
               and not exists
                   (select 1 from T_RBO_Z#MAIN_DOCUM_FRAUD where id = md.id);
            commit;
            end loop;
            ----вставка данные по операциям 1860 вандализм
            select nvl(max(id),0)
              into n_max_id_doc_fraud
              from T_RBO_Z#MAIN_DOCUM_FRAUD
             where c_acc_dt in (select af.id
                                  from T_RBO_Z#AC_FIN af
                                  join V_RBO_Z#PL_USV pu on pu.id = af.c_main_usv
                                 where substr(pu.c_num,1,4) = '1860' 
                                   and upper(af.c_name) like '%ВАНД%' 
                                   and af.c_acc_summary is not null)
                or c_acc_kt in (select af.id
                                  from T_RBO_Z#AC_FIN af
                                  join V_RBO_Z#PL_USV pu on pu.id = af.c_main_usv
                                 where substr(pu.c_num,1,4) = '1860' 
                                   and upper(af.c_name) like '%ВАНД%' 
                                   and af.c_acc_summary is not null);
             for rec in (select af.id
                           from T_RBO_Z#AC_FIN af
                           join V_RBO_Z#PL_USV pu on pu.id = af.c_main_usv
                          where substr(pu.c_num,1,4) = '1860' 
                            and upper(af.c_name) like '%ВАНД%' 
                            and af.c_acc_summary is not null) loop  
              insert into T_RBO_Z#MAIN_DOCUM_FRAUD
              select id,
                     state_id,
                     c_document_date,
                     c_sum_nt,
                     c_quit_doc,
                     c_sum,
                     c_rate_dt,
                     c_sum_po,
                     c_rate_kt,
                     c_vid_doc,
                     c_valuta,
                     c_valuta_po,
                     c_acc_dt,
                     c_acc_kt,
                     c_date_doc,
                     c_date_prov,
                     c_document_user,
                     c_nazn,
                     c_prov_user 
                from s02.z#main_docum@rdwh_exd
               where c_acc_dt = rec.id
                 and id > n_max_id_doc_fraud;  
              commit;      
              insert into T_RBO_Z#MAIN_DOCUM_FRAUD
              select id,
                     state_id,
                     c_document_date,
                     c_sum_nt,
                     c_quit_doc,
                     c_sum,
                     c_rate_dt,
                     c_sum_po,
                     c_rate_kt,
                     c_vid_doc,
                     c_valuta,
                     c_valuta_po,
                     c_acc_dt,
                     c_acc_kt,
                     c_date_doc,
                     c_date_prov,
                     c_document_user,
                     c_nazn,
                     c_prov_user 
                from s02.z#main_docum@rdwh_exd
               where c_acc_kt = rec.id
                 and id > n_max_id_doc_fraud;  
             commit; 
            end loop;
  
end ETLT_RBO_Z#MAIN_DOCUM_FRAUD;
/

