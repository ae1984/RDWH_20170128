create or replace procedure u1.ETLT_KASPIKZ_PAY_PAY_INFO
 is
 vStrDate date := sysdate;
 s_mview_name     varchar2(30) := 'T_KASPIKZ_PAY_PAY_INFO';
 d_src_commit_date_load date;
 d_src_commit_date_last date;
  begin
      select max(src_commit_date)
        into d_src_commit_date_load
        from s37.s$LOG_HTTPREQUEST@rdwh_exd;

      select last_date-10/24/60/60
        into d_src_commit_date_last
        from t_rdwh_increment_tables_load
       where object_name = s_mview_name;

        delete from T_KASPIKZ_PAY_PAY_INFO
         where id in (select distinct bintid
                        from s37.s$TB_PAYMENTS_PAYMENTINFO@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);

        insert into T_KASPIKZ_PAY_PAY_INFO
        select bintid as id,
              bintuserid as user_id,
              intserviceid as service_id,
              bintsubscriptionid as subscription_id,
              cast(vchposterminalid as varchar2(200)) as pos_terminal_id,
              dtregdate as reg_date,
              dcmamount as amount,
              dcmfee as amount_fee,
              cast(vchcurrency as varchar2(24)) as currency,
              bintaccountid as account_id,
              intaccountsimpleid as account_simple_id,
              cast(vchaccounttype as varchar2(80)) as account_type,
              cast(vchaccountname as varchar2(200)) as account_name,
              cast(vchbankreference as varchar2(200)) as bank_reference,
              intbankresultcode as bank_result_code,
              cast(vchbankpaymentid as varchar2(200)) as bank_payment_id,
              cast(vchbankauthref as varchar2(200)) as bank_auth_ref,
              cast(vchprovreference as varchar2(200)) as prov_reference,
              intprovresultcode as prov_result_code,
              intprovstatuscode as prov_status_code,
              intpaymenttype as payment_type,
              cast(description as varchar2(1000)) as descr,
              cast(vchdepositaccountnumber as varchar2(200)) as deposit_account_number,
              intdepositaccountsimpleid as deposit_account_simple_id,
              bintolddepositaccountid as old_deposit_account_id,
              binttransferid as transfer_id,
              bitisofflinepayment as is_offline_payment,
              intecommresultcode as ecomm_result_code,
              cast(vchecommpaymentid as varchar2(200)) as ecomm_payment_id,
              bitis3ds as is_3ds,
              cast(vchhostname as varchar2(200)) as host_name,
              bonusamount as bonus_amount,
              bintglobalpaymentid as global_payment_id,
              intcurrentpaymentinfohistoryty as cur_pay_inf_hist,
              case when t.intcurrentpaymentinfohistoryty in (18,41) then 1
                   when t.intcurrentpaymentinfohistoryty is null and t.intbankresultcode = 0 and t.intprovresultcode = 0 and t.intprovstatuscode = 0 then 1
                   else 0 end as is_prov,
              bintsessionid as session_id,
              bintdeviceid  as device_id
        from s37.TB_PAYMENTS_PAYMENTINFO@rdwh_exd t
        where bintid in (select distinct bintid
                         from s37.s$TB_PAYMENTS_PAYMENTINFO@rdwh_exd
                         where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
        commit;
        --сохраняем информацию о послeдней загрузке
        update t_rdwh_increment_tables_load
           set last_date = d_src_commit_date_load
         where object_name = s_mview_name;
        commit;
 end ETLT_KASPIKZ_PAY_PAY_INFO;
/

