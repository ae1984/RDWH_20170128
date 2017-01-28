create or replace procedure u1.ETLT_DM_SPGU_LD_TMP is
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


   select count(1) into v_cnt from DWH_SAN.DM_SPGU_HD@DWH_PROD2 s where s.exhd_rep_date = v_day;
   -- если n_tmp равна 0, значит данных нет. Останавливаем процесс обновления и записываем в лог результат дейсвий.
   if v_cnt = 0 then
      --s_error_message := 'Отсутствие данных в DWH_SAN.DM_SPGU_HD@DWH_PROD2';
      raise e_user_exception;
   end if;
   --
   --Заполняем временные таблицы и изначально чистим из них данные
   -- чистим таблицы
   execute immediate ('truncate table u1.DM_SPGU_LD_TMP');
   -- заполняем временно таблицу DM_SPGU_LD_TMP
   insert into u1.DM_SPGU_LD_TMP
   select exhd$change_date,exhd$audit_id,exhd_clnt_gid,exhd_dcard_gid,exhd_rep_date,exhd_client_name,
          exhd_client_iin,exhd_client_rnn,exhd_client_rfo_id,exhd_deal_number,exhd_currency,exhd_begin_date,exhd_plan_end_date,exhd_actual_end_date,
          exhd_amount,exhd_deal_status,exhd_rate_value,exhd_prod_name,exhd_prod_type,exhd_old_ovd_scheme,exhd_dept_name,exhd_dept_number,exhd_unp_name,
          exhd_unp_number,exhd_fil_name,exhd_fil_number,exhd_create_empl_name,exhd_create_empl_number,exhd_sign_empl_name,exhd_sign_empl_number,exhd_fgu_as_of_date,
          exhd_fgu_cred,exhd_fgu_prc,exhd_fgu_ovrd_cred,exhd_fgu_ovrd_prc,exhd_to_ovrd_date,exhd_ovrd_days,exhd_cl_to_ovrd_date,exhd_cl_ovrd_days,exhd_vnb_ovrd_cred,
          exhd_vnb_ovrd_prc,exhd_vnb_comm,exhd_vnb_flag,exhd_vnb_date,exhd_pay_sale_type,exhd_pay_goods_price,exhd_goods_count,exhd_pay_comm_amount,exhd_company_name,
          exhd_fgu_overdraft,exhd_fgu_ovrd_overdraft,exhd_vnb_overdraft
   from DWH_SAN.DM_SPGU_HD@DWH_PROD2 t
   where t.exhd_rep_date = v_day;
   commit;
   
   -- проверяем пустые таблицы или нет.
   select count(1) into v_cnt from u1.DM_SPGU_LD_TMP;
   if v_cnt = 0 then
      --s_error_message := 'Проверка DM_SPGU_LD_TMP. Данные не закачались';
      raise e_user_exception;
   end if;
   
end ETLT_DM_SPGU_LD_TMP;
/

