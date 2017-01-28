create or replace force view u1.v_out_zalog_estimate as
select x."1", x."2", x."3", x."4", x."5", x."6", x."7", x."9", x."10", x."11", x."12", x."13", x."14"
from (
select *
  from (
select tc.COLUMN_ID, cc.comments
  from user_tab_columns tc
  left join user_col_comments cc on tc.TABLE_NAME = cc.table_name
                                and tc.COLUMN_NAME = cc.column_name
 where tc.table_name = 'M_RFO_ZALOG_ESTIMATE'
   and tc.COLUMN_ID in (1,2,3,4,5,6,7,9,10,11,12,13,14))
 pivot
 (max(comments) for (column_id) in (1,2,3,4,5,6,7,9,10,11,12,13,14))
 ) x
 union all
select ze.date_estimate_yyyymm,
       to_char(ze.folder_id),
       to_char(ze.date_estimate,'dd-mm-yyyy hh24:mi:ss'),
       ze.brand,
       ze.model,
       to_char(ze.year),
       ze.vin,
       to_char(ze.cnt_estimate),
       to_char(ze.num_estimate),
       to_char(ze.auto_eval_price),
       to_char(ze.auto_eval_confidence_level),
       ze.estim_user,
       ze.is_auto_estim
  from M_RFO_ZALOG_ESTIMATE ze
 where ze.date_estimate >= trunc(add_months(sysdate,-1),'mm')
 order by 1 desc, 3 desc;
comment on table U1.V_OUT_ZALOG_ESTIMATE is 'Информация о залогах, переданных на оценку';
comment on column U1.V_OUT_ZALOG_ESTIMATE.1 is 'Месяц поступления на оценку в формате char(yyyy-mm)';
comment on column U1.V_OUT_ZALOG_ESTIMATE.2 is 'Идентификатор заявки';
comment on column U1.V_OUT_ZALOG_ESTIMATE.3 is 'Дата поступления на оценку';
comment on column U1.V_OUT_ZALOG_ESTIMATE.4 is 'Марка авто';
comment on column U1.V_OUT_ZALOG_ESTIMATE.5 is 'Модель авто';
comment on column U1.V_OUT_ZALOG_ESTIMATE.6 is 'Год выпуска авто';
comment on column U1.V_OUT_ZALOG_ESTIMATE.7 is 'VIN код';
comment on column U1.V_OUT_ZALOG_ESTIMATE.9 is 'Общее количество поступлений данной заявки на оценку авто';
comment on column U1.V_OUT_ZALOG_ESTIMATE.10 is 'Порядковый номер поступления данной заявки на оценку авто';
comment on column U1.V_OUT_ZALOG_ESTIMATE.11 is 'Сумма оценки возращенная МО автоматически';
comment on column U1.V_OUT_ZALOG_ESTIMATE.12 is 'Уровень доверенности возвращаемой автоматически суммы оценки:1-доверительное';
comment on column U1.V_OUT_ZALOG_ESTIMATE.13 is 'ФИО оценщика';
comment on column U1.V_OUT_ZALOG_ESTIMATE.14 is 'Признак прохождения через автоматическую оценку';
grant select on U1.V_OUT_ZALOG_ESTIMATE to LOADDB;
grant select on U1.V_OUT_ZALOG_ESTIMATE to LOADER;


