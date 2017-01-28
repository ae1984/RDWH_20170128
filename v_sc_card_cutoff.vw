create or replace force view u1.v_sc_card_cutoff as
select t."ID",t."D_CALC_CODE",t."VALUE_TEXT",t."VALUE_DATE",t."VALUE_NUMBER",t."STATUS",t."STATUS_NEW",t."VERSION_NUM",t."BATCH_ID",
       x.ball_min,
       x.ball_max
from v_mo_d_calc_const t
left join (
          select t.d_calc_code,
                 case when c.is_new = 0
                      then round(100 / (1 + EXP(- (-2.0536 + (t.ball_min)))), 6)
                 else (t.ball_min) end as ball_min,

                 case when c.is_new = 0
                      then round(100 / (1 + EXP(- (-2.0536 + (t.ball_max)))), 6)
                 else (t.ball_max) end as ball_max
          from (
                select t.d_calc_code,
                       sum(t.ball_min) as ball_min,
                       sum(t.ball_max) as ball_max
                from (
                    select t.d_calc_code,
                           t.d_par_code,

                           min(t.coefficient*t.score_weight) as ball_min,
                           max(t.coefficient*t.score_weight) as ball_max
                    from u1.v_mo_d_calc_score t
                    where t.status = 1
                    group by t.d_calc_code,
                             t.d_par_code
                ) t
                group by t.d_calc_code
          ) t
          left join u1.V_MO_D_SCORE_CARD c on c.d_calc_code = t.d_calc_code and c.status = 1
) x on t.d_calc_code like x.d_calc_code || '_YES_COND%'
where t.status = 1;
grant select on U1.V_SC_CARD_CUTOFF to LOADDB;


