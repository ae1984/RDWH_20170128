create or replace force view u1.v_dwh_port_cards_credits_hd as
select
to_char(ca.cdhd_rep_date,'dd.mm.yyyy') as rep_date,
ca.cdhd_deal_number as contract_number,
ca.cdhd_pc_cred as PRINCIPAL,
ca.cdhd_pc_prc as INTEREST,
ca.cdhd_pc_overlimit as OVERLIMIT,
ca.cdhd_pc_overdraft as OVERDRAFT,
ca.cdhd_pc_ovrd_cred as OVERDUE_PRINCIPAL,
ca.cdhd_pc_ovrd_prc  as OVERDUE_INTEREST,
ca.cdhd_pc_ovrd_overlimit as OVERDUE_OVERLIMIT,
ca.cdhd_pc_ovrd_overdraft as OVERDUE_OVERDRAFT,
ca.cdhd_pc_vnb_ovrd_cred as w_principal_del,
ca.cdhd_pc_vnb_ovrd_overlimit as w_overlimit_del,
ca.cdhd_pc_vnb_ovrd_overdraft as w_overdraft_del,
ca.cdhd_pc_vnb_ovrd_prc_cred as w_interest_del
from DWH_DM_CARDSDAILY_HD_H ca
--where ca.cdhd_begin_date >= to_date(sysdate - 100,'dd.mm.yyyy')
where ca.cdhd_rep_date >= trunc(sysdate) - 100
union all
select
to_char(sp.exhd_rep_date,'dd.mm.yyyy') as rep_date,
sp.exhd_deal_number as contract_number,
sp.exhd_fgu_cred as PRINCIPAL,
sp.exhd_fgu_prc  as INTEREST,
null as overlimit,
null as overdraft,
sp.exhd_fgu_ovrd_cred as OVERDUE_PRINCIPAL,
sp.exhd_fgu_ovrd_prc as OVERDUE_INTEREST,
null as overdue_overlimit,
null as overdue_overdraft,
sp.exhd_vnb_ovrd_cred as w_principal_del,
null as w_overlimit_del,
null as w_overdraft_del,
coalesce(sp.exhd_vnb_ovrd_prc,0) + coalesce(sp.exhd_vnb_comm,0) as w_interest_del
from DWH_DM_SPGU_HD_H sp
--where sp.exhd_begin_date >= to_date(sysdate - 100,'dd.mm.yyyy')
where sp.exhd_rep_date >= trunc(sysdate) - 100
;
grant select on U1.V_DWH_PORT_CARDS_CREDITS_HD to FINAN;
grant select on U1.V_DWH_PORT_CARDS_CREDITS_HD to LOADDB;
grant select on U1.V_DWH_PORT_CARDS_CREDITS_HD to LOADER;


