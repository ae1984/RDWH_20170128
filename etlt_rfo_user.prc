create or replace procedure u1.ETLT_RFO_USER is
   s_mview_name     varchar2(30) := 'T_RFO_Z#USER';
   vStrDate         date := sysdate;
   d_date_start_ins date; --дата логирования инсерта

   d_src_commit_date_last date; --дата последней загруженной строки
   d_src_commit_date_load date; --дата, по которую делаем загрузку

  begin
    --дата необходима для логирования времени инсерта
    d_date_start_ins := sysdate;
    select max(src_commit_date)-5/24/60/60
      into d_src_commit_date_load
      from s01.s$Z#USER@rdwh_exd;
    select last_date
      into d_src_commit_date_last
      from t_rdwh_increment_tables_load
     where object_name = 'T_RFO_Z#USER';
    --
    delete from T_RFO_Z#USER
     where id in (select distinct id
                    from s01.s$Z#USER@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    insert into T_RFO_Z#USER
    select id,
           c_username,
           translate(upper(c_name),
                   chr(53388)||chr(53384)||chr(53383)||chr(53904)||
                   chr(53390)||chr(53380)||chr(53381),
                   chr(53914)||chr(54168)||chr(53934)||chr(54184)||
                   chr(53936)||chr(53906)||chr(53922)) as
           c_name,
           c_email,
           c_empl,
           c_user_back,
           c_id_depart,
           c_casta,
           c_name_depart,
           c_depart,
           c_by_right,
           c_c#parameters,
           c_st_depart,
           c_warrant,
           c_warrant_date,
           c_plan,
           c_kas_journal,
           c_kas_prop,
           c_num_tab,
           c_kas_date_inhand,
           c_kas_date_order,
           c_kas_order_num,
           c_kas_audit#rcv_file,
           c_kas_audit#create,
           c_kas_audit#edit,
           c_kas_audit#date_create,
           c_kas_audit#date_edit,
           c_kas_audit#from_rout,
           c_kas_audit#op_date,
           c_kas_audit#key_valid,
           c_kas_warr_date_sk,
           c_kas_op_date,
           sn,
           su
      from s01.Z#USER@rdwh_exd t
     where id in (select distinct id
                    from s01.s$Z#USER@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    commit;
    --сохраняем информацию о послeдней загрузке
    update t_rdwh_increment_tables_load
       set last_date = d_src_commit_date_load
     where object_name = 'T_RFO_Z#USER';
    commit;


   end ETLT_RFO_USER;
   --
/

