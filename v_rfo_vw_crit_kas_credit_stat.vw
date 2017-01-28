CREATE OR REPLACE FORCE VIEW U1.V_RFO_VW_CRIT_KAS_CREDIT_STAT AS
SELECT /*+ FIRST_ROWS */
  C_PROP,
  /*CODE*/ cred_prog_code /*C_1*/,
  /*NAME*/ cred_prog_name /*C_2*/,
  /*NDOG*/ contract_count /*C_3*/,
  /*SDOG*/ contract_amount_total /*C_4*/,
  /*NREQ*/ folder_count /*C_5*/
FROM (
    select /*+ FIRST_ROWS */
           b3.C_PROP, ---
           b4.C_CODE as cred_prog_code /*CODE*/,
           b4.C_NAME as cred_prog_name /*NAME*/,
           (select COUNT(1) C_1
            from V_RFO_Z#PROPERTIES c4,
                 V_RFO_Z#CRED_SCHEME c3,
                 V_RFO_Z#FDOC c2,
                 V_RFO_Z#CREDIT_DOG c1
            where c1.id = c2.id and
                  c1.C_CRED_SCHEME = c3.id and
                  c3.C_ADD_PROP = c4.collection_id
              and (--c1.C_DATE_BEGIN >= TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY') and
                   --c1.C_DATE_BEGIN < TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY')+1 and
                   --c1.C_DATE_END > TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY') and
                   c1.C_DATE_BEGIN >= trunc(sysdate) - 1 and
                   c1.C_DATE_BEGIN < trunc(sysdate) and
                   c1.C_DATE_END > trunc(sysdate) - 1 and

                   c2.C_STATUS_DOC in (3704301, 3704308, 9456720) and -- Активный, Погашен досрочно, Просроченный
                   c4.C_PROP = b3.C_PROP)
           ) as contract_count /*NDOG*/,
           (select SUM(d1.C_INFO_CRED#SUMMA_CRED_COM) C_1
              from V_RFO_Z#PROPERTIES d4,
                   V_RFO_Z#CRED_SCHEME d3,
                   V_RFO_Z#FDOC d2,
                   V_RFO_Z#CREDIT_DOG d1
              where d1.id = d2.id and
                    d1.C_CRED_SCHEME = d3.id and
                    d3.C_ADD_PROP = d4.collection_id
                and (--d1.C_DATE_BEGIN >= TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY') and
                     --d1.C_DATE_BEGIN < TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY')+1 and
                     --d1.C_DATE_END > TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY') and
                     d1.C_DATE_BEGIN >= trunc(sysdate) - 1 and
                     d1.C_DATE_BEGIN < trunc(sysdate) and
                     d1.C_DATE_END > trunc(sysdate) - 1 and

                     d2.C_STATUS_DOC in (3704301, 3704308, 9456720) and -- Активный, Погашен досрочно, Просроченный
                     d4.C_PROP = b3.C_PROP)
            ) as contract_amount_total /*SDOG*/,
    COUNT(1) as folder_count /*NREQ*/
    from V_RFO_Z#PROD_PROPERTY b4,
         V_RFO_Z#PROPERTIES b3,
         V_RFO_Z#CRED_SCHEME b2,
         V_RFO_Z#CREDIT_DOG b1,
         V_RFO_Z#CM_CHECKPOINT a3,
         V_RFO_Z#RDOC a2,
         V_RFO_Z#FOLDERS a1
    where a1.C_DOCS = a2.collection_id and
          a1.id = a3.id and
          b1.C_CRED_SCHEME = b2.id and
          b2.C_ADD_PROP = b3.collection_id and
          b3.C_PROP = b4.id
      and (a2.C_DOC = b1.ID and
           b4.C_GROUP_PROP = 188106869 and -- KAS. Программы кредитования
--           a3.C_DATE_CREATE >= TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY') and
--           a3.C_DATE_CREATE < TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY')+1 and
           a3.C_DATE_CREATE >= trunc(sysdate) - 1 and
           a3.C_DATE_CREATE < trunc(sysdate) and

           a1.C_BUSINESS in (3647625, 95085189, 1441323670, 1441323906, 6503629123) and
           -- Выдача кредита физическому лицу
           -- Каспийский. Кредит наличными
           -- Каспийский. Выдача кредита на карту
           -- Каспийский. Выдача кредита наличными на карту
           -- Каспийский. Выдача автокредита на карту
           (a1.C_KAS_VID_DELIVERY is NULL or
            a1.C_KAS_VID_DELIVERY <> 2255218132) -- SAVE_CREDIT  БК (V_RFO_Z#KAS_UNIVERSAL_D)
           )
    group by b3.C_PROP, b4.C_NAME, b4.C_CODE


    union ---------------------------------------------------------------------------------------


    select
          f3.C_PROP,
          f4.C_CODE as cred_prog_code /*CODE*/,
          f4.C_NAME as cred_prog_name /*NAME*/,
    ( select  COUNT(1) C_1
      from V_RFO_Z#PROPERTIES g4,
           V_RFO_Z#KAS_CARD_SCHEME g3,
           V_RFO_Z#FDOC g2,
           V_RFO_Z#KAS_PC_DOG g1
      where g1.id = g2.id and
            g1.C_PC_SCHEME = g3.id and
            g3.C_ADD_PROP = g4.collection_id
        and (--g1.C_DATE_SET_REVOLV >= TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY') and
             --g1.C_DATE_SET_REVOLV < TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY')+1 and
             g1.C_DATE_SET_REVOLV >= trunc(sysdate) - 1 and
             g1.C_DATE_SET_REVOLV < trunc(sysdate) and

             g2.C_STATUS_DOC in (115881331, 115881597, 115880367, 115881457, 9456720, 84882947) and
             -- Работает
             -- ЗС Работает
             -- КС На просрочке
             -- ЗС На просрочке
             -- Просроченный
             -- Подписан
             g4.C_PROP = f3.C_PROP and
             g3.C_CODE <> 'REFIN' and -- Рефинансирование
             NVL(g1.C_WISH_PAY_SUM,0) = 0) -- отсекаем заявки на изменение условий и рефинансирование
    ) as contract_count /*NDOG*/, (
      select  SUM(h1.C_CREDIT_LIMIT) C_1
      from V_RFO_Z#PROPERTIES h4,
           V_RFO_Z#KAS_CARD_SCHEME h3,
           V_RFO_Z#FDOC h2,
           V_RFO_Z#KAS_PC_DOG h1
      where h1.id = h2.id and
            h1.C_PC_SCHEME = h3.id and
            h3.C_ADD_PROP = h4.collection_id
        and (--h1.C_DATE_SET_REVOLV >= TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY') and
            --h1.C_DATE_SET_REVOLV < TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY')+1 and

            h1.C_DATE_SET_REVOLV >= trunc(sysdate) - 1 and
            h1.C_DATE_SET_REVOLV < trunc(sysdate) and

            h2.C_STATUS_DOC in (115881331, 115881597, 115880367, 115881457, 9456720, 84882947) and
             -- Работает
             -- ЗС Работает
             -- КС На просрочке
             -- ЗС На просрочке
             -- Просроченный
             -- Подписан
            h4.C_PROP = f3.C_PROP and
            h3.C_CODE <> 'REFIN' and -- Рефинансирование
            NVL(h1.C_WISH_PAY_SUM,0) = 0) -- отсекаем заявки на изменение условий
    ) as contract_amount_total /*SDOG*/,
    COUNT(1) as folder_count /*NREQ*/
    from V_RFO_Z#PROD_PROPERTY f4,
         V_RFO_Z#PROPERTIES f3,
         V_RFO_Z#KAS_CARD_SCHEME f2,
         V_RFO_Z#KAS_PC_DOG f1,
         V_RFO_Z#CM_CHECKPOINT e3,
         V_RFO_Z#RDOC e2,
         V_RFO_Z#FOLDERS e1
    where e1.C_DOCS = e2.collection_id and
          e1.id = e3.id and
          f1.C_PC_SCHEME = f2.id and
          f2.C_ADD_PROP = f3.collection_id and
          f3.C_PROP = f4.id
      and (e2.C_DOC = f1.ID and
           (e1.C_KAS_VID_DELIVERY is NULL or
            e1.C_KAS_VID_DELIVERY <> 2255218132) and -- SAVE_CREDIT  БК (V_RFO_Z#KAS_UNIVERSAL_D)
           f4.C_GROUP_PROP = 188106869 and -- KAS. Программы кредитования
           (( --e3.C_DATE_CREATE >= TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY') and
              --e3.C_DATE_CREATE < TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY')+1 and
              e3.C_DATE_CREATE >= trunc(sysdate) - 1 and
              e3.C_DATE_CREATE < trunc(sysdate) and

              e1.C_BUSINESS in (84882952, 1682828418)
              -- Выдача пластиковой карты
              -- Установка револьверности
              ) or (
               --f1.C_DATE_SET_REVOLV >= TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY') and
               --f1.C_DATE_SET_REVOLV < TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY')+1 and
               f1.C_DATE_SET_REVOLV >= trunc(sysdate) - 1 and
               f1.C_DATE_SET_REVOLV < trunc(sysdate) and

               e1.C_BUSINESS in (1441323670, 1441323906)
               -- Каспийский. Выдача кредита на карту
               -- Каспийский. Выдача кредита наличными на карту
            )) and
            f2.C_CODE <> 'REFIN') -- Рефинансирование
    group by f3.C_PROP, f4.C_CODE, f4.C_NAME


    union ---------------------------------------------------------------------------------------


    select j3.C_PROP,
           j4.C_CODE as cred_prog_code /*CODE*/,
           j4.C_NAME as cred_prog_name /*NAME*/,
     (select COUNT(1) C_1
      from V_RFO_Z#PROPERTIES k4,
           V_RFO_Z#KAS_CARD_SCHEME k3,
           V_RFO_Z#FDOC k2,
           V_RFO_Z#KAS_PC_DOG k1
      where k1.id = k2.id and
            k1.C_PC_SCHEME = k3.id and
            k3.C_ADD_PROP = k4.collection_id
        and (--k1.C_DATE_SET_REVOLV >= TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY') and
             --k1.C_DATE_SET_REVOLV < TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY')+1 and
             k1.C_DATE_SET_REVOLV >= trunc(sysdate) - 1 and
             k1.C_DATE_SET_REVOLV < trunc(sysdate) and

             k2.C_STATUS_DOC in (115881331, 115881597, 115880367, 115881457, 9456720, 84882947) and
             -- Работает
             -- ЗС Работает
             -- КС На просрочке
             -- ЗС На просрочке
             -- Просроченный
             -- Подписан
             k4.C_PROP = j3.C_PROP and
             NVL(k1.C_WISH_PAY_SUM,0) <> 0) -- отсекаем заявки на изменение условий
    ) as contract_count /*NDOG*/, (
      select SUM(l1.C_CREDIT_LIMIT) C_1
      from V_RFO_Z#PROPERTIES l4,
           V_RFO_Z#KAS_CARD_SCHEME l3,
           V_RFO_Z#FDOC l2,
           V_RFO_Z#KAS_PC_DOG l1
      where l1.id = l2.id and
            l1.C_PC_SCHEME = l3.id and
            l3.C_ADD_PROP = l4.collection_id
        and (--l1.C_DATE_SET_REVOLV >= TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY') and
             --l1.C_DATE_SET_REVOLV < TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY')+1 and
             l1.C_DATE_SET_REVOLV >= trunc(sysdate) - 1 and
             l1.C_DATE_SET_REVOLV < trunc(sysdate) and

             l2.C_STATUS_DOC in (115881331, 115881597, 115880367, 115881457, 9456720, 84882947) and
             -- Работает
             -- ЗС Работает
             -- КС На просрочке
             -- ЗС На просрочке
             -- Просроченный
             -- Подписан

             l4.C_PROP = j3.C_PROP and
             NVL(l1.C_WISH_PAY_SUM,0) <> 0) -- отсекаем заявки на изменение условий
    ) as contract_amount_total /*SDOG*/,
    COUNT(1) as folder_count /*NREQ*/
    from V_RFO_Z#PROD_PROPERTY j4,
         V_RFO_Z#PROPERTIES j3,
         V_RFO_Z#KAS_CARD_SCHEME j2,
         V_RFO_Z#KAS_PC_DOG j1,
         V_RFO_Z#RDOC i2,
         V_RFO_Z#FOLDERS i1
    where i1.C_DOCS = i2.collection_id and
          j1.C_PC_SCHEME = j2.id and
          j2.C_ADD_PROP = j3.collection_id and
          j3.C_PROP = j4.id
      and (i2.C_DOC = j1.ID and
           i1.C_KAS_VID_DELIVERY = 2255218132 and -- SAVE_CREDIT  БК (V_RFO_Z#KAS_UNIVERSAL_D)
           j4.C_GROUP_PROP = 188106869 and -- KAS. Программы кредитования
--           j1.C_DATE_SET_REVOLV >= TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY') and
--           j1.C_DATE_SET_REVOLV < TO_DATE(SYS_CONTEXT('IBS_USER','VW_CHOICE_DATE'),'DD/MM/YYYY')+1 and
           j1.C_DATE_SET_REVOLV >= trunc(sysdate) - 1 and
           j1.C_DATE_SET_REVOLV < trunc(sysdate) and

           i1.C_BUSINESS in (1441323906, 6503629123, 7054580055))
           -- Каспийский. Выдача кредита наличными на карту
           -- Каспийский. Выдача автокредита на карту
           -- Выдача управляемого кредита
    group by j3.C_PROP, j4.C_CODE, j4.C_NAME


) A1
/* WHERE
  ( SYS_CONTEXT('IBS_SYSTEM','ADMIN')='1' OR EXISTS
    (
      SELECT 1 FROM Criteria_Rights M_R, Subj_Equal SE
       WHERE M_R.Obj_Id ='517208873'
         AND M_R.Subj_Id=SE.Equal_Id AND SE.Subj_Id=SYS_CONTEXT('IBS_SYSTEM','USER')
    )
    AND
    ( EXISTS
      (
        SELECT 1 FROM Class_Rights C_R, Subj_Equal SE
         WHERE C_R.Obj_Id='FOLDERS' AND C_R.Subj_Id=SE.Equal_Id AND SE.Subj_Id=SYS_CONTEXT('IBS_SYSTEM','USER')
      )
    )
  )

 AND SYS_CONTEXT('IBS_OPTIONS','517208873') is null
 AND SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER') is null;*/
;
grant select on U1.V_RFO_VW_CRIT_KAS_CREDIT_STAT to LOADDB;
grant select on U1.V_RFO_VW_CRIT_KAS_CREDIT_STAT to LOADER;


