create or replace package u1.pkg_rfo_update is

  -- Author  : KIM_17004
  -- Created : 20.03.2014 9:02:38
  -- Purpose : 

  procedure update_rfo_online_fld;

  procedure update_rfo_online_fld_shops;

end pkg_rfo_update;
/

create or replace package body u1.pkg_rfo_update is

  procedure update_rfo_online_fld is
    v_result          number;
    v_hour_min        number;
    V_day_of_the_week varchar2(256);
    V_DATE_START      timestamp := null;
  begin
    select to_number(to_char(sysdate, 'HH24MI')) into v_hour_min from dual;

    if (v_hour_min >= 520) and (v_hour_min <= 650) then
      v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_NPS_KSPIKZ_LOG_SESSIONS'); --сессии пользователей каспи кз за 2 мес
      v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_ALL_DEPOSITS_IIN'); --активные депозиты
    end if;

    if (v_hour_min >= 900) and (v_hour_min <= 1640) then
      ---============Обзвон клиентов в отделениях по Алмате================

      V_DATE_START := systimestamp;
      v_result     := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_PRE1');
      pkg_util.rec_upd_mv('M_RFO_ONLINE_FLD_PRE1',
                          V_DATE_START,
                          systimestamp);

      V_DATE_START := systimestamp;
      v_result     := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_PRE2');
      pkg_util.rec_upd_mv('M_RFO_ONLINE_FLD_PRE2',
                          V_DATE_START,
                          systimestamp);

      V_DATE_START := systimestamp;
      v_result     := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_PRE3');
      pkg_util.rec_upd_mv('M_RFO_ONLINE_FLD_PRE3',
                          V_DATE_START,
                          systimestamp);

      v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD');

      v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'm_rfo_online_fld_dnp_phon_uniq'); --обзвон клиентов в отделениях по Алмате

      --=============Обзвон клиентов ЭКТ=======================================

      v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_EKT_PRE2');

      V_DATE_START := systimestamp;
      v_result     := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_EKT_PRE1');
      pkg_util.rec_upd_mv('M_RFO_ONLINE_FLD_EKT_PRE1',
                          V_DATE_START,
                          systimestamp);

      v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_EKT_2H');

      v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_EKT_PHON_UNIQ');

      ---============Обзвон клиентов пользующиеся внешними Терминалами================

      v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RBO_ONLINE_TERMINAL_PRE1');
      v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RBO_ONLINE_TERMINAL_PRE2');
      v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RBO_ONLINE_TERMINAL_PRE3');
      v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RBO_ONLINE_TERMINAL_UNIQ');

      --Запищем клиентов которых обзвонят, чтоб повторно не звонить(маркетинг).

      select lower(trim(to_char(sysdate, 'Day')))
        into V_day_of_the_week
        from dual;

      if V_day_of_the_week not in ('sunday', 'saturday') then

        ---============Обзвон клиентов в отделениях по Алмате================
        if (v_hour_min >= 1000) and (v_hour_min < 1040) then

          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.CIENT_IIN, sysdate
               from v_rfo_online_fld_dnp_phones_2 t
              where t.CIENT_IIN is not null); --  1 волна
          commit;

        elsif (v_hour_min >= 1200) and (v_hour_min < 1240) then

          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.CIENT_IIN, sysdate
               from v_rfo_online_fld_dnp_phones_2 t
              where t.CIENT_IIN is not null); --2 волна
          commit;

        elsif (v_hour_min >= 1500) and (v_hour_min < 1540) then

          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.CIENT_IIN, sysdate
               from v_rfo_online_fld_dnp_phones_2 t
              where t.CIENT_IIN is not null); --3 волна
          commit;

        end if;

        --=============Обзвон клиентов ЭКТ=======================================
        if (v_hour_min >= 1100) and (v_hour_min < 1140) then

          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.CIENT_IIN, sysdate
               from v_rfo_online_fld_ekt_phones t
              where t.CIENT_IIN is not null); --  1 волна
          commit;

        elsif (v_hour_min >= 1400) and (v_hour_min < 1440) then

          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.CIENT_IIN, sysdate
               from v_rfo_online_fld_ekt_phones t
              where t.CIENT_IIN is not null); --  2 волна
          commit;

        elsif (v_hour_min >= 1600) and (v_hour_min < 1640) then

          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.CIENT_IIN, sysdate
               from v_rfo_online_fld_ekt_phones t
              where t.CIENT_IIN is not null); --  3 волна
          commit;

        end if;

        ---============Обзвон клиентов пользующиеся внешними Терминалами================
        if (v_hour_min >= 1000) and (v_hour_min < 1040) then

          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.c_inn, sysdate
               from v_rbo_online_terminal t
              where t.c_inn is not null); --  1 волна
          commit;

        elsif (v_hour_min >= 1200) and (v_hour_min < 1240) then

          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.c_inn, sysdate
               from v_rbo_online_terminal t
              where t.c_inn is not null); --2 волна
          commit;

        elsif (v_hour_min >= 1500) and (v_hour_min < 1540) then

          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.c_inn, sysdate
               from v_rbo_online_terminal t
              where t.c_inn is not null); --3 волна
          commit;

        end if;

      end if;
    end if;
  exception
    when others then
      log_error(in_operation     => 'M_RFO_ONLINE_FLD',
                in_error_code    => sqlcode,
                in_error_message => sqlerrm);
  end update_rfo_online_fld;

  -- обновление представления для дэшбоарда по товарным кредитам - за час 1 раз в минуту
  procedure update_rfo_online_fld_shops is
    v_result     number;
    v_hour_min   number;
    v_min        number := null;
    V_DATE_START timestamp := null;
  begin
    select to_number(to_char(sysdate, 'HH24MI')) into v_hour_min from dual;

    if (v_hour_min >= 840) and (v_hour_min <= 2100) then

      select mod(to_number(to_char(sysdate, 'MI')) / 10, 1) * 10
      into v_min
      from dual;
      
      --M_RFO_ONLINE_FLD_DAY
      if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_DAY');
        pkg_util.rec_upd_mv('M_RFO_ONLINE_FLD_DAY',
                            V_DATE_START,
                            systimestamp);
      else
        v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_DAY');
      end if;
      
      /*--M_RFO_ONLINE_FLD_1HH
      if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_1HH');
        pkg_util.rec_upd_mv('M_RFO_ONLINE_FLD_1HH',
                            V_DATE_START,
                            systimestamp);
      else
        v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_1HH');
      end if;*/
      
      --Переводим на M_RFO_ONLINE_FLD_DAY, M_RFO_ONLINE_FLD_1HH     
      --M_RFO_ONLINE_FLD_SHOPS
      if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_SHOPS');
        pkg_util.rec_upd_mv('M_RFO_ONLINE_FLD_SHOPS',
                            V_DATE_START,
                            systimestamp);
      else
        v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_SHOPS');
      end if;

      v_result := pkg_update_util.mv_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_EKT');

      --M_RFO_ONLINE_CLAIM
      if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_CLAIM');
        pkg_util.rec_upd_mv('M_RFO_ONLINE_CLAIM',
                            V_DATE_START,
                            systimestamp);
      /*else
        v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_CLAIM');*/
      end if;

      --M_RFO_ONLINE_CLAIM_AMOUNT
      if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_refresh(pMV_Name => 'M_RFO_ONLINE_CLAIM_AMOUNT');
        pkg_util.rec_upd_mv('M_RFO_ONLINE_CLAIM_AMOUNT',
                            V_DATE_START,
                            systimestamp);
      /*else
        v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_CLAIM');*/
      end if;
      
      --M_RFO_ONLINE_FLD_SHOPS_DAY
      if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_SHOPS_DAY');
        pkg_util.rec_upd_mv('M_RFO_ONLINE_FLD_SHOPS_DAY',
                            V_DATE_START,
                            systimestamp);

        v_result := pkg_update_util.mv_refresh(pMV_Name => 'M_RFO_ONLINE_FLD_EKT_DAY');
      
      end if;

      --M_RFO_ONLINE_CLAIM_DAY
      if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_CLAIM_DAY');
        pkg_util.rec_upd_mv('M_RFO_ONLINE_CLAIM_DAY',
                            V_DATE_START,
                            systimestamp);

        v_result := pkg_update_util.mv_refresh(pMV_Name => 'M_RFO_ONLINE_CLAIM_DAY');
      end if;
      
      --M_RFO_ONLINE_CLAIM_AMOUNT_DET
      if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_refresh(pMV_Name => 'M_RFO_ONLINE_CLAIM_AMOUNT_DET');
        pkg_util.rec_upd_mv('M_RFO_ONLINE_CLAIM_AMOUNT_DET',
                            V_DATE_START,
                            systimestamp);
      /*else
        v_result := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_CLAIM');*/
      end if;

      --M_RFO_ONLINE_CLAIM_CNT
      if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_refresh(pMV_Name => 'M_RFO_ONLINE_CLAIM_CNT');
        pkg_util.rec_upd_mv('M_RFO_ONLINE_CLAIM_CNT',
                            V_DATE_START,
                            systimestamp);
      end if;
      
    /*  --M_RFO_ONLINE_CLAIM_CNT_DET
      if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_RFO_ONLINE_CLAIM_CNT_DET');
        pkg_util.rec_upd_mv('M_RFO_ONLINE_CLAIM_CNT_DET',
                            V_DATE_START,
                            systimestamp);
      end if;*/

      --M_MO_ONLINE_SCO_RESULT
      if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_truncate_refresh(pMV_Name => 'M_MO_ONLINE_SCO_RESULT');
        pkg_util.rec_upd_mv('M_MO_ONLINE_SCO_RESULT',
                            V_DATE_START,
                            systimestamp);
      end if;

      --M_RFO_ONLINE_CLAIM_ABNOR
      if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_refresh(pMV_Name => 'M_RFO_ONLINE_CLAIM_ABNOR');
        pkg_util.rec_upd_mv('M_RFO_ONLINE_CLAIM_ABNOR',
                            V_DATE_START,
                            systimestamp);
      end if;
      
      --M_RFO_ONLINE_ALL_CLAIM_DAY
      if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_refresh(pMV_Name => 'M_RFO_ONLINE_ALL_CLAIM_DAY');
        pkg_util.rec_upd_mv('M_RFO_ONLINE_ALL_CLAIM_DAY',
                            V_DATE_START,
                            systimestamp);
      end if;
      
     /* --M_RFO_ONLINE_ALL_CLAIM_AMT_DET
      if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_refresh(pMV_Name => 'M_RFO_ONLINE_ALL_CLAIM_AMT_DET');
        pkg_util.rec_upd_mv('M_RFO_ONLINE_ALL_CLAIM_AMT_DET',
                            V_DATE_START,
                            systimestamp);
      end if;*/

      --M_FOLDER_MO_GCVP_MO_ONLINE
     /* if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_refresh(pMV_Name => 'M_FOLDER_MO_GCVP_MO_ONLINE');
        pkg_util.rec_upd_mv('M_FOLDER_MO_GCVP_MO_ONLINE',
                            V_DATE_START,
                            systimestamp);
       end if;
       */
       --M_OUT_DWH_VERIF_CANCEL_DAY
       if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_refresh(pMV_Name => 'M_OUT_DWH_VERIF_CANCEL_DAY');
        pkg_util.rec_upd_mv('M_OUT_DWH_VERIF_CANCEL_DAY',
                            V_DATE_START,
                            systimestamp);
       end if;
       
       --M_RDBOARD_ONLINE_FLD_DAY
       if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_refresh(pMV_Name => 'M_RDBOARD_ONLINE_FLD_DAY');
        pkg_util.rec_upd_mv('M_RDBOARD_ONLINE_FLD_DAY',
                            V_DATE_START,
                            systimestamp);
       end if;
       
       --M_RDBOARD_ONL_FLD_DAY_CNL_PH
       if (v_min = 0) then
        V_DATE_START := systimestamp;
        v_result     := pkg_update_util.mv_refresh(pMV_Name => 'M_RDBOARD_ONL_FLD_DAY_CNL_PH');
        pkg_util.rec_upd_mv('M_RDBOARD_ONL_FLD_DAY_CNL_PH',
                            V_DATE_START,
                            systimestamp);
       end if;
 

    end if;

  exception
    when others then
      log_error(in_operation     => 'M_RFO_ONLINE_FLD_SHOPS',
                in_error_code    => sqlcode,
                in_error_message => sqlerrm);
  end update_rfo_online_fld_shops;
end pkg_rfo_update;
/

