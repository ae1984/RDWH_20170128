create or replace force view u1.v_folder_mo_sc_bal as
select t.rfolder_id,
       t.date_create,
       t.folder_id,
       t.sc_card_kn2,
       t.sc_card_knp1,
       t.sc_card_kn1,
       t.sc_card_ekt_8_fraud,
       t.sc_card_ekt_8_bw,
       t.sc_card_2_18_22,
       null sc_card_lkn_9,
       null sc_card_knp_backward,
       null sc_card_lkn_9_backward
from M_FOLDER_MO_SC_BAL_2013 t

union all
select t.rfolder_id,
       t.date_create,
       t.folder_id,
       t.sc_card_kn2,
       t.sc_card_knp1,
       t.sc_card_kn1,
       t.sc_card_ekt_8_fraud,
       t.sc_card_ekt_8_bw,
       t.sc_card_2_18_22,
       null sc_card_lkn_9,
       null sc_card_knp_backward,
       null sc_card_lkn_9_backward
from M_FOLDER_MO_SC_BAL_2014 t

union all
select t.rfolder_id,
       t.date_create,
       t.folder_id,
       t.sc_card_kn2,
       t.sc_card_knp1,
       t.sc_card_kn1,
       t.sc_card_ekt_8_fraud,
       t.sc_card_ekt_8_bw,
       t.sc_card_2_18_22,
       t.sc_card_lkn_9,
       t.sc_card_knp_backward,
       t.sc_card_lkn_9_backward
from M_FOLDER_MO_SC_BAL_2015 t

union all
select t.rfolder_id,
       t.date_create,
       t.folder_id,
       t.sc_card_kn2,
       t.sc_card_knp1,
       t.sc_card_kn1,
       t.sc_card_ekt_8_fraud,
       t.sc_card_ekt_8_bw,
       t.sc_card_2_18_22,
       t.sc_card_lkn_9,
       t.sc_card_knp_backward,
       t.sc_card_lkn_9_backward
from M_FOLDER_MO_SC_BAL_2016 t;
grant select on U1.V_FOLDER_MO_SC_BAL to LOADDB;
grant select on U1.V_FOLDER_MO_SC_BAL to LOADER;


