create or replace procedure u1.ETLT_CLIENT_DRAW_DOWN is
  s_mview_name     varchar2(30) := 'M_CLIENT_DRAW_DOWN';

begin
insert into M_CLIENT_DRAW_DOWN
select /*+parallel(1) */
        fld.c_client    as rfo_client_id,
        upper(cp.c_last_name) || ' ' || upper(cp.c_first_name) || ' ' ||
        upper(cp.c_sur_name) as  client_name,
        cl.x_iin        as client_iin,
        fld.id          as folder_id,
        fd.c_doc_date   as folder_date_create,
        mm.c_sum_nt     as op_sum_kzt,
        ft.c_cur_short  as currency,
        case when vv.collection_id is not null then 1 else 0 end as is_verification,
        u.c_name  as create_user_name,
        sd.c_code as depart_code,
        dd.id     as draw_down_id
from T_RFO_Z#FOLDERS    fld
join T_RFO_Z#CM_CHECKPOINT cc on cc.c_date_create>=(select trunc(max(folder_date_create)) from M_CLIENT_DRAW_DOWN) and cc.id = fld.id
join T_RFO_Z#CLIENT      cl on cl.id = fld.c_client
join T_RFO_Z#CL_PRIV     cp on cp.id = cl.id
join V_RFO_Z#BUS_PROCESS bp on bp.id = fld.c_business
                           and bp.c_code = 'DRAW_DOWN'
join M_CLIENT_DRAW_DOWN_PRE1 fd on fd.collection_id = fld.c_docs
join M_CLIENT_DRAW_DOWN_PRE2 md on md.collection_id = fld.c_docs
left join M_CLIENT_DRAW_DOWN_PRE3 vv on vv.collection_id = fld.c_docs
join T_RFO_Z#DRAW_DOWN    dd on dd.id = fd.id and dd.c_cash_type#0 = 1
join T_RFO_Z#MAIN_DOCUM  mm on mm.id = md.id
join V_RFO_Z#FT_MONEY    ft on ft.id = mm.c_valuta
left join T_RFO_Z#USER      u on u.id = cc.c_create_user
left join V_RFO_Z#STRUCT_DEPART sd on sd.id = u.c_st_depart
left join M_CLIENT_DRAW_DOWN a1 on a1.folder_id=fld.id
where  a1.folder_id is null;
commit;

end ETLT_CLIENT_DRAW_DOWN;
/

