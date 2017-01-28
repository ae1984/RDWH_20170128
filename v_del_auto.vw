create or replace force view u1.v_del_auto as
select --+ noparallel
    c.yy_mm_start_last, -- месяц выдачи кредита или выдачи/установки револьверности по карте
       --p.x_dnp_name, -- город
--       p.pos_code,
--       p.pos_name,
--      p.pos_code ||' ' || p.pos_name as pos, -- подразделение
--       dc.create_empl_name, -- менеджер
--       fc.expert_name, fc.expert_position, -- должность

    -- ПРОВЕРКА
    count(*) as con_cnt, count(distinct c.contract_id) as con_dist_cnt, -- проверка - если эти два поля равны, значит выборка верна

    -- ПРОДАЖИ
    round(sum(c.max_debt_used) / 1000000) as sales_mln, -- USE THIS! - продажи, млн
    round(sum(c.max_debt_used)) as sales, -- продажи

    -- ПРОСРОЧКА
    round(sum(c.delinq_rate_b_w * c.max_debt_used) / sum(c.max_debt_used),1) as del_rate_b_w, -- USE THIS! - просрочка всего по-новому
    round(sum(c.delinq_rate * c.max_debt_used) / sum(c.max_debt_used),1) as del_rate, -- просрочка всего по-старому
    round(sum(c.delinq_rate_pmt_1 * c.max_debt_used) / sum(c.max_debt_used),1) as del_rate_pmt_1, -- USE THIS! - просрочка 1-го платежа
    round(sum(c.delinq_rate_npl * c.max_debt_used) / sum(c.max_debt_used),1) as del_rate_npl, -- USE THIS! - просрочка по NPL (>=90 days)

    -- 3 из 6
    round(count(case when p.deal_number is not null then p.deal_number end)/ count(*) * 100, 2) as fraud_3_on_6_rate,


    round(sum(c.delinq_rate_pmt_2_x1 * c.max_debt_used) / sum(c.max_debt_used),1) as del_rate_pmt_2_x1,
    round(sum(c.delinq_rate_pmt_2_01 * c.max_debt_used) / sum(c.max_debt_used),1) as del_rate_pmt_2_01,
    round(sum(c.delinq_rate_pmt_3_xx1 * c.max_debt_used) / sum(c.max_debt_used),1) as del_rate_pmt_3_xx1,
    round(sum(c.delinq_rate_pmt_3_001 * c.max_debt_used) / sum(c.max_debt_used),1) as del_rate_pmt_3_001,
    round(sum(c.delinq_rate_pmt_4_xxx1 * c.max_debt_used) / sum(c.max_debt_used),1) as del_rate_pmt_4_xxx1,
    round(sum(c.delinq_rate_pmt_4_0001 * c.max_debt_used) / sum(c.max_debt_used),1) as del_rate_pmt_4_0001,
    round(sum(c.delinq_rate_pmt_5_xxxx1 * c.max_debt_used) / sum(c.max_debt_used),1) as del_rate_pmt_5_xxxx1,
    round(sum(c.delinq_rate_pmt_5_00001 * c.max_debt_used) / sum(c.max_debt_used),1) as del_rate_pmt_5_00001,
    round(sum(c.delinq_rate_pmt_6_xxxxx1 * c.max_debt_used) / sum(c.max_debt_used),1) as del_rate_pmt_6_xxxxx1,
    round(sum(c.delinq_rate_pmt_6_000001 * c.max_debt_used) / sum(c.max_debt_used),1) as del_rate_pmt_6_000001,

    round(sum(case when dc.x_amount > 0 and c.delinq_days_pmt_2 >= 31 then c.total_debt_pmt_2 end) / sum(c.max_debt_used)*100,1) as del_rate_pmt_2_11,
    round(sum(case when dc.x_amount > 0 and c.delinq_days_pmt_3 >= 61 then c.total_debt_pmt_3 end) / sum(c.max_debt_used)*100,1) as del_rate_pmt_3_111,

    round(count(distinct case when dc.x_amount > 0 and c.delinq_days_last_rep_new >= 7 and
                   c.total_debt_last_rep_new >= 1500 then c.contract_id end) /
                   count(distinct case when dc.x_amount > 0 then c.contract_id end)*100,2) as del_rate_by_quant_new,

    round(count(distinct case when dc.x_amount > 0 and c.delinq_rate_last_rep >= 7 and
                   c.total_debt_last_rep >= 1500 then c.contract_id end) /
                   count(distinct case when dc.x_amount > 0 then c.contract_id end)*100,2) as del_rate_by_quant_old,

    round(count(distinct case when dc.x_amount > 0 and c.delinq_rate_pmt_1 > 0 then c.contract_id end) /
               count(distinct case when dc.x_amount > 0 then c.contract_id end) * 100, 2) as del_rate_pmt_1_by_quant,

    round(count(distinct case when dc.x_amount > 0 and c.delinq_rate_npl > 0 then c.contract_id end) /
               count(distinct case when dc.x_amount > 0 then c.contract_id end) * 100, 2) as del_rate_npl_by_quant,

    round(count(distinct case when dc.x_amount > 0 and c.delinq_days_pmt_2 >= 31 then c.contract_id end) /
               count(distinct case when dc.x_amount > 0 then c.contract_id end) * 100, 2) as del_rate_pmt_2_11_by_quant,

    round(count(distinct case when dc.x_amount > 0 and c.delinq_days_pmt_3 >= 61 then c.contract_id end) /
               count(distinct case when dc.x_amount > 0 then c.contract_id end) * 100, 2) as del_rate_pmt_3_111_by_quant

from u1.M_CONTRACT_CAL_DEL c
join u1.V_DWH_PORTFOLIO_CURRENT dc on dc.deal_number = c.contract_number
join u1.V_POS p on p.pos_code = dc.dept_number
left join u1.M_OUT_CONTRACT_3F6_PAY p on p.deal_number = c.contract_number
join u1.M_FOLDER_CON_CANCEL fc on fc.folder_id = c.folder_id_first and
                               fc.contract_number = c.contract_number
where (c.yy_mm_start_last like '2013 - %' or (c.yy_mm_start_last like '2014 - %' /*and c.yy_mm_start_last != '2014 - 06'*/)) and
      --(--p.pos_type = 'ОТДЕЛЕНИЕ'
            dc.prod_type in
            --('АВТОКРЕДИТОВАНИЕ'
             ('АВТОКРЕДИТОВАНИЕ БУ'--,'АВТОЗАПЧАСТИ')
       ) --and
--      p.x_dnp_name = 'АЛМАТЫ' and
--      p.pos_code = '001-900-438' --and
--      dc.prod_type != 'РЕФИНАНСИРОВАНИЕ/РЕСТРУКТУРИЗАЦИЯ'
group by c.yy_mm_start_last--,
--group by p.x_dnp_name
--,p.pos_code,
--p.pos_name
--,p.pos_code ||' ' || p.pos_name
--group by dc.create_empl_name, fc.expert_position
--group by fc.expert_name, fc.expert_position
having sum(c.max_debt_used) > 0
;
grant select on U1.V_DEL_AUTO to DNP;
grant select on U1.V_DEL_AUTO to LOADDB;
grant select on U1.V_DEL_AUTO to LOADER;


