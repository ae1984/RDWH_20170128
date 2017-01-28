CREATE OR REPLACE FORCE VIEW U1.V_OUT_VERIF_REV_BOOLMAP AS
SELECT ovr.verification_type,
           --trunc(ovr.accept_date,'mm') accept_month,
           ovr.product,
           TRUNC(TO_DATE(ovr.accept_date, 'YYYY-mm-dd hh24:mi:ss'), 'mm') accept_month,
           ovr.contract_status,
           ovr.verification_status,

           DECODE(UPPER(ovr.verification_status), 'ПОДТВЕРЖДЁН', 1, 0) confirmed,
           DECODE(UPPER(ovr.verification_status), 'ОТКАЗ', 1, 0) denied,
           DECODE(UPPER(ovr.verification_status), '', 1, 0) noverification,

           DECODE(ovr.contract_status, 'РАБОТАЕТ', 1, 'КС РАБОТАЕТ', 1, 'ЗС РАБОТАЕТ', 1, 0) working,
           DECODE(ovr.contract_status, 'НА ПРОСРОЧКЕ', 1, 'КС НА ПРОСРОЧКЕ', 1, 'ЗС НА ПРОСРОЧКЕ', 1, 0) overdue,
           DECODE(ovr.contract_status, 'ЗАКРЫТО', 1, 'ПОМЕЧЕН К ЗАКРЫТИЮ', 1, 0) closed,
           DECODE(ovr.contract_status, NULL, 1, 0) nocontract
      FROM u1.m_out_verification_revise ovr
;
grant select on U1.V_OUT_VERIF_REV_BOOLMAP to LOADDB;
grant select on U1.V_OUT_VERIF_REV_BOOLMAP to RISK_VERIF;


