create or replace procedure u1.P_MO_RFOLDER_PAR_VALUE_TST
       is
       s_mview_name     varchar2(30) := 'T_MO_RFOLDER_PAR_VALUE_TST';
       vStrDate         date := sysdate;
       v_max_date       date;
      begin
        --pkg_object_update_util.log_upd(s_mview_name, vStrDate, 'PROCESSING');

        --удаляем записи за вчера для онлайна
        /*delete from u1.T_MO_RFOLDER_PAR_VALUE_DD t
        where t.date_update < trunc(sysdate);
        commit;*/

        select /*+ parallel 30 */ max(t.date_create)
        into v_max_date
        from T_MO_RFOLDER_PAR_VALUE_TST t;

         merge into T_MO_RFOLDER_PAR_VALUE_TST pv
              using (select *
                       from RFOLDER_PAR_VALUE@MO1_PROD t
                      where (t.date_create > v_max_date or
                             t.date_update > v_max_date) and t.date_create >= cast(to_date('01.01.2016','dd.mm.yyyy') as timestamp) ) pv2
              on (pv.rfolder_id=pv2.rfolder_id and pv.d_par_id=pv2.d_par_id and pv.value_index=pv2.value_index and pv.value_index2=pv2.value_index2 )
              when matched then update set pv.RFOLDER_ID = pv2.RFOLDER_ID,
                                           pv.D_PAR_ID = pv2.D_PAR_ID,
                                           pv.VALUE_TEXT = pv2.VALUE_TEXT,
                                           pv.VALUE_DATE = pv2.VALUE_DATE,
                                           pv.VALUE_NUMBER = pv2.VALUE_NUMBER,
                                           pv.DATE_CREATE = pv2.DATE_CREATE,
                                           pv.DATE_UPDATE = pv2.DATE_UPDATE,
                                           pv.D_PAR_DATATYPE_ID = pv2.D_PAR_DATATYPE_ID,
                                           pv.CALC_PAR_VALUE_LAST_ID = pv2.CALC_PAR_VALUE_LAST_ID,
                                           pv.VALUE_INDEX = pv2.VALUE_INDEX,
                                           pv.D_PAR_OBJECT_ID = pv2.D_PAR_OBJECT_ID,
                                           pv.D_SYSTEM_ID = pv2.D_SYSTEM_ID
              when not matched then insert (pv.id, pv.rfolder_id, pv.d_par_id, pv.value_text, pv.value_date, pv.value_number, pv.date_create, pv.date_update, pv.d_par_datatype_id,
                                            pv.calc_par_value_last_id, pv.value_index, pv.d_par_object_id, pv.d_system_id)
                                    values (pv2.id, pv2.rfolder_id, pv2.d_par_id, pv2.value_text, pv2.value_date, pv2.value_number, pv2.date_create, pv2.date_update, pv2.d_par_datatype_id,
                                            pv2.calc_par_value_last_id, pv2.value_index, pv2.d_par_object_id, pv2.d_system_id);


        pkg_object_update_util.log_upd(s_mview_name, vStrDate, 'OK');

       exception when others then
        rollback;
         pkg_object_update_util.log_upd(s_mview_name, vStrDate, 'ERROR');
         u1.log_error (in_operation => 'PKG_TABLE_UTIL.'||s_mview_name,
                            in_error_code => sqlcode,
                            in_error_message => substr(dbms_utility.format_error_backtrace||','||sqlerrm,1,2000),
                            in_object_type => s_mview_name,
                            in_object_id => null);


       end P_MO_RFOLDER_PAR_VALUE_TST;
/

