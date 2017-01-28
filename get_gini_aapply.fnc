create or replace function u1.get_gini_aapply(in_source_tab varchar2,
                                           in_coef_name varchar2)
return number is
  Result number;
  
  v_sql varchar2(3000);
begin
  Result := -1;
  
  v_sql := 'select round((max(t7.gini_cum) - 0.5)/max(t7.bad_total_2), 4) * 100 gini_final
from (
    select 
        t6.*,
        max(t6.bads_cum) keep (dense_rank last order by t6.score_bal desc) over (partition by null)/max(t6.total_cum) keep (dense_rank last order by t6.score_bal desc) over (partition by null) bad_total,
        1-(max(t6.bads_cum) keep (dense_rank last order by t6.score_bal desc) over (partition by null)/max(t6.total_cum) keep (dense_rank last order by t6.score_bal desc) over (partition by null))/2-0.5 bad_total_2,
        sum(t6.total_sco) over (order by t6.score_bal desc) total_sco_cum,
        sum(t6.bad_sco) over (order by t6.score_bal desc) bad_sco_cum,
        sum(t6.gini) over (order by t6.score_bal desc) gini_cum
    from ( 
       
        select t5.*,
               t5.total_sco total_sco_x,
               ((t5.bad_sco + (lead(t5.bad_sco, 1, 0) over (order by t5.score_bal desc))) * (t5.total_sco - (lead(t5.total_sco, 1, 0) over (order by t5.score_bal desc))) ) / 2 gini
        from (
        
            select t4.*,
                   round(t4.total_cum_desc/max(t4.total_cum) keep (dense_rank last order by t4.score_bal desc) over (partition by null), 4) total_sco,
                   round(t4.bads_cum_desc/max(t4.bads_cum) keep (dense_rank last order by t4.score_bal desc) over (partition by null), 4) bad_sco,
                   case when t4.total_cum_desc < (max(t4.bads_cum) keep (dense_rank last order by t4.score_bal desc) over (partition by null)) then 0 else 0.999 end ideal_sco
            from (
            
                select t3.score_bal,
                       t3."0_CNT" goods,
                       t3."1_CNT" bads,
                       (t3."0_CNT" + t3."0_CNT") total,
                       sum(t3."0_CNT") over (order by t3.score_bal desc) goods_cum,
                       sum(t3."1_CNT") over (order by t3.score_bal desc) bads_cum,
                       sum(t3."0_CNT" + t3."1_CNT") over (order by t3.score_bal desc) total_cum,
                       sum(t3."0_CNT") over (order by t3.score_bal) goods_cum_desc,
                       sum(t3."1_CNT") over (order by t3.score_bal) bads_cum_desc,
                       sum(t3."0_CNT" + t3."1_CNT") over (order by t3.score_bal) total_cum_desc
                from 
                    (select tt.' || upper(in_coef_name) || ' score_bal,
                           tt.is_bad3
                    from (
                        select t.*
                        from ' || upper(in_source_tab) || ' t
                    ) tt
                ) pivot (
                    count(is_bad3) cnt
                    for is_bad3 in (0, 1)
                ) t3
                order by t3.score_bal desc
                    
            ) t4
            
        ) t5
        
    ) t6    

) t7';

  execute immediate v_sql into Result;
  
  return(Result);
exception when others then return -1;  
end get_gini_aapply;
/
grant execute on U1.GET_GINI_AAPPLY to DM;


