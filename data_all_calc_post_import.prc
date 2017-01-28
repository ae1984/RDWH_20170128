create or replace procedure u1.data_all_calc_post_import is
--v_seq      NUMBER(38); -- для отслеживания
v_total_debt  NUMBER(38);
v_yy_mm_start VARCHAR2(9);
--v_product VARCHAR2(8);
v_branch_name VARCHAR2(31);
v_contract_amount NUMBER(38);
v_start_date date;
begin
  
  for d in (
          select da.* from data_all_import da
    ) loop

    v_total_debt := null;
    v_yy_mm_start := null;
--    v_product := null;
    v_branch_name := null;
    v_contract_amount := null;

--  расчет v_total_debt  NUMBER(38);
    if (d.is_card = 0) then
       v_total_debt :=
            nvl(d.el_principal,0) +
            nvl(d.el_interest,0) +
            nvl(d.el_principal_del,0) +
            nvl(d.el_interest_del,0);
    elsif (d.is_card = 1) then
--       v_total_debt := nvl(d.cc_credit_limit,0) - nvl(d.cc_available_balance,0);
       v_total_debt :=
            nvl(d.cc_principal,0) +
            nvl(d.cc_principal_del,0) +
            nvl(d.cc_overlimit,0) +
            nvl(d.cc_overdraft,0) +
            nvl(d.cc_overlimit_del,0) +
            nvl(d.cc_overdraft_del,0) +
            nvl(d.cc_interest,0) +
            nvl(d.cc_interest_del,0);
    end if;

--  расчет v_product VARCHAR2(8);
--    select rp.product into v_product
--           from ref_products rp
--           where rp.product_program = d.product_programm;

--    if (v_product is null) then
--        v_product := 'UNKNOWN';
--    end if;

--  расчет v_branch_name VARCHAR2(31);
    if (d.branch_name is not null and d.branch_name != 'UNKNOWN') then
      select rb.new_branch into v_branch_name
             from ref_branch rb
             where rb.old_branch = d.branch_name;
    end if;

    if (v_branch_name is null) then
        v_branch_name := 'UNKNOWN';
    end if;

--  расчет v_contract_amount NUMBER(38);
    if (d.is_card = 1) then
      v_contract_amount := nvl(d.cc_credit_limit, 0);
    else
      v_contract_amount := d.contract_amount;
    end if;

--  расчет v_start_date date;
    if (d.is_card = 1 and d.start_date is null) then
      v_start_date := d.cc_contract_start_date;
    else
      v_start_date := d.start_date;
    end if;

--  расчет v_yy_mm_start VARCHAR2(9);
    v_yy_mm_start := to_char(v_start_date, 'yyyy - mm');
    
--  обновляем data_all_import
    update data_all_import set
      total_debt = v_total_debt,
      yy_mm_start = v_yy_mm_start,
--      product = v_product,
      branch_name = v_branch_name,
      contract_amount = v_contract_amount,
      start_date = v_start_date
    where id = d.id;

    commit;

--  увеличиваем sequence для отслеживания ------------------------------------
--    select data_all_calc_post_import_seq.nextval into v_seq from dual;

  end loop;

end data_all_calc_post_import;
/

