create or replace procedure u1.ETLT_MO_RFOLDER_PAR_VALUE_2016
       is
       s_mview_name     varchar2(30) := 'T_MO_RFOLDER_PAR_VALUE_2016';
       vStrDate         date := sysdate;
       v_max_date       date;
      begin
       --удаляем записи за вчера для онлайна
        delete from u1.T_MO_RFOLDER_PAR_VALUE_DD t
        where t.date_update < trunc(sysdate);
        commit;

        select /*+ parallel(20) */ max(t.date_create)
        into v_max_date
        from T_MO_RFOLDER_PAR_VALUE_2016 t;

        merge into T_MO_RFOLDER_PAR_VALUE_2016 pv
              using (select *
                       from RFOLDER_PAR_VALUE@MO1_PROD t
                      where (t.date_create > v_max_date or
                             t.date_update > v_max_date) and t.date_create >= cast(to_date('01.01.2016','dd.mm.yyyy') as timestamp) ) pv2
              on (pv.id = pv2.id)
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

              merge into T_MO_RFOLDER_PAR_VALUE_2015 pv
              using (select *
                       from RFOLDER_PAR_VALUE@MO1_PROD t
                      where t.date_update > v_max_date and t.date_create < cast(to_date('01.01.2016','dd.mm.yyyy') as timestamp) ) pv2
              on (pv.id = pv2.id)
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
                                           pv.D_SYSTEM_ID = pv2.D_SYSTEM_ID;
              commit;

 end ETLT_MO_RFOLDER_PAR_VALUE_2016;
/

