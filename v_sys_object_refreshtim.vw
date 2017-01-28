create or replace force view u1.v_sys_object_refreshtim as
with tt1 as (
select t1.process,
       t1.p_date,
       to_number(substr(value_type,2)) v_ord,
       substr(value,1,instr(value,' ')-1) v_name,
       substr(value,instr(value,' at ')+4,8) v_time
  from (select
               ul.process,
               ul.p_date,
               substr(ul.p_detail,1,instr(ul.p_detail,chr(10))) t1,
               substr(ul.p_detail,instr(ul.p_detail,chr(10))+1,instr(ul.p_detail,chr(10),1,2)-instr(ul.p_detail,chr(10))) t2,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,2)+1,instr(ul.p_detail,chr(10),1,3)-instr(ul.p_detail,chr(10),1,2)) t3,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,3)+1,instr(ul.p_detail,chr(10),1,4)-instr(ul.p_detail,chr(10),1,3)) t4,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,4)+1,instr(ul.p_detail,chr(10),1,5)-instr(ul.p_detail,chr(10),1,4)) t5,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,5)+1,instr(ul.p_detail,chr(10),1,6)-instr(ul.p_detail,chr(10),1,5)) t6,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,6)+1,instr(ul.p_detail,chr(10),1,7)-instr(ul.p_detail,chr(10),1,6)) t7,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,7)+1,instr(ul.p_detail,chr(10),1,8)-instr(ul.p_detail,chr(10),1,7)) t8,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,8)+1,instr(ul.p_detail,chr(10),1,9)-instr(ul.p_detail,chr(10),1,8)) t9,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,9)+1,instr(ul.p_detail,chr(10),1,10)-instr(ul.p_detail,chr(10),1,9)) t10,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,10)+1,instr(ul.p_detail,chr(10),1,11)-instr(ul.p_detail,chr(10),1,10)) t11,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,11)+1,instr(ul.p_detail,chr(10),1,12)-instr(ul.p_detail,chr(10),1,11)) t12,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,12)+1,instr(ul.p_detail,chr(10),1,13)-instr(ul.p_detail,chr(10),1,12)) t13,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,13)+1,instr(ul.p_detail,chr(10),1,14)-instr(ul.p_detail,chr(10),1,13)) t14,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,14)+1,instr(ul.p_detail,chr(10),1,15)-instr(ul.p_detail,chr(10),1,14)) t15,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,15)+1,instr(ul.p_detail,chr(10),1,16)-instr(ul.p_detail,chr(10),1,15)) t16,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,16)+1,instr(ul.p_detail,chr(10),1,17)-instr(ul.p_detail,chr(10),1,16)) t17,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,17)+1,instr(ul.p_detail,chr(10),1,18)-instr(ul.p_detail,chr(10),1,17)) t18,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,18)+1,instr(ul.p_detail,chr(10),1,19)-instr(ul.p_detail,chr(10),1,18)) t19,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,19)+1,instr(ul.p_detail,chr(10),1,20)-instr(ul.p_detail,chr(10),1,19)) t20,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,20)+1,instr(ul.p_detail,chr(10),1,21)-instr(ul.p_detail,chr(10),1,20)) t21,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,21)+1,instr(ul.p_detail,chr(10),1,22)-instr(ul.p_detail,chr(10),1,21)) t22,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,22)+1,instr(ul.p_detail,chr(10),1,23)-instr(ul.p_detail,chr(10),1,22)) t23,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,23)+1,instr(ul.p_detail,chr(10),1,24)-instr(ul.p_detail,chr(10),1,23)) t24,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,24)+1,instr(ul.p_detail,chr(10),1,25)-instr(ul.p_detail,chr(10),1,24)) t25,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,25)+1,instr(ul.p_detail,chr(10),1,26)-instr(ul.p_detail,chr(10),1,25)) t26,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,26)+1,instr(ul.p_detail,chr(10),1,27)-instr(ul.p_detail,chr(10),1,26)) t27,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,27)+1,instr(ul.p_detail,chr(10),1,28)-instr(ul.p_detail,chr(10),1,27)) t28,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,28)+1,instr(ul.p_detail,chr(10),1,29)-instr(ul.p_detail,chr(10),1,28)) t29,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,29)+1,instr(ul.p_detail,chr(10),1,30)-instr(ul.p_detail,chr(10),1,29)) t30,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,30)+1,instr(ul.p_detail,chr(10),1,31)-instr(ul.p_detail,chr(10),1,30)) t31,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,31)+1,instr(ul.p_detail,chr(10),1,32)-instr(ul.p_detail,chr(10),1,31)) t32,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,32)+1,instr(ul.p_detail,chr(10),1,33)-instr(ul.p_detail,chr(10),1,32)) t33,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,33)+1,instr(ul.p_detail,chr(10),1,34)-instr(ul.p_detail,chr(10),1,33)) t34,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,34)+1,instr(ul.p_detail,chr(10),1,35)-instr(ul.p_detail,chr(10),1,34)) t35,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,35)+1,instr(ul.p_detail,chr(10),1,36)-instr(ul.p_detail,chr(10),1,35)) t36,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,36)+1,instr(ul.p_detail,chr(10),1,37)-instr(ul.p_detail,chr(10),1,36)) t37,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,37)+1,instr(ul.p_detail,chr(10),1,38)-instr(ul.p_detail,chr(10),1,37)) t38,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,38)+1,instr(ul.p_detail,chr(10),1,39)-instr(ul.p_detail,chr(10),1,38)) t39,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,39)+1,instr(ul.p_detail,chr(10),1,40)-instr(ul.p_detail,chr(10),1,39)) t40,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,40)+1,instr(ul.p_detail,chr(10),1,41)-instr(ul.p_detail,chr(10),1,40)) t41,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,41)+1,instr(ul.p_detail,chr(10),1,42)-instr(ul.p_detail,chr(10),1,41)) t42,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,42)+1,instr(ul.p_detail,chr(10),1,43)-instr(ul.p_detail,chr(10),1,42)) t43,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,43)+1,instr(ul.p_detail,chr(10),1,44)-instr(ul.p_detail,chr(10),1,43)) t44,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,44)+1,instr(ul.p_detail,chr(10),1,45)-instr(ul.p_detail,chr(10),1,44)) t45,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,45)+1,instr(ul.p_detail,chr(10),1,46)-instr(ul.p_detail,chr(10),1,45)) t46,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,46)+1,instr(ul.p_detail,chr(10),1,47)-instr(ul.p_detail,chr(10),1,46)) t47,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,47)+1,instr(ul.p_detail,chr(10),1,48)-instr(ul.p_detail,chr(10),1,47)) t48,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,48)+1,instr(ul.p_detail,chr(10),1,49)-instr(ul.p_detail,chr(10),1,48)) t49,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,49)+1,instr(ul.p_detail,chr(10),1,50)-instr(ul.p_detail,chr(10),1,49)) t50,
               substr(ul.p_detail,instr(ul.p_detail,chr(10),1,50)+1,instr(ul.p_detail,chr(10),1,51)-instr(ul.p_detail,chr(10),1,50)) t51

          from daily_update_log ul
         where ul.p_date >= trunc(sysdate)-30
           ) t1
  unpivot (value for value_type in (t1,t2, t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,t13,t14,t15,t16,t17,t18,t19,t20,
                                    t21,t22,t23,t24,t25,t26,t27,t28,t29,t30,t31,t32,t33,t34,t35,t36,t37,t38,t39,
                                    t40,t41,t42,t43,t44,t45,t46,t47,t48,t49,t50,t51)) t1)

select
       tt1.p_date,
       tt1.process,
       tt1.v_ord,
       tt1.v_name,
       tt1.v_time,
       nvl(tt2.v_time,to_char(ul.p_begin,'hh24:mi:ss')) as v_prev_time,
       (to_date('01.01.4000'||tt1.v_time,'dd.mm.yyyy hh24:mi:ss') -
       to_date('01.01.4000'||nvl(tt2.v_time,to_char(ul.p_begin,'hh24:mi:ss')),'dd.mm.yyyy hh24:mi:ss')) *24*60*60 as fullrefreshtim_sec,
       round((to_date('01.01.4000'||tt1.v_time,'dd.mm.yyyy hh24:mi:ss') -
       to_date('01.01.4000'||nvl(tt2.v_time,to_char(ul.p_begin,'hh24:mi:ss')),'dd.mm.yyyy hh24:mi:ss')) *24*60) as fullrefreshtim_min,
       to_number(to_char(to_date(tt1.v_time,'hh24:mi:ss'),'hh24mi')) as e_timestamp
  from tt1 tt1
  left join tt1  tt2 on tt2.process = tt1.process and tt1.v_ord = tt2.v_ord+1 and tt1.p_date= tt2.p_date
  left join daily_update_log ul on ul.process = tt1.process and tt1.p_date = ul.p_date
 where tt1.v_name <> 'Errors'
order by tt1.process, tt1.v_ord, p_date;
grant select on U1.V_SYS_OBJECT_REFRESHTIM to LOADDB;
grant select on U1.V_SYS_OBJECT_REFRESHTIM to LOADER;


