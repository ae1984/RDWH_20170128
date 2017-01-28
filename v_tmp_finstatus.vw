create or replace force view u1.v_tmp_finstatus as
select /*+ noparallel */
       tt."DATE_OPER",tt."BENEFICIARY",tt."IIK_BENEF",tt."BIK_BENEF",tt."DOCUMENT_CODE",tt."DOCUMENT_NUMBER",tt."DEBET",tt."CREDIT",tt."PAY_PURPOSE",
       substr(tt.beneficiary, instr(tt.beneficiary,' ИН ')+4, 12) as IIN_BENEFICIARY,
       regexp_replace(substr(tt.pay_purpose,
                             case when instr(tt.pay_purpose,'Первичные данные ИИН ') > 0 then instr(tt.pay_purpose,'Первичные данные ИИН ')+21
                                  when instr(tt.pay_purpose,' ИИН ') > 0 then instr(tt.pay_purpose,' ИИН ')+5
                                  when instr(tt.pay_purpose,'ИИН ') > 0 then instr(tt.pay_purpose,'ИИН ')+4
                                  when instr(tt.pay_purpose,'ИИН: ') >0 then instr(tt.pay_purpose,'ИИН: ')+5
                                  when instr(tt.pay_purpose,'ИИН:') >0 then instr(tt.pay_purpose,'ИИН:')+4
                                  when instr(tt.pay_purpose,'ИИН_') >0 then instr(tt.pay_purpose,'ИИН_')+4
                                  when instr(tt.pay_purpose,'ИИН') >0 then instr(tt.pay_purpose,'ИИН')+3
                                  when instr(tt.pay_purpose,' ИИН') >0 then instr(tt.pay_purpose,' ИИН')+4
                                    else null end, 12),'[A-я]| ','') as IIN_PAY_PURPOSE,
       case when tt.pay_purpose like '%KZ%' then
                                                 replace(replace(substr(tt.pay_purpose,
                                                                instr(tt.pay_purpose,'KZ'),
                                                                20
                                                                ),'KZKA)',''),
                                                         'KZT не соответствуе ',
                                                         '')
            else null
       end as KZ_PAY_PURPOSE
  from u1.T_TMP_FINSTATUS tt;
grant select on U1.V_TMP_FINSTATUS to LOADDB;
grant select on U1.V_TMP_FINSTATUS to LOADER;


