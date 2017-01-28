create or replace force view u1.v_rbo_online_terminal as
select f.id,
       f.c_document_date,
       f.pt,
       f.name_object,
       f.reg_addres,
       f.c_inn,
       f.c_name,
       f.c_numb,
       f.c_nazn_list,
       f.c_amount_list,
       f.prod_type_list
  from (select *
          from M_RBO_ONLINE_TERMINAL_UNIQ  order by id desc) f
 where rownum < 91;
grant select on U1.V_RBO_ONLINE_TERMINAL to LOADDB;
grant select on U1.V_RBO_ONLINE_TERMINAL to LOADER;
grant select on U1.V_RBO_ONLINE_TERMINAL to NPS;


