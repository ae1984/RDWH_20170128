create or replace force view u1.v_contract_ekt_risky_goods as
select contract_number,
             sum(new_risky_goods_same_count) as new_risky_goods_all_count,
             max(new_risky_goods_same_count) as new_max_risky_goods_same_count,
             count(distinct product_name) as different_risky_goods_cnt,
             max(contract_term_months) as contract_term_months
      from (
          select ce.contract_number, ce.product_name,
                 count(*) as new_risky_goods_same_count,
                 max(ce.contract_term_months) as contract_term_months
          from V_CONTRACT_EKT_DWH ce
          join (/*select rg1.product_name from V_TMP_JAN_RGOODS_1 rg1
                union */select mr.title as product_name from V_MO_RISKY_GOODS mr
/*                union (
                    select 'ACCSDA ПОСУДА' from dual union all
                    select 'PCP КАРТРИДЖИ' from dual union all
                    select 'АКСЕССУАРЫ' from dual union all
                    select 'АНТИВИРУСНАЯ ЗАЩИТА' from dual union all
                    select 'БРИТВЫ РОТОРНЫЕ' from dual union all
                    select 'ВОДОНАГРЕВАТЕЛЬ НАКОПИТЕЛЬНЫЙ' from dual union all
                    select 'КУХОННЫЙ ГАРНИТУР' from dual union all
                    select 'МАССАЖЕРЫ' from dual union all
                    select 'НОСИТЕЛИ ИНФОРМАЦИИ' from dual union all
                    select 'ПОСУДА' from dual union all
                    select 'ПРИНТЕР ЛАЗЕРНЫЙ' from dual union all
                    select 'ПРИНТЕР СТРУЙНЫЙ' from dual union all
                    select 'ПЫЛЕСОСЫ БЫТОВЫЕ' from dual union all
                    select 'СТОЛ' from dual union all
                    select 'УХОД ЗА НОГТЯМИ' from dual union all
                    select 'ФИЛЬМЫ/МУЗ DVD' from dual union all
                    select 'ФИЛЬТРЫ ДЛЯ ВОДЫ' from dual union all
                    select 'ШКАФ' from dual)*/
                ) rg on rg.product_name = ce.product_name
          group by ce.contract_number, ce.product_name
      ) group by contract_number;
grant select on U1.V_CONTRACT_EKT_RISKY_GOODS to LOADDB;
grant select on U1.V_CONTRACT_EKT_RISKY_GOODS to LOADER;


