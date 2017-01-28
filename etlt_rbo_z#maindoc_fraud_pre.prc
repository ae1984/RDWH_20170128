create or replace procedure u1.ETLT_RBO_Z#MAINDOC_FRAUD_PRE is
  n_max_id_doc_fraud number;
begin
   select nvl(max(id),0)
     into n_max_id_doc_fraud
     from T_RBO_Z#MAIN_DOCUM_FRAUD_PRE;
   --
   for rec in (select f.rbo_ac_fin_id from M_ACC_FRAUD_OPER f) loop
       insert into T_RBO_Z#MAIN_DOCUM_FRAUD_PRE
       select md.*
         from V_RBO_Z#MAIN_DOCUM_PRE@rdwh11 md
        where md.c_acc_dt = rec.rbo_ac_fin_id
          and md.id > n_max_id_doc_fraud
          and not exists
             (select 1 from T_RBO_Z#MAIN_DOCUM_FRAUD_PRE where id = md.id);
       insert into T_RBO_Z#MAIN_DOCUM_FRAUD_PRE
       select md.*
         from V_RBO_Z#MAIN_DOCUM_PRE@rdwh11 md
        where md.c_acc_kt = rec.rbo_ac_fin_id
          and md.id > n_max_id_doc_fraud
          and not exists
             (select 1 from T_RBO_Z#MAIN_DOCUM_FRAUD_PRE where id = md.id);
       commit;
   end loop;
  
end ETLT_RBO_Z#MAINDOC_FRAUD_PRE;
/

