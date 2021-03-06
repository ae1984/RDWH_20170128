﻿create or replace procedure u1.ETLT_T_TM_SOAP_NOTIFY
is
       s_table_name     varchar2(30) := 'T_TM_SOAP_NOTIFY';
       vStrDate         date := sysdate;

       d_src_commit_date_last date; --дата последней загруженной строки
       d_src_commit_date_load date; --дата, по которую делаем загрузку

      begin
        select max(change_date)
          into d_src_commit_date_load
          from U1.TM_SOAP_NOTIFY
         ;

        select max(change_date)-10/24/60/60
          into d_src_commit_date_last
          from U1.T_TM_SOAP_NOTIFY3;

        --

        delete from U1.T_TM_SOAP_NOTIFY3
         where  change_date between d_src_commit_date_last and d_src_commit_date_load;


--with T_TM_SOAP_NOTIFY_NEW as
insert /*+ append */into U1.T_TM_SOAP_NOTIFY3
(select FLD_002,
          pc.c_card_num as card_num,
          FLD_003,
          d2.operation_type as operation_type,
          FLD_004/100 as FLD_004,
          FLD_005,
          FLD_006,
          case when  substr(t.fld_054,5,3)='KZT' then FLD_006/100
               when  substr(t.fld_054,5,3)='EUR' and u.currency='EUR' then (FLD_006/100)*u.curs_value
               when  substr(t.fld_054,5,3)='USD' and u.currency='USD' then (FLD_006/100)*u.curs_value end as transaction_in_KZT,
          to_date(t.fld_007, 'yyyy.mm.dd hh24:mi:ss')as FLD_007,
          FLD_008,
          FLD_009,
          FLD_010,
          FLD_011,
          to_date(t.fld_012, 'yyyy.mm.dd hh24:mi:ss')as FLD_012,
          FLD_013,
          FLD_014,
          FLD_015,
          FLD_016,
          FLD_017,
          FLD_018,
          FLD_019,
          d3.country_name as country_name,
          FLD_020,
          FLD_021,
          FLD_022,
          FLD_023,
          FLD_024,
          FLD_025,
          FLD_026,
          FLD_027,
          to_date(t.fld_028, 'yyyy.mm.dd hh24:mi:ss')as FLD_028,
          FLD_029,
          FLD_030,
          FLD_031,
          FLD_032,
          FLD_033,
          FLD_034,
          FLD_035,
          FLD_036,
          FLD_037,
          FLD_038,
          FLD_039,
          d1.mssg as message,
          FLD_040,
          FLD_041,
          FLD_042,
          FLD_043,
          FLD_044,
          FLD_045,
          FLD_046,
          FLD_047,
          FLD_048,
          FLD_049,
          FLD_050,
          FLD_051,
          FLD_052,
          FLD_053,
          FLD_054,
          FLD_055,
          FLD_056,
          FLD_057,
          FLD_058,
          FLD_059,
          FLD_060,
          FLD_061,
          FLD_062,
          FLD_063,
          FLD_064,
          FLD_065,
          FLD_066,
          FLD_067,
          FLD_068,
          FLD_069,
          FLD_070,
          FLD_071,
          FLD_072,
          to_date(t.fld_073, 'yyyy.mm.dd hh24:mi:ss')as FLD_073,
          FLD_074,
          FLD_075,
          FLD_076,
          FLD_077,
          FLD_078,
          FLD_079,
          FLD_080,
          FLD_081,
          FLD_082,
          FLD_083,
          FLD_084,
          FLD_085,
          FLD_086,
          FLD_087,
          FLD_088,
          FLD_089,
          FLD_090,
          FLD_091,
          FLD_092,
          FLD_093,
          FLD_094,
          FLD_095,
          FLD_096,
          FLD_097,
          FLD_098,
          FLD_099,
          FLD_100,
          FLD_101,
          FLD_102,
          FLD_103,
          FLD_104,
          FLD_105,
          FLD_106,
          FLD_107,
          FLD_108,
          FLD_109,
          FLD_110,
          FLD_111,
          FLD_112,
          FLD_113,
          FLD_114,
          FLD_115,
          FLD_116,
          FLD_117,
          FLD_118,
          FLD_119,
          FLD_120,
          FLD_121,
          FLD_122,
          FLD_123,
          FLD_124,
          FLD_125,
          FLD_126,
          FLD_127,
          FLD_128,
          ACCUM_AMOUNT,
          STIP_ACCUM_AMOUNT_CRED,
          STIP_ACCUM_AMOUNT_NORM,
          IIA_DEAL_OWN,
          IIA_DEAL_WOFEE,
          IIA_DEAL_CREDIT,
          IIA_ACCOUNT_CREDIT_LIMIT/100 as IIA_ACCOUNT_CREDIT_LIMIT,
          IIA_ACCOUNT_INITIAL_AMOUNT,
          IIA_ACCOUNT_BONUS_AMOUNT,
          IIA_ACCOUNT_LOCKED_AMOUNT/100 as IIA_ACCOUNT_LOCKED_AMOUNT ,
          IIA_ACCOUNT_AVAILABLE_AMOUNT/100 as IIA_ACCOUNT_AVAILABLE_AMOUNT,
          IIA_ACCOUNT_AVAILABLE_AFTER/100 as IIA_ACCOUNT_AVAILABLE_AFTER,
          CALL_MODE,
          STAN_INTERNAL,
          CARD_TYPE,
          ROW_NUMB,
          REQUEST_DATE,
          BATCH_OWNER,
          MSG_TYPE,
          RSW_ACQ_BANK,
          RESIDENT,
          STIP_CLIENT_ID,
          IIA_CARD_PARAM_GRP_1,
          IIA_ACCOUNT_CCY,
          IIA_ACCOUNT_ID,
          STIP_FLD_102_BANK,
          CHANGE_DATE,
          t.id




from (select distinct *
      from U1.TM_SOAP_NOTIFY
      where change_date between d_src_commit_date_last and d_src_commit_date_load) t
left join U1.M_RBO_COURSES   u on u.date_recount = trunc(to_date(t.fld_012, 'yyyy.mm.dd hh24:mi:ss'))
                             and u.currency = substr(t.fld_054, 5, 3)
                             and u.currency in ('USD', 'EUR')
left join fld_039_discription d1 on d1.code=t.fld_039
left join fld_003_discription d2 on d2.code=t.fld_003
left join fld_019_discription d3 on d3.country_code=t.fld_019
left join u1.V_RBO_Z#KAS_PC_CARD pc on pc.c_acc_num=t.stip_fld_102_bank
                                    and substr(pc.c_card_num,'1','6')=substr(t.fld_002,'1','6')
                                    and substr(pc.c_card_num,'13','4')=substr(t.fld_002,'13','4')
                                    and t.stip_fld_102_bank is not null
                                    and pc.c_acc_num is not null
                                    and pc.c_card_num is not null
                                    and t.fld_002 is not null
                                    and length(pc.c_card_num)=16
                                    and substr(t.fld_014,3,2) = substr(to_char(pc.c_date_end, 'ddmmyyyy'),3,2)
                                    and substr(t.fld_014,1,2) = substr(to_char(pc.c_date_end,'ddmmyyyy'),7,2));


commit;

end ETLT_T_TM_SOAP_NOTIFY;
/

