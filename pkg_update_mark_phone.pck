create or replace package u1.PKG_UPDATE_MARK_PHONE is

  -- Для маркетинга обзвон пользователей kaspi.kz и CALL CENTR
  procedure update_cl_phoned_kspkz;

end PKG_UPDATE_MARK_PHONE;
/

create or replace package body u1.PKG_UPDATE_MARK_PHONE is

  procedure update_cl_phoned_kspkz is
    v_hour_min        number;
    V_day_of_the_week varchar2(256);
  begin
    select to_number(to_char(sysdate, 'HH24MI')) into v_hour_min from dual;
  
    if (v_hour_min >= 930) and (v_hour_min <= 1630) then
    
      --Запищем клиентов которых обзвонят, чтоб повторно не звонить(маркетинг).
    
      select lower(trim(to_char(sysdate, 'Day')))
        into V_day_of_the_week
        from dual;
    
      if V_day_of_the_week not in ('sunday', 'saturday') then
      
        -------------------------------------------------------
        if (v_hour_min >= 1000) and (v_hour_min < 1040) then
        
          dbms_mview.refresh('M_NPS_KSPKZ_ONL_REGUSER_PHONES');
        
          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.iin, sysdate
               from M_NPS_KSPKZ_ONL_REGUSER_PHONES t
              where t.iin is not null); --  1 волна
        
          commit;
          ---------
        
          dbms_mview.refresh('M_NPS_KSPKZ_ONL_LOGUSER_PHONES');
        
          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.iin, sysdate
               from M_NPS_KSPKZ_ONL_LOGUSER_PHONES t
              where t.iin is not null); --  1 волна
        
          commit;
        
          ------------------------------------------------------------------------
          ----=========================CALL CENTR==================================
          dbms_mview.refresh('M_DWH_SIEBEL_RPT_CLNT_FST_CALL');
          dbms_mview.refresh('M_DWH_SBL_RPT_CLT_CALL_ITOG');
        
          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.client_iin, sysdate
               from V_DWH_SIEBEL_RPT_CLNT_FST_CALL t
              where t.client_iin is not null); --  1 волна
        
          commit;
        
          ----=======================================================================
        elsif (v_hour_min >= 1200) and (v_hour_min < 1240) then
        
          dbms_mview.refresh('M_NPS_KSPKZ_ONL_REGUSER_PHONES');
        
          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.iin, sysdate
               from M_NPS_KSPKZ_ONL_REGUSER_PHONES t
              where t.iin is not null); --2 волна
        
          commit;
          --------
        
          dbms_mview.refresh('M_NPS_KSPKZ_ONL_LOGUSER_PHONES');
        
          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.iin, sysdate
               from M_NPS_KSPKZ_ONL_LOGUSER_PHONES t
              where t.iin is not null); --  2 волна
        
          commit;
        
          ------------------------------------------------------------------------
          ----=========================CALL CENTR==================================
          dbms_mview.refresh('M_DWH_SIEBEL_RPT_CLNT_FST_CALL');
          dbms_mview.refresh('M_DWH_SBL_RPT_CLT_CALL_ITOG');
        
          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.client_iin, sysdate
               from V_DWH_SIEBEL_RPT_CLNT_FST_CALL t
              where t.client_iin is not null); --  2 волна
        
          commit;
        
          ----=======================================================================
        elsif (v_hour_min >= 1500) and (v_hour_min < 1540) then
        
          dbms_mview.refresh('M_NPS_KSPKZ_ONL_REGUSER_PHONES');
        
          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.iin, sysdate
               from M_NPS_KSPKZ_ONL_REGUSER_PHONES t
              where t.iin is not null); --3 волна
        
          commit;
          ---------
        
          dbms_mview.refresh('M_NPS_KSPKZ_ONL_LOGUSER_PHONES');
        
          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.iin, sysdate
               from M_NPS_KSPKZ_ONL_LOGUSER_PHONES t
              where t.iin is not null); --  3 волна
        
          commit;
        
          ------------------------------------------------------------------------
          ----=========================CALL CENTR==================================
          dbms_mview.refresh('M_DWH_SIEBEL_RPT_CLNT_FST_CALL');
          dbms_mview.refresh('M_DWH_SBL_RPT_CLT_CALL_ITOG');
        
          insert into T_NPS_CLIENT_PHONED_ALL
            (select distinct t.client_iin, sysdate
               from V_DWH_SIEBEL_RPT_CLNT_FST_CALL t
              where t.client_iin is not null); --  3 волна
        
          commit;
        
          ----=======================================================================
        end if;
      end if;
    end if;
  
    --====================================Обзвон KASPI SHOP=============================================
  
    if (v_hour_min >= 840) and (v_hour_min <= 920) then
      dbms_mview.refresh('M_NPS_KASPI_SHOP'); --один раз в 9, за прошлый день, нужно обновить до  M_NPS_CL_ACTIV_PRODUCT
    
      insert into T_NPS_CLIENT_PHONED_ALL
        (select distinct t.CLIENT_IIN, sysdate
           from V_NPS_KASPI_SHOP t
          where t.CLIENT_IIN is not null);
    
      commit;
    
    end if;
  
    --====================================================================================================
    ---Очистка из спика клиентов которым позвонили, пол года назад:
  
    if (v_hour_min >= 620) and (v_hour_min <= 720) then
    
      delete T_NPS_CLIENT_PHONED_ALL d
       where trunc(d.insert_date) < trunc(sysdate - 180);
      commit;
    
    end if;
  
  exception
    when others then
      log_error(in_operation     => 'PKG_UPDATE_MARKETING_PHONE.M_KSPKZ_ONL_',
                in_error_code    => sqlcode,
                in_error_message => sqlerrm);
  end update_cl_phoned_kspkz;

end PKG_UPDATE_MARK_PHONE;
/

