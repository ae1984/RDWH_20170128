create or replace procedure u1.ETLT_RFO_Z_PKB_REPORT
  is
   s_mview_name     varchar2(30) := 'T_RFO_Z#PKB_REPORT';
   vStrDate         date := sysdate;
   d_date_start_ins date; --дата логирования инсерта

   d_src_commit_date_last date; --дата последней загруженной строки
   d_src_commit_date_load date; --дата, по которую делаем загрузку

  begin
   select max(src_commit_date)  into d_src_commit_date_load from s01.s$Z#PKB_REPORT@rdwh_exd;

   select last_date-10/24/60/60 into d_src_commit_date_last
   from t_rdwh_increment_tables_load
   where object_name = 'T_RFO_Z#PKB_REPORT';
   --
   delete from T_RFO_Z#PKB_REPORT
   where id in (select distinct id
                from s01.s$Z#PKB_REPORT@rdwh_exd
                where src_commit_date between d_src_commit_date_last and d_src_commit_date_load
               );
   insert into T_RFO_Z#PKB_REPORT
   select
        id,
        c_status,
        c_rnn,
        c_sic,
        c_dateofbirth,
        upper(trim(c_gender)) as c_gender,
        c_education,
        c_matrialstatus,
        c_fiuniquenumberid,
        upper(trim(c_surname)) as c_surname,
        upper(trim(c_name)) as c_name,
        upper(trim(c_fathersname)) as c_fathersname,
        upper(trim(c_birthname)) as c_birthname,
        c_cityofbirth,
        c_regionofbirth,
        c_countryofbirth,
        c_registrationid,
        c_street,
        c_city,
        c_zipcode,
        c_region,
        c_addressinserted,
        c_number_house,
        c_b_classification,
        c_resident,
        c_s_position,
        c_citizenship,
        c_s_employment,
        c_f_citizenship,
        c_eag,
        c_nsoc,
        c_nsoa,
        c_contactinfo,
        c_dateofrptissue,
        c_si_noec,
        c_si_tod,
        c_si_notc,
        c_si_tdo,
        c_si_nora,
        c_si_noi,
        c_patent,
        c_agre_statuses,
        c_ci,
        c_rpt_type,
        c_si_debtor#noec#total,
        c_si_debtor#noec#instalment_cr,
        c_si_debtor#noec#cards,
        c_btor#noec#noninstalment_cr47,
        c_si_debtor#notc#total,
        c_si_debtor#notc#instalment_cr,
        c_si_debtor#notc#cards,
        c_btor#notc#noninstalment_cr51,
        c_si_debtor#nora#total,
        c_si_debtor#nora#instalment_cr,
        c_si_debtor#nora#cards,
        c_btor#nora#noninstalment_cr55,
        c_si_debtor#tod#total,
        c_si_debtor#tod#instalment_cr,
        c_si_debtor#tod#cards,
        c_ebtor#tod#noninstalment_cr59,
        c_si_debtor#tdo#total,
        c_si_debtor#tdo#instalment_cr,
        c_si_debtor#tdo#cards,
        c_ebtor#tdo#noninstalment_cr63,
        c_si_debtor#noi,
        c_si_debtor#noi_1,
        c_si_debtor#noi_2,
        c_si_debtor#noi_3,
        c_si_guarantor#noec#total,
        c_arantor#noec#instalment_cr69,
        c_si_guarantor#noec#cards,
        c_ntor#noec#noninstalment_cr71,
        c_si_guarantor#notc#total,
        c_arantor#notc#instalment_cr73,
        c_si_guarantor#notc#cards,
        c_ntor#notc#noninstalment_cr75,
        c_si_guarantor#nora#total,
        c_arantor#nora#instalment_cr77,
        c_si_guarantor#nora#cards,
        c_ntor#nora#noninstalment_cr79,
        c_si_guarantor#tod#total,
        c_uarantor#tod#instalment_cr81,
        c_si_guarantor#tod#cards,
        c_antor#tod#noninstalment_cr83,
        c_si_guarantor#tdo#total,
        c_uarantor#tdo#instalment_cr85,
        c_si_guarantor#tdo#cards,
        c_antor#tdo#noninstalment_cr87,
        c_si_guarantor#noi,
        c_si_guarantor#noi_1,
        c_si_guarantor#noi_2,
        c_si_guarantor#noi_3,
        c_id_doc_arr,
        c_closed_ci,
        c_dop_field,
        c_pkb_report_ref,
        c_error_status,
        c_rep_source,
        c_si_subj_role
   from s01.Z#PKB_REPORT@rdwh_exd
   where id in (select distinct id
                from s01.s$Z#PKB_REPORT@rdwh_exd
                where src_commit_date between d_src_commit_date_last and d_src_commit_date_load
               );
   commit;
   --сохраняем информацию о послeдней загрузке
   update t_rdwh_increment_tables_load
      set last_date = d_src_commit_date_load
   where object_name = 'T_RFO_Z#PKB_REPORT';
   commit;


   end ETLT_RFO_Z_PKB_REPORT;
/

