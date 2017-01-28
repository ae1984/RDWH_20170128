create or replace force view u1.approval_rate_by_processes as
select trunc(t.folder_date_create) as folder_date,
round(count(case when t.is_credit_process = 1 and t.is_credit_issued = 1 then t.folder_id end)*100/
                 nullif(count(case when t.is_credit_process = 1 then t.folder_id end),0),2) as app_rate,
round(count(case when t.process_name = 'ВЫДАЧА ПЛАСТИКОВОЙ КАРТЫ' and t.is_credit_issued = 1 then t.folder_id end)*100/
                 nullif(count(case when t.process_name = 'ВЫДАЧА ПЛАСТИКОВОЙ КАРТЫ' then t.folder_id end),0),2) as app_rate_p1,
round(count(case when t.process_name = 'КАСПИЙСКИЙ. ВЫДАЧА КРЕДИТА НА КАРТУ' and t.is_credit_issued = 1 then t.folder_id end)*100/
                 nullif(count(case when t.process_name = 'КАСПИЙСКИЙ. ВЫДАЧА КРЕДИТА НА КАРТУ' then t.folder_id end),0),2) as app_rate_p2,
round(count(case when t.process_name = 'УСТАНОВКА РЕВОЛЬВЕРНОСТИ' and t.is_credit_issued = 1 then t.folder_id end)*100/
                 nullif(count(case when t.process_name = 'УСТАНОВКА РЕВОЛЬВЕРНОСТИ' then t.folder_id end),0),2) as app_rate_p3,
round(count(case when t.process_name = 'КАСПИЙСКИЙ. ВЫДАЧА АВТОКРЕДИТА НА КАРТУ' and t.is_credit_issued = 1 then t.folder_id end)*100/
                 nullif(count(case when t.process_name = 'КАСПИЙСКИЙ. ВЫДАЧА АВТОКРЕДИТА НА КАРТУ' then t.folder_id end),0),2) as app_rate_p4,
round(count(case when t.process_name = 'КАСПИЙСКИЙ. ВЫДАЧА КРЕДИТА НАЛИЧНЫМИ НА КАРТУ' and t.is_credit_issued = 1 then t.folder_id end)*100/
                nullif(count(case when t.process_name = 'КАСПИЙСКИЙ. ВЫДАЧА КРЕДИТА НАЛИЧНЫМИ НА КАРТУ' then t.folder_id end),0),2) as app_rate_p5
from V_FOLDER_ALL_RFO t
where t.folder_date_create > trunc(sysdate) - 30
group by trunc(t.folder_date_create)
order by folder_date;
grant select on U1.APPROVAL_RATE_BY_PROCESSES to LOADDB;
grant select on U1.APPROVAL_RATE_BY_PROCESSES to LOADER;


