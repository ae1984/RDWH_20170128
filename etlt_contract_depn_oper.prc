create or replace procedure u1.ETLT_CONTRACT_DEPN_OPER is
    s_mview_name varchar2(30) := 'T_CONTRACT_DEPN_OPER';
    vStrDate date := sysdate;
    d_max_date_depn date;
    d_date_load     date := trunc(sysdate);

  begin
    --определяем последнюю дату по задолженности
    select max(do.c_date_begin_oper)
      into d_max_date_depn
      from T_CONTRACT_DEPN_OPER do;

      for cur in (select d_max_date_depn + level as rep_date
                   from dual
                  where d_max_date_depn + level < d_date_load
                connect by rownum < d_date_load - d_max_date_depn
                  order by 1
      ) loop
    --добавляем расчеты по новым датам
    --enable_parallel_dml parallel
    insert /*+ append */ into T_CONTRACT_DEPN_OPER(rbo_contract_id,c_code_debt,c_name_debt,c_code_oper,c_name_oper,c_date_begin_oper,c_sum_oper_db,c_sum_oper_cr,c_cur_short )
    select /*+ parallel(15)*/
         x.id as rbo_contract_id,
         x.c_code_debt,
         x.c_name_debt,
         x.c_code_oper,
         x.c_name_oper,
         x.c_kas_date_prov as c_date_begin_oper,
         x.sum_oper_db,
         x.sum_oper_cr,
         x.c_cur_short
    from (
  select
         trunc(fo.c_kas_date_prov) as c_kas_date_prov, fo.collection_id, d.id, d.c_num_dog, d.c_date_close,
         vod.c_code c_code_oper, vod.sys_name c_name_oper,
         sum(case when td.c_dt = 1 then fo.c_summa else 0 end) sum_oper_db,
         sum(case when td.c_dt = 0 then fo.c_summa else 0 end) sum_oper_cr,
         vd.c_code c_code_debt, vd.c_name c_name_debt,
         (select c_cur_short from v_rbo_z#ft_money where id = d.c_fintool) as c_cur_short
    from V_RBO_Z#VID_OPER_DOG vod,
         V_RBO_Z#VID_DEBT vd,
         V_RBO_Z#TAKE_IN_DEBT td,
         T_RBO_Z#FACT_OPER fo,
         V_RBO_Z#DEPN d,
         V_RBO_Z#VID_DEPOSIT vdp
   where vod.c_code_group = 'ДЕПОЗИТЫ'
     and vod.c_take_debt = td.collection_id
     and td.c_debt = vd.id
     and fo.collection_id = d.c_list_pay
     and fo.c_oper = vod.id
     and d.c_vid_dog = vdp.id
     and vdp.c_has_timeout = 1 --только срочные депозиты, исключаем текущие счета
     and fo.c_kas_doc_state = 'PROV'
     and vd.c_code = 'ОСТ_ВКЛАД'
     and fo.c_kas_date_prov = cur.rep_date
     and fo.c_kas_date_prov < d_date_load
  group by trunc(fo.c_kas_date_prov), fo.collection_id, d.id, d.c_num_dog,
     d.c_date_close, vd.c_code, vd.c_name, d.c_fintool,  vod.c_code, vod.sys_name) x;
    commit;
    end loop;

       delete from T_CONTRACT_DEPN_OPER do where do.rbo_contract_id in (select rbo_contract_id from T_CONTRACT_EDIT_OBJ_TMP);
       commit;
       --enable_parallel_dml parallel
       insert /*+ append */ into T_CONTRACT_DEPN_OPER(rbo_contract_id,c_code_debt,c_name_debt,c_code_oper,c_name_oper,c_date_begin_oper,c_sum_oper_db,c_sum_oper_cr,c_cur_short)
       select /*+ parallel(15)*/
           x.id as rbo_contract_id,
           x.c_code_debt,
           x.c_name_debt,
           x.c_code_oper,
           x.c_name_oper,
           x.c_kas_date_prov as c_date_begin_oper,
           x.sum_oper_db,
           x.sum_oper_cr,
           x.c_cur_short
      from (select trunc(fo.c_kas_date_prov) as c_kas_date_prov, fo.collection_id, d.id, d.c_num_dog, d.c_date_close,
                   vod.c_code c_code_oper, vod.sys_name c_name_oper,
                   sum(case when td.c_dt = 1 then fo.c_summa else 0 end) sum_oper_db,
                   sum(case when td.c_dt = 0 then fo.c_summa else 0 end) sum_oper_cr,
                   vd.c_code c_code_debt, vd.c_name c_name_debt,
                   (select c_cur_short from v_rbo_z#ft_money where id = d.c_fintool) as c_cur_short
              from V_RBO_Z#VID_OPER_DOG vod,
                   V_RBO_Z#VID_DEBT vd,
                   V_RBO_Z#TAKE_IN_DEBT td,
                   T_RBO_Z#FACT_OPER fo,
                   V_RBO_Z#DEPN d,
                   V_RBO_Z#VID_DEPOSIT vdp
             where vod.c_code_group = 'ДЕПОЗИТЫ'
               and vod.c_take_debt = td.collection_id
               and td.c_debt = vd.id
               and fo.collection_id = d.c_list_pay
               and fo.c_oper = vod.id
               and d.c_vid_dog = vdp.id
               and vdp.c_has_timeout = 1 --только срочные депозиты, исключаем текущие счета
               and fo.c_kas_doc_state = 'PROV'
               and vd.c_code = 'ОСТ_ВКЛАД'
               and fo.c_kas_date_prov < d_date_load
               and d.id in (select rbo_contract_id from T_CONTRACT_EDIT_OBJ_TMP)
            group by trunc(fo.c_kas_date_prov), fo.collection_id, d.id, d.c_num_dog,
               d.c_date_close, vd.c_code, vd.c_name, d.c_fintool,  vod.c_code, vod.sys_name) x;
      commit;
   --end loop;



   end ETLT_CONTRACT_DEPN_OPER;
/

