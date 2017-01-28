create or replace force view u1.v_cc_day as
select    /*cc.clctcc_as_of_time,
          t.clnt_name,
          cc.clctcc_cont_info_desc,
          cc.clctcc_call_id,
          cc.clctcc_topic_class,
          e.topic_name,
          ee.empl_name,
          cc.clctcc_duration,
          p.skill_group_name,
          cc.clctcc_lang_name,
          cc.clctcc_result_desc,
          r.clnt_cont_direct_name */
          topic_name,
          count(clctcc_call_id) as cnt
from  dwh_main.acc_client_contact_cc@dwh_prod2 cc  --звонки
      join dwh_main.ref_client@dwh_prod2 t  -- клиенты
      on cc.clctcc_clnt_gid = t.clnt_gid
      join dwh_main.DICT_TOPIC@dwh_prod2 e -- тематика обращения
      on e.topic_cd = cc.clctcc_topic
      join dwh_main.ref_employee@dwh_prod2  ee  --сотрудники
      on ee.empl_gid = cc.clctcc_empl_gid
      join dwh_main.dict_skill_group@dwh_prod2 p -- cправочник скил групп
      on p.skill_group_cd = cc.clctcc_skill_group_number
      join dwh_main.DICT_CLNT_CONT_DIRECT@dwh_prod2 r -- направление звонка
      on r.clnt_cont_direct_cd = cc.clctcc_clnt_cont_direct_cd
            where cc.clctcc_as_of_date >= trunc(sysdate) --дата с
                  --and cc.clctcc_as_of_date <= trunc(sysdate) -- дата по
                  and sysdate between t.clnt$start_date and t.clnt$end_date
                  and sysdate between ee.empl$start_date  and ee.empl$end_date
                  and r.clnt_cont_direct_name='Входящий'
                  and e.topic_name in ( 'Остаток на счетах',
                                        'Остаток на счете',
                                        'Снять деньги с депозита',
                                        'Назначение встречи',
                                        'Остаток на депозитной карте',
                                        'Расчет при пополнении',
                                        'Выписка',
                                        'Информация о договоре',
                                        'Компенсация')
group by(topic_name)
;
grant select on U1.V_CC_DAY to LOADDB;


