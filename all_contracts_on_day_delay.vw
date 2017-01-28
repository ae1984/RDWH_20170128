create or replace force view u1.all_contracts_on_day_delay as
select
count(distinct x.deal_number) as vsego_dogovorov,
sum (x.deal_prosr) as vsego_prosrochnikov,
sum (x.sum_prosr_dog) as sum_prosr_dogovorov,
sum (x.sum_NE_prosr_dog) as sum_NE_prosr_dogovorov,
sum (x.sum_PLETEJEI_prosr_dog) as sum_PLETEJEI_prosr_dog,
x.delinq_start_date,
trunc(sum (x.deal_prosr)/count(distinct x.deal_number)*100,1) as proz_dog,
trunc(sum (x.sum_prosr_dog)/(sum (x.sum_prosr_dog)+sum (x.sum_NE_prosr_dog))*100,1) as proz_sum_dog
from (
select
distinct
 pp.deal_number,
case when c.deal_number is not null then 1 else 0 end as deal_prosr,
case when pp.deal_number = c.deal_number then pp.x_amount end as sum_prosr_dog,
case when c.deal_number is null then pp.amount end as sum_NE_prosr_dog,
case when pp.deal_number = c.deal_number then pp.x_delinq_amount end as sum_PLETEJEI_prosr_dog,
b.delinq_start_date

from v_dwh_portfolio_current pp
join (
select a.delinq_start_date,a.begin_date,a.deal_number,a.x_is_card from (
select case when ((p.delinq_start_date >= add_months(p.begin_date,+1) and (p.delinq_start_date <= add_months(p.begin_date,+1)+7)) and p.x_is_card = 0) or
           ((p.delinq_start_date >= add_months(p.begin_date,+2) and (p.delinq_start_date <= add_months(p.begin_date,+2)+7)) and p.x_is_card = 1) then 1 else 0 end as prosrochka,
p.x_start_date,
p.delinq_start_date,
p.begin_date,
p.x_is_card,
p.deal_number
from v_dwh_portfolio_current p
where p.begin_date>=to_date('01.01.2014','dd.mm.yyyy')
) a where a.prosrochka = 1
) b on pp.begin_date = b.begin_date and pp.x_is_card = b.x_is_card and (pp.actual_end_date is null or pp.actual_end_date>b.delinq_start_date)and pp.plan_end_date>b.delinq_start_date

left join (
select a.delinq_start_date,a.begin_date,a.deal_number from (
select case when ((p.delinq_start_date >= add_months(p.begin_date,+1) and (p.delinq_start_date <= add_months(p.begin_date,+1)+7)) and p.x_is_card = 0) or
           ((p.delinq_start_date >= add_months(p.begin_date,+2) and (p.delinq_start_date <= add_months(p.begin_date,+2)+7)) and p.x_is_card = 1) then 1 else 0 end as prosrochka,
p.x_start_date,
p.delinq_start_date,
p.begin_date,
p.deal_number/*,p.amount,p.x_delinq_amount,p.x_amount,p.x_total_debt*/
from v_dwh_portfolio_current p
where p.begin_date>=to_date('01.01.2014','dd.mm.yyyy')
) a where a.prosrochka = 1
) c
on pp.deal_number = c.deal_number
/*where pp.x_is_card = 1*/)x

group by x.delinq_start_date
order by x.delinq_start_date;
grant select on U1.ALL_CONTRACTS_ON_DAY_DELAY to LOADDB;
grant select on U1.ALL_CONTRACTS_ON_DAY_DELAY to LOADER;


