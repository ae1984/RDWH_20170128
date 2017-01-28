create or replace procedure u1.ETLT_RFO_KAS_ONLINE_BUY
  is
   s_mview_name     varchar2(30) := 'T_RFO_Z#KAS_ONLINE_BUY';
   vStrDate         date := sysdate;
   d_date_start_ins date; --дата логирования инсерта

   d_src_commit_date_last date; --дата последней загруженной строки
   d_src_commit_date_load date; --дата, по которую делаем загрузку

  begin
    --дата необходима для логирования времени инсерта
    d_date_start_ins := sysdate;
    select max(src_commit_date)-5/24/60/60
      into d_src_commit_date_load
      from s01.s$Z#KAS_ONLINE_BUY@rdwh_exd;

    select last_date
      into d_src_commit_date_last
      from t_rdwh_increment_tables_load
     where object_name = 'T_RFO_Z#KAS_ONLINE_BUY';
    --
    delete from T_RFO_Z#KAS_ONLINE_BUY
     where id in (select id
                    from s01.s$Z#KAS_ONLINE_BUY@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    insert into T_RFO_Z#KAS_ONLINE_BUY
    select 
        t.id
        ,t.sn
        ,t.su
        ,t.c_date_create
        ,t.c_state_id
        ,t.c_process_id
        ,t.c_total_amount
        ,t.c_shop
        ,t.c_prod_info
        ,t.c_partner_id
        ,t.c_paymenttype
        ,t.c_add_prop
        ,t.c_delivery_type
        ,t.c_kaspi_shop_addr
        ,t.c_kaspi_shop_sched
    from s01.Z#KAS_ONLINE_BUY@rdwh_exd t
    where id in (select distinct id
                    from s01.s$Z#KAS_ONLINE_BUY@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    commit;
    --сохраняем информацию о послeдней загрузке
    update t_rdwh_increment_tables_load
       set last_date = d_src_commit_date_load
     where object_name = 'T_RFO_Z#KAS_ONLINE_BUY';
    commit;

   end ETLT_RFO_KAS_ONLINE_BUY;
 --
/

