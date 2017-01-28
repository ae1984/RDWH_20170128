CREATE OR REPLACE PROCEDURE U1."ETLT_KASPIKZ_TRANSF_TRANSFER"
 is
 vStrDate date := sysdate;
 s_mview_name     varchar2(30) := 'T_KASPIKZ_TRANSF_TRANSFER';
 d_src_commit_date_load date;
 d_src_commit_date_last date;
  begin
      select max(src_commit_date)
        into d_src_commit_date_load
        from s37.s$tb_Transfers_Transfer@rdwh_exd;

      select last_date-10/24/60/60
        into d_src_commit_date_last
        from t_rdwh_increment_tables_load
       where object_name = s_mview_name;

        delete from T_KASPIKZ_TRANSF_TRANSFER
         where id in (select distinct id
                        from s37.s$tb_Transfers_Transfer@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);

        insert into T_KASPIKZ_TRANSF_TRANSFER
            select id,
                    depositagreementid,
                    agreementid,
                    cardid,
                    transfersum,
                    currency,
                    externalid,
                    createdatetime,
                    acceptdatetime,
                    lastmodificationdatetime,
                    declareid,
                    isstate,
                    endstate,
                    cast(substr(statedescription,1,4000) as varchar2(4000)),
                    tarifsum,
                    senderaccountsaldo,
                    receiveraccountsaldo,
                    rate,
                    depart,
                    userid,
                    olddepositagreementid,
                    oldcardid,
                    ispaymenttransfer,
                    oldrecieverdepositagreementid,
                    paymentid,
                    sourceaccountid,
                    destinationaccountid/*,
                    transfervector,
                    sourcetransfersum,
                    sourcecurrency,
                    exchangerateid*/
          from s37.tb_Transfers_Transfer@rdwh_exd
        where id in (select distinct id
                        from s37.s$tb_Transfers_Transfer@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
        commit;
        --сохраняем информацию о послeдней загрузке
        update t_rdwh_increment_tables_load
           set last_date = d_src_commit_date_load
         where object_name = s_mview_name;
        commit;

 end ETLT_KASPIKZ_TRANSF_TRANSFER;
/

