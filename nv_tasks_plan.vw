create or replace force view u1.nv_tasks_plan as
select t."SDT",t."TASK_NAME",t."START_TIME",t."END_TIME",t."GROUP_NUM",t."TASK_NUM",t."SQL_CODE",t."DESCR",t."IS_ACTIVE",t."OBJECT_NAME",t."INTERVAL",t."WEEKDAY",t."DAY" from NT_TASKS_PLAN t
order by t.task_name, t.group_num,t.task_num;
grant select on U1.NV_TASKS_PLAN to MON_AOLEG;


