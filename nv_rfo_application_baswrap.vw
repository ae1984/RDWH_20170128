create or replace force view u1.nv_rfo_application_baswrap as
select /*- no_parallel*/
   rr.rfo_con_or_claim_id
   ,rr.rfo_con_claim_type
   ,rr.folder_con_date
   ,rr.folder_con_date_time
   ,rr.folder_id
   ,rr.contract_number
   ,rr.contract_amount
   ,rr.process_code
   ,rr.process_name
   --,rr.cp_c_point
   --,rr.c_kas_vid_delivery
   --,rr.cs_c_add_prop
   --,rr.product1
   --,rr.product_type1
   --,rr.fd_c_status_doc
   --,rr.client_ref
   ,rr.rfo_client_id
   ,rr.iin
   ,rr.rnn
   ,rr.product
   ,rr.product_type
   --,rr.ps_cancel
   --,rr.vr_cancel
   --,rr.mo_cancel
   --,rr.cp_cancel
   --,rr.mn_cancel
   --,rr.cl_cancel
   ,rr.cancel_type_point
   ,rr.is_point_active
   ,rr.is_credit_issued
   ,rr.is_aa_approved
   ,rr.delivery_type
   ,rr.bk_folder_id
   ,rr.is_bk_aa_approved
   ,rr.folder_date_create_mi
   ,rr.folder_id_first
   --,rr.cancel_prescoring
   --,rr.cancel_verificator
   --,rr.cancel_middle_office
   --,rr.cancel_cpr_aa
   --,rr.cancel_manager
   --,rr.cancel_client
   --,rr.cancel_controller
   ,rr.is_bk_aa_approved_max
   ,rr.cancel_prescoring
   ,case when rr.cancel_middle_office=1 then case when nvl(rr.cancel_prescoring,0)>0 then 0 else 1 end end cancel_middle_office
   ,case when rr.cancel_controller=1 then case when nvl(rr.cancel_prescoring,0)
                                                   +nvl(rr.cancel_middle_office,0)>0 then 0 else 1 end end cancel_controller
   ,case when rr.cancel_client=1 then case when nvl(rr.cancel_prescoring,0)
                                               +nvl(rr.cancel_middle_office,0)
                                               +nvl(rr.cancel_controller,0)>0 then 0 else 1 end end cancel_client
   ,case when rr.cancel_manager=1 then case when nvl(rr.cancel_prescoring,0)
                                                +nvl(rr.cancel_middle_office,0)
                                                +nvl(rr.cancel_controller,0)
                                                +nvl(rr.cancel_client,0)>0 then 0 else 1 end end cancel_manager
   ,case when rr.cancel_cpr_aa=1 then case when nvl(rr.cancel_prescoring,0)
                                               +nvl(rr.cancel_middle_office,0)
                                               +nvl(rr.cancel_controller,0)
                                               +nvl(rr.cancel_client,0)
                                               +nvl(rr.cancel_manager,0)>0 then 0 else 1 end end cancel_cpr_aa
   ,case when rr.cancel_verificator=1 then case when nvl(rr.cancel_prescoring,0)
                                                    +nvl(rr.cancel_middle_office,0)
                                                    +nvl(rr.cancel_controller,0)
                                                    +nvl(rr.cancel_client,0)
                                                    +nvl(rr.cancel_manager,0)
                                                    +nvl(rr.cancel_cpr_aa,0)>0 then 0 else 1 end end cancel_verificator
   ,case when rr.is_point_active=0
              and rr.is_credit_issued=0
              and nvl(rr.cancel_prescoring,0)
                 +nvl(rr.cancel_middle_office,0)
                 +nvl(rr.cancel_controller,0)
                 +nvl(rr.cancel_client,0)
                 +nvl(rr.cancel_manager,0)
                 +nvl(rr.cancel_cpr_aa,0)
                 +nvl(rr.cancel_verificator,0)=0 then 1
    end as cancel_undefined

   ,case when coalesce(rr.is_aa_approved, rr.is_bk_aa_approved_max) = 0 then 1
         when coalesce(rr.is_aa_approved, rr.is_bk_aa_approved_max) = 1 then 0
    end as is_aa_reject

from NM_RFO_APPLICATION_BAS rr
where not( rr.rfo_con_claim_type = 'CARD'
          and rr.folder_con_date >=to_date('30.06.2014','dd.mm.yyyy')
          and rr.product_code = 'KAS_PC_DOG' -- Револьверные карты
          and rr.tariff_plan_code = 'PRIVILEGE' -- Привелигированный
          and rr.process_code in ('KAS_AUTO_CRED_PRIV_PC',   -- Каспийский. Выдача автокредита на карту
                                  'KAS_CREDIT_CASH_PRIV_PC', --'КАСПИЙСКИЙ. ВЫДАЧА КРЕДИТА НАЛИЧНЫМИ НА КАРТУ',
                                  'OPEN_CRED_PRIV_PC' --'КАСПИЙСКИЙ. ВЫДАЧА КРЕДИТА НА КАРТУ'
                                 )
         )
      and rr.product_code <> 'INSURANCE' -- страховки не показываем
      and rr.product_code <> 'DEP_CARD'  -- КАРТА ВКЛАДЧИКА
      and not (nvl(rr.delivery_type,'NONE') = 'БК' and rr.rfo_con_claim_type <> 'CARD') -- по БК
                                                         -- (безопасный кредит/управляемый кредит) показываем только карту
                                                         -- подумать по признакам на договор

      and rr.is_credit_issued is not null
;
comment on column U1.NV_RFO_APPLICATION_BASWRAP.RFO_CON_OR_CLAIM_ID is 'Уникальный ID заявки или онлайн-заявки';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.RFO_CON_CLAIM_TYPE is 'Тип заявки (card,credit,claim)';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.FOLDER_CON_DATE is 'Дата создания заявки';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.FOLDER_CON_DATE_TIME is 'Дата и время создания заявки';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.FOLDER_ID is 'ID папки';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.CONTRACT_NUMBER is 'Номер кредитного договора';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.CONTRACT_AMOUNT is 'Запрашиваемая сумма';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.PROCESS_CODE is 'Код бизнес-процесса';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.PROCESS_NAME is 'Название бизнес-процесса';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.RFO_CLIENT_ID is 'Код клиента в РФО';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.IIN is 'ИИН клиента';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.RNN is 'РНН клиента';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.PRODUCT is 'Название продукта';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.PRODUCT_TYPE is 'Тип продукта';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.CANCEL_TYPE_POINT is 'Тип отказа (МО, АА/ЦПР/СБ, Клиент, Менеджер, Отказ, Контроллер)';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.IS_POINT_ACTIVE is 'Признак активности заявки (1,0)';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.IS_CREDIT_ISSUED is 'Признак выдачи кредита (1,0)';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.IS_AA_APPROVED is 'Признак одобрения АА (1,0)';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.DELIVERY_TYPE is 'Вид выдачи';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.BK_FOLDER_ID is 'Если вид выдачи = БК, то проставляем ID папки';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.IS_BK_AA_APPROVED is 'Если вид выдачи = БК, то проставляем признак одобрения автоандерайтинга (1,0)';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.FOLDER_DATE_CREATE_MI is 'Дата и время создания папки, обрезано до минут';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.FOLDER_ID_FIRST is 'ID первой папки в рамках одного Contract_number';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.IS_BK_AA_APPROVED_MAX is 'Признак одобрения 1 или 0 для набора с одинаковым Folder ID';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.CANCEL_PRESCORING is 'Признак отказа прескоринга (1,0,null)';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.CANCEL_MIDDLE_OFFICE is 'Признак отказа МО (1,0,null)';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.CANCEL_CONTROLLER is 'Признак отказа контроллера (1,0,null)';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.CANCEL_CLIENT is 'Признак отказа клиента (1,0,null)';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.CANCEL_MANAGER is 'Признак отказа менеджера (1,0,null)';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.CANCEL_CPR_AA is 'Признак отказа АА, ЦПР, СБ (1,0,null)';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.CANCEL_VERIFICATOR is 'Признак отказа верификатора (1,0,null)';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.CANCEL_UNDEFINED is 'Признак неизвестного отказа(1,0,null)';
comment on column U1.NV_RFO_APPLICATION_BASWRAP.IS_AA_REJECT is 'Признак отказа АА (1,0)';
grant select on U1.NV_RFO_APPLICATION_BASWRAP to LOADDB;


