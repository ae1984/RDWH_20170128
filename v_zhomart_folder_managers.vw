create or replace force view u1.v_zhomart_folder_managers as
select  /*+ index(ch IDX_Z#CM_CHECKPOINT_DATE_CR) USE_NL (ch f bp c c1 p u d) */
        ch.c_date_create as folder_date_create,
        c.c_last_name || ' ' || c.c_first_name || ' ' || c.c_sur_name as FIO,
        c1.c_inn as IIN,
        f.c_n   as NUM_FLD,
        p.c_name    as STATE_FLD,
        u.c_name    as MANAGER,
        d.c_name    as DEPART

from V_RFO_Z#CM_CHECKPOINT ch, V_RFO_Z#FOLDERS f, V_RFO_Z#CL_PRIV c, V_RFO_Z#CLIENT c1,
     V_RFO_Z#CM_POINT p, V_RFO_Z#USER u, V_RFO_Z#STRUCT_DEPART d, V_RFO_Z#BUS_PROCESS bp
    where ch.c_date_create >= to_date('01/03/2013', 'dd/mm/yyyy')
--      and ch.c_date_create < to_date('06/03/2013', 'dd/mm/yyyy')
      and f.id = ch.id
      and f.c_business = bp.id
      and bp.c_code = 'OPEN_CRED_PRIV_PC'
      and f.c_client = c.id
      and c.id = c1.id
      and ch.c_point = p.id
      and ch.c_create_user = u.id(+)
      and ch.c_st_depart = d.id(+)
      and exists (select '1'
                    from V_RFO_Z#CREDIT_DOG cr, V_RFO_Z#RDOC r
                            where r.collection_id = f.c_docs
                              and r.c_doc = cr.id
                              and cr.c_info_cred#type_cred#0 in (1,2))
;
grant select on U1.V_ZHOMART_FOLDER_MANAGERS to LOADDB;
grant select on U1.V_ZHOMART_FOLDER_MANAGERS to LOADER;


