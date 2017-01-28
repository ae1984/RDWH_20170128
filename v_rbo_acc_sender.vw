create or replace force view u1.v_rbo_acc_sender as
select md.c_kl_dt#2#1 as acc_sender,
       md.c_kl_dt#2#inn as inn_sender,
       md.c_kl_dt#2#2 as name_sender,
       case when md.c_kl_dt#2#3 = 334693543 then 'ALMNKZKA'
            else to_char(md.c_kl_dt#2#3) end as bic_sender,
       md.c_kl_kt#2#1 as acc_recipient,
       md.c_kl_kt#2#inn as inn_recipient,
       md.c_kl_kt#2#2 as name_recipient,
       af.c_main_v_id,
       cl.c_name,
       md.c_nazn as nazn_po,
       md.c_sum as amount_po,
       md.c_date_prov date_prov,
       fm.c_cur_short as curreny_po,
       md.id,
       md.c_quit_doc
  from s02.z#main_docum@rdwh_exd md
  join s02.z#ac_fin@rdwh_exd     af on af.id = md.c_acc_kt
  join s02.z#client@rdwh_exd     cl on cl.id = af.c_client_v
  join s02.z#ft_money@rdwh_exd   fm on fm.id = md.c_valuta
 where c_kl_dt#2#inn = '141240003408'
   and c_date_prov >= to_date('01-01-2016','dd-mm-yyyy')
   and nvl(c_kl_dt#2#3,0) != 334692543
   and md.c_quit_doc is not null
   and md.state_id = 'PROV';
grant select on U1.V_RBO_ACC_SENDER to LOADDB;
grant select on U1.V_RBO_ACC_SENDER to LOADER;


