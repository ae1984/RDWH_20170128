CREATE OR REPLACE FORCE VIEW U1.V_RFO_ONLINE_FLD_DNP_PHONES_2 AS
select f."RFO_CLIENT_ID",
       f."FOLDER_ID_LIST",
       SUBSTR(f.FOLDER_DATE_CREATE_LIST, 1, 19) as FOLDER_DATE_CREATE_LIST,
       -- f."FOLDER_DATE_CREATE_HOUR_LIST",
       --   f."X_DNP_REGION",
       f."X_DNP_NAME",
       f."DEP_CODE",
       f."DEP_NAME",
       f."PROCESS_LIST",
       f."FOLDER_STATE_LIST",
       f."CIENT_IIN",
       f."PRODUCT_LIST",
       f."CLIENT_NAME_LAST",
       f."CLIENT_NAME_FIRST",
       f."CLIENT_NAME_PATRONYMIC",
       f."CLIENT_NAME_SHORT",
       f."MOBILE_PHONES",
       f."MANAGER_NAME_LIST",
       f."MANAGER_ID_LIST",
       case
         when ((f.prod_activ_list is null) and
              (upper(f.PROCESS_LIST) like '%ПЕРЕВОД%')) then
          'Переводы'
         when ((f.prod_activ_list is not null) and
             (upper(f.PROCESS_LIST) like '%ПЕРЕВОД%')) then
         f.prod_activ_list || '; ' || 'Переводы'
         else
          f.prod_activ_list
       end as prod_activ_list,
       f.is_regkspkz,
       f.is_paykspkz
--  f."DATA_REFRESH_HOUR",
--   f."OPERATOR",
--   f."WAVE"
  from m_rfo_online_fld_dnp_phon_uniq f, t_nps_dict_rfo_dso d
 where f.folder_id_list in
       (select folder_id_list
          from (SELECT t.folder_id_list, t.dep_code
                  FROM m_rfo_online_fld_dnp_phon_uniq t
                 where t.dep_code = d.dep_code
                 group by t.dep_code, t.folder_id_list
                 order by folder_id_list) x
         where rownum <= (select d.cl_cnt
                            from t_nps_dict_rfo_dso d
                           where d.dep_code = x.dep_code
                             and d.dep_code = f.dep_code and d.cl_cnt in (4,20)))
   and f.dep_code = d.dep_code and d.cl_cnt in (4,20)
;
grant select on U1.V_RFO_ONLINE_FLD_DNP_PHONES_2 to LOADDB;
grant select on U1.V_RFO_ONLINE_FLD_DNP_PHONES_2 to LOADER;
grant select on U1.V_RFO_ONLINE_FLD_DNP_PHONES_2 to NPS;


