create or replace function u1.GET_SOCIAL_PHONE (vIIN varchar2) return number is
  nPrc  number;

begin
  for cur in (
    select t.owner_iin as client_iin
      from (
            select p.shop_bin , p.owner_iin, min(p.ks_reg_date) as reg_d
              from u1.partner_info p
             group by p.shop_bin, p.owner_iin
           ) t
     where t.owner_iin = vIIN
  )
  loop
    if cur.client_iin is not null then
      select case when count(client) = 0 then 0 else round((count(case when tt.client_color = 'RED' then tt.client end) / count(client)) * 100, 2) end as prc_del
        into nPrc
        from (
              select t.*
                from RISK_UALIKHAN.V_RSON_PHONES_ALL_U t
               where t.phone in (
                                  select t2.phone
                                    from RISK_UALIKHAN.V_RSON_PHONES_ALL_U t2
                                   where t2.client = cur.client_iin
                                     and t2.link_info <> 'ОРГАНИЗАЦИЯ'
                                )
                 and t.client <> cur.client_iin
             ) tt;
      end if;
    end loop;
    return(nPrc);
    --dbms_output.put_line(nPrc);
end;
/

