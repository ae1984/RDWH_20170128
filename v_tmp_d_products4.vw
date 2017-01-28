create or replace force view u1.v_tmp_d_products4 as
select
cr_program_name,
contract_number,
pos_code,
POS_NAME,
start_month,
begin_date,
contract_term_days,
actual_end_date,
CONTRACT_TERM_Months,
PRODUCER,
product_name,
product_model,
quantity,
goods_cost,
BILL_SUM,
goods_price,
contract_amount,
product_type_name,
client_rnn,
client_iin,
client_name,
RFO_SHOP_ID,
SHOP_CODE,
shop_name,
city_name,
fil_name,
unp_name,
goods_id,
servise_id,
INITIAL_PAYMENT,
product_name_modified,
case
when product_name_modified='152СМ, BARKAN, BLACK (34L.B)' then  'КРЕПЛЕНИЕ ДЛЯ ТВ'
when product_name_modified='00 ЭПИЛЯТОР PHILIPS' then 'ЭПИЛЯТОР PHILIPS'
when product_name_modified in ('040 90 122 КРЫШКА 22 СМ. TEFAL','040 90 122 КРЫШКА 22 СМ. TEFAL','040 90 124 КРЫШКА 24 СМ. TEFAL''040 90 126 КРЫШКА 26 СМ. TEFAL',
 '040 90 128 КРЫШКА 28 СМ. TEFAL')  then 'КРЫШКА TEFAL'
when product_name_modified='108401 14M СУШИЛКА ДЛЯ БЕЛЬЯ ELENBERG' then 'СУШИЛКА ДЛЯ БЕЛЬЯ ELENBERG'
when product_name_modified='1605553N2 1:16 NISSAN 350Z С РЕЗИНОЙ ДЛЯ ДРИФТА' then 'NISSAN С РЕЗИНОЙ ДЛЯ ДРИФТА'
when product_name_modified='2 BLACK(31300700102=)КЛАВИАТУРА GENIUS' then 'КЛАВИАТУРА GENIUS'
when product_name_modified in ('203СМ, BARKAN, BLACK (E40B)','66СМ, BARKAN, BLACK (E130B)', '94СМ, BARKAN, BLACK (E230B)') then 'КРЕПЛЕНИЕ ДЛЯ ТВ'
when product_name_modified='25' then 'ОТПАРИВАТЕЛЬ ДЛЯ ОДЕЖДЫ PHILIPS'
when product_name_modified='260053 ШТОПОР С КРЫЛЬЯМИ PROVENCE' then 'ШТОПОР С КРЫЛЬЯМИ PROVENCE'
when product_name_modified='260828 ПИЦЦЕРЕЗКА PROVENCE' then 'ПИЦЦЕРЕЗКА PROVENCE'
when product_name_modified='261200 ДЕРЖАТЕЛЬ ДЛЯ НОЖЕЙ PROVENCE' then 'ДЕРЖАТЕЛЬ ДЛЯ НОЖЕЙ PROVENCE'
when product_name_modified in ('270073 ДУРШЛАГ 1,5Л. TORO','270104 ДУРШЛАГ 20 СМ. TORO') then 'ДУРШЛАГ'
when product_name_modified='2ГАЗ+2ЭЛ. ПЛИТА GORENJE' then 'ПЛИТА GORENJE'
when product_name_modified='3' then 'ТУМБА ALTEX TV'
when product_name_modified in ('4 БЛЮДО ОВАЛЬНОЕ 30Х21СМ','4 БЛЮДО ОВАЛЬНОЕ 39Х27СМ','6 БЛЮДО ПРЯМОУГОЛЬНОЕ 35Х22 СМ.','6 БЛЮДО ПРЯМОУГОЛЬНОЕ 39Х25 СМ.', '7 БЛЮДО ПРЯМОУГОЛЬНОЕ 33Х20 СМ.') then 'БЛЮДО ОВАЛЬНОЕ'
when product_name_modified in ('416153 (КРАСНЫЙ,ПЛАСТИКОВЫЙ)  X-DORIA','5S (БЕЛЫЙ, ПЛАСТИКОВЫЙ)','5S (ЗОЛОСТИСТЫЙ, ПЛАСТИКОВЫЙ)','5S (КРАСНЫЙ, ПЛАСТИКОВЫЙ)','5S (ЧЕРНЫЙ ПОЛУПРОЗРАЧНЫЙ, ПЛАСТИКОВЫЙ)',
 '5S (ЧЕРНЫЙ, КОЖАНЫЙ)','D1-YW)','HAPPY DAY (YOMA)','LP CASES 1050 (LIFEPROOF - BELKIN)', 'ULTRATHIN BLUE F8W300VFC01 (BELKIN)','МИРОВЫЕ СИМВОЛЫ (YOMA)', 'РАДУГА (YOMA)',
 'СЕРЫЙ, ПЛАСТИКОВЫЙ)', 'ЦВЕТЫ НА БЕЛОМ ФОНЕ (YOMA)', 'ЧЕРНЫЙ, ПЛАСТИКОВЫЙ)')  then 'ЧЕХЛЫ ДЛЯ IPHONE'
when product_name_modified in ('64 RUSSIAN FOR KAZAKHSTAN ON','64 RUSSIAN FOR KAZAKHSTAN ONLY DVD5') then 'RUSSIAN FOR KAZAKHSTAN'
when product_name_modified='81092 1:16 МАШИНКА  VUDOO' then 'МАШИНКА  VUDOO'
when product_name_modified='8594157620270 СУХОЙ ПОРОШОК ALPIN UNIVERSAL BOX 1КГ*3' then 'СУХОЙ ПОРОШОК'
when product_name_modified='90БЛЕНДЕР PHILIPS' then 'БЛЕНДЕР PHILIPS'
when product_name_modified in ('A5500 3G (16GB) BLUE  ПЛАНШЕТ LENOVO','A5500-H 3G (16GB) BLUE  ПЛАНШЕТ LENOVO') then 'ПЛАНШЕТ LENOVO'
when product_name_modified='ACCPV ACTION' then 'ВИДЕОКАМЕРА'
when product_name_modified='BILLI' then 'ДОСКА РАЗДЕЛОЧНАЯ'
when product_name_modified in ('BLACK','BLACK (SM-P6010ZKESKZ)', 'WHITE (SM-T3110ZWASKZ)') then 'TAB SAMSUNG'
when product_name_modified='BRACKET (LG075050) КРОНШТЕЙН ДЛЯ LEDN29K316L' then 'LG - КРОНШТЕЙН'
when product_name_modified='BUFF' then 'ЗАЩИТНАЯ ПЛЕНКА ДЛЯ SAMSUNG GALAXY'
when product_name_modified='BWT' then 'ПЕЧЬ SAMSUNG'
when product_name_modified in ('C13S042201 GLOSSY PHOTO PAPER  10X15СМ. 500 ЛИСТОВ','M') then 'GLOSSY PHOTO PAPER'
when product_name_modified='CALGONIT' then 'СРЕДСТВА ДЛЯ ПОСУДОМ./СТИРАЛЬНЫХ МАШИН'
when product_name_modified='CASSETTI' then 'НАБОР ДЛЯ ПРОДУКТОВ'
when product_name_modified in ('CCF-240G.AGEUWH БЕЛЫЙ LG', 'CCH-220.AGEUBK ЧЕРНЫЙ LG') then 'ЧЕХЛЫ ДЛЯ LG'
when product_name_modified='CD-RW ACME' then 'CAKE BOX'
when product_name_modified='CQ58-D56SR CI3 4GB 500 INTEL HD WIN (D9X79EA) НОУТБУК HP' then 'НОУТБУК HP'
when product_name_modified='D8210412 СКОВОРОДА 24СМ. TEFAL' then 'СКОВОРОДА TEFAL'
when product_name_modified='DVDRW)' then 'СИСТЕМНЫЙ БЛОК NEO GAME'
when product_name_modified in ('E1-572G 15,6 CI3 6GB 1000GB M240 1GB WIN8 (NX.MJLER.018) НОУТБУК ACER','E1-572G 15,6 CI3 6GB 750GB M265 2GB WIN8 (NX.MJRER.004) НОУТБУК ACER',
'E1-572G 15,6 CI7 6GB 1000GB M265 2GB DOS (NX.MJRER.005) НОУТБУК ACER', 'E1-771G 15,6 CI5 4GB 1000GB GT710M 1GB WIN8 (NX.MG5ER.013) НОУТБУК ACER' ,
'E5-571 15,6 CI3 4GB 1000GB INT WIN8 (NX.ML8ER.007) НОУТБУК ACER','E5-571G 15,6 CI5 6GB 1000GB GF820M 1GB WIN8 (NX.MLBER.010) НОУТБУК ACER') then 'НОУТБУК ACER'
when product_name_modified='FILTERO' then 'ШАМПУНЬ ДЛЯ ПЫЛЕСОСОВ'
when product_name_modified='GC2965 УТЮГ PHILIPS' then 'УТЮГ PHILIPS'
when product_name_modified='JABRA' then 'BLUETOOTH ГАРНИТУРА JABRA'
when product_name_modified='KZ' then 'SAMSUNG МОНИТОР/ФОТОАППАРАТ'
when product_name_modified='LG' then 'LG ЧЕХЛЫ/ЗАРЯДКА'
when product_name_modified in ('LTHR,SG MEGA 5.8,BLKTP','LTHR,SG MEGA 6.3,BLKTP') then 'COVER/OTHER'
when product_name_modified in ('S2 PLUS I9105 (БЕЛЫЙ, ГЕЛЕВЫЙ)', 'ГОЛУБОЙ ХАМЕЛЕОН (GIMI)','ПЛАСТИКОВЫЙ, ЧЕРНЫЙ) YTX-CC-SGS9300G', 'ЧЕРНЫЙ SAMSUNG') then 'SAMSUNG ЧЕХЛЫ'
when product_name_modified='STARK' then 'СЗУ/АЗУ NOKIA/MOTOROLA/LG/SAMSUNG/SONYERICSSON'
when product_name_modified='SULPAK' then 'СБЕРЕГАТЕЛЬНАЯ КАРТА БОНУС/SULPAK'
when product_name_modified='TEFAL' then  'TEFAL СКОВОРОДА/КОВШ'
when product_name_modified='TEXET' then 'MP3 ПЛЕЕР'
when product_name_modified='TOPPER' then 'ТУРБОЩЕТКА/ФИЛЬТР И АРОМАТИЗАТОР ПЫЛЕСОСА/НОЖ ДЛЯ МЯСОРУБОК TOPPER'
when product_name_modified='TORO' then 'ТЕРМОС/ТЕРМОКРУЖКА/СИТО TORO'
when product_name_modified='ULV APPLE' then 'IPAD 2 WI-FI'
when product_name_modified in ('V5-561G 15,6 CI3 4GB 1000GB M265 2GB WIN8 (NX.MK9ER.024) НОУТБУК ACER','V5-573G 15,6 CI7 8GB 1000GB GT 750M 4GB WIN8 (NX.MCCER.006) НОУТБУК ACER' )
  then 'НОУТБУК ACER'
when product_name_modified in ('X550LB 15,6 CI7 8GB 1000GB NVGT7402GB WIN8 (90NB02G2-M03570) НОУТБУК ASUS','X552CL 15,6 CI5 4GB 500GB NV710M1GB DOS (90NB03WB-M03160) НОУТБУК ASUS',
 'X552CL 15,6 PEN 4GB 500GB NV710M1GB DOS (90NB03WB-M02900) НОУТБУК ASUS') then 'НОУТБУК ASUS'
when product_name_modified='А' then 'СТИРАЛЬНАЯ МАШИНА'
when product_name_modified='VERTEX' then 'VERTEX КАБЕЛЬ/АДАПТЕР/USB'
when product_name_modified='W' then 'NOTEBOOK SONY'
when product_name_modified in ('КР 16 СМ 1,7 Л TERRAKOTTE RONDELL','КР 20 СМ 3,2 Л TERRAKOTTE RONDELL', 'КР 20 СМ TERRAKOTTE RONDELL','КР 24 СМ EIS RONDELL','КР 24 СМ TERRAKOTTE RONDELL','КР 24 СМ.RONDELL','КР 26 СМ EIS RONDELL',
  'КР 28 СМ EIS  RONDELL','КР 28 СМ TERRAKOTTE RONDELL') then 'RONDELL КОВШ/КАСТРЮЛЯ/СКОВОРОДА'
when product_name_modified='КР, КРУГЛ.0,75Л' then 'АРКОСИН КАСТРЮЛЯ'
when product_name_modified='ПОДАРОК NIKON' then 'NIKON ФУТБОЛКА/КЕПКА/КОВРИК'
when product_name_modified='СЗУ VERTEX' then 'СЗУ IPHONE 5/СЗУ VERTEX'
when product_name_modified='СХВАТКА (RUS) PS3' then 'FIGHT/СХВАТКА (RUS) PS3'
when product_name_modified='У 1:16 ФОРСАЖ 5 - TOYOTA SUPRA  С РЕЗИНОЙ ДЛЯ ДРИФТА' then 'TOYOTA SUPRA  С РЕЗИНОЙ ДЛЯ ДРИФТА'
when product_name_modified='ФАКСАМ' then 'РАСХОДНЫЕ МАТЕРИАЛЫ К ТЕЛЕФОНАМ/ФАКСАМ'
when product_name_modified='ЩЁТКАTHOMAS' then 'THOMAS ТУРБОЩЕТКА'
            else product_name_modified end as product_name_modified2
from v_tmp_d_products3 p1;
grant select on U1.V_TMP_D_PRODUCTS4 to LOADDB;
grant select on U1.V_TMP_D_PRODUCTS4 to LOADER;


