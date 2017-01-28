create or replace procedure u1.ETLT_DM_CARDSDAILY_LD_TMP is
   v_day          date; --последний рабочий день предыдущего месяца/день загрузки
   v_weekend        number; 
   v_cnt number;
   e_user_exception exception;
begin
   -- берем последний рабочий день предыдущего месяца
   select trunc(LAST_DAY(add_months(sysdate,-1))) into v_day from dual;
   select nvl(max(ww.day_weekends),0) into v_weekend from u1.T_HOLIDAYS ww where ww.data = v_day;
   -- и откатываем назад на ближайший рабочий день
   v_day := v_day - v_weekend;  


   select count(1) into v_cnt  from DWH_SAN.DM_CARDSDAILY_HD@DWH_PROD2 t  where t.cdhd_rep_date = v_day;
   -- если n_tmp равна 0, значит данных нет. Останавливаем процесс обновления и записываем в лог результат дейсвий.
   if v_cnt = 0 then
      --s_error_message := 'Отсутствие данных в DWH_SAN.DM_CARDSDAILY_HD@DWH_PROD2';
      raise e_user_exception;
   end if;
   --
   --Заполняем временные таблицы и изначально чистим из них данные
   -- чистим таблицы
   execute immediate ('truncate table u1.DM_CARDSDAILY_LD_TMP');
    -- заполняем временно таблицу DM_CARDSDAILY_LD_TMP
   insert /*+ append parallel(20)*/ into u1.DM_CARDSDAILY_LD_TMP
   select s.cdhd$change_date,
          s.cdhd$audit_id,
          s.cdhd_rep_date,
          s.cdhd_clnt_gid,
          s.cdhd_dcard_gid,
          s.cdhd_client_name,
          s.cdhd_client_iin,
          s.cdhd_client_rnn,
          s.cdhd_client_rfo_id,
          s.cdhd_deal_number,
          s.cdhd_currency,
          s.cdhd_begin_date,
          s.cdhd_plan_end_date,
          s.cdhd_actual_end_date,
          s.cdhd_set_revolving_date,
          s.cdhd_deal_status,
          s.cdhd_fst_dept_auto_date,
          s.cdhd_fst_dept_date,
          s.cdhd_card_limit,
          s.cdhd_rate_value,
          s.cdhd_prod_name,
          s.cdhd_prod_type,
          s.cdhd_dept_name,
          s.cdhd_dept_number,
          s.cdhd_unp_name,
          s.cdhd_unp_number,
          s.cdhd_fil_name,
          s.cdhd_fil_number,
          s.cdhd_empl_name,
          s.cdhd_empl_number,
          s.cdhd_create_empl_name,
          s.cdhd_create_empl_number,
          s.cdhd_pc_cred,
          s.cdhd_pc_overlimit,
          s.cdhd_pc_overdraft,
          s.cdhd_pc_prc,
          s.cdhd_pc_ovrd_cred,
          s.cdhd_pc_ovrd_overlimit,
          s.cdhd_pc_ovrd_overdraft,
          s.cdhd_pc_ovrd_prc,
          s.cdhd_available_balance,
          s.cdhd_to_ovrd_date,
          s.cdhd_ovrd_days,
          s.cdhd_cl_to_ovrd_date,
          s.cdhd_cl_ovrd_days,
          s.cdhd_pc_vnb_ovrd_cred,
          s.cdhd_pc_vnb_ovrd_overdraft,
          s.cdhd_pc_vnb_ovrd_overlimit,
          s.cdhd_pc_vnb_ovrd_prc_cred,
          s.cdhd_vnb_flag,
          s.cdhd_vnb_date,
          s.cdhd_restruct_type,
          s.cdhd_restruct_count
   from DWH_SAN.DM_CARDSDAILY_HD@DWH_PROD2 s
   where s.cdhd_rep_date = v_day;
   commit;
   -- проверяем пустые таблицы или нет.
   select count(1) into v_cnt from u1.DM_CARDSDAILY_LD_TMP;
   if v_cnt = 0 then
      --s_error_message := 'Проверка DM_CARDSDAILY_LD_TMP. Данные не закачались';
      raise e_user_exception;
   end if;
end ETLT_DM_CARDSDAILY_LD_TMP;
/

