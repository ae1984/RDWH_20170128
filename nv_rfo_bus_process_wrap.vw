create or replace force view u1.nv_rfo_bus_process_wrap as
select
--RDWH2.0
     ID
    ,C_CODE
    ,C_NAME
    ,C_TO_BKI
    ,C_KAS_PRODUCT
    ,C__SIGNS_EX_REF#SIGNS_ARR_REF5
    ,C_KAS_SIGNS_EX_REF#SIGNS_STR
    ,SN
    ,SU
    ,case when c_code in (
                  'OPEN_CRED_PRIV_PC', --Каспийский. Выдача кредита на карту
                  -- 'KAS_SAFE_CREDIT', Выдача управляемого кредита
                  'KAS_AUTO_CRED_PRIV_PC', --Каспийский. Выдача автокредита на карту
                  'KAS_CREDIT_CASH_PRIV_PC', --Каспийский. Выдача кредита наличными на карту
                  'SET_REVOLV', --Установка револьверности
                  'KAS_OPEN_CRED_PRIV_MIN', --Каспийский. Выдача кредита "Минутка"
                  'KAS_AUTO_CRED_PRIV', --Автокредитование
                  'OPEN_PC', --Выдача пластиковой карты
                  'KAS_CREDIT_CASH_PRIV', --Каспийский. Кредит наличными
                  -- 'KAS_PC_PURSE', Выдача кошелька
                  'OPEN_CRED_PRIV', --Выдача кредита физическому лицу
                  'OPEN_TRANSH', --Выдача транша
                  'OPEN_CRED_PRIV_CRL', --Выдача кредита физическому лицу с открытием кредитной линии
                  'OPEN_CRED_PRIV_OLD', --Выдача кредита физическому лицу (NOT ACTIVE)
                  'ONLINE_CRED', --Онлайн Кредит
                  'KASPI_RED'
                  )
         then 1 else 0
     end as is_credit_process --признак что бизнес-процесс кредитный
from u1.V_RFO_Z#BUS_PROCESS t
;
grant select on U1.NV_RFO_BUS_PROCESS_WRAP to LOADDB;


