create or replace force view u1.v_asokr as
select
    d.contract_number,
    d.prescoring_result,
    d.scoring_result,
    d.scoring_status
from data_asokr d,
  (select distinct
         (select max(b.folder_id) from data_asokr b
                 where b.contract_number = c.contract_number) as folder_id_max
  from data_asokr c
  where c.contract_number in (
      select a.contract_number from data_asokr a
      where a.contract_number is not null
      group by a.contract_number
      having count(*) > 1)
  ) e
where d.folder_id = e.folder_id_max
union
select
    f.contract_number,
    f.prescoring_result,
    f.scoring_result,
    f.scoring_status
from data_asokr f
where f.contract_number not in (
      select g.contract_number from data_asokr g
      where g.contract_number is not null
      group by g.contract_number
      having count(*) > 1);
grant select on U1.V_ASOKR to LOADDB;
grant select on U1.V_ASOKR to LOADER;


