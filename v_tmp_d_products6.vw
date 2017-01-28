create or replace force view u1.v_tmp_d_products6 as
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
product_name_modified2,
case when product_name_modified2 in ('"CЕРДЦА  ПИКАССО" (YOMA)','"АЛЫЕ ЦВЕТЫ" (YOMA)','"СИРЕНЕВЫЕ РОЗЫ" (YOMA)') then 'YOMA PRODUCTS'

when product_name_modified2 like '%ЕМКОСТЬ%' then 'ЕМКОСТЬ ДЛЯ ПРОДУКТОВ'
when product_name_modified2 like '%ДУРШЛАГ%' then 'ДУРШЛАГ'
when product_name_modified2 like '%МИСКА%' then 'МИСКА ДЛЯ МИКСЕРА'
when product_name_modified2 like '%КРЫШКА%TEFAL%' then 'ПОСУДА TEFAL'
when product_name_modified2 in ('16GB + WORLD OF TANKS НАКОПИТЕЛЬ KINGSTON','ACCCOMP FLASH MEMORY ФЛЭШ ПАМЯТЬ','ACCCOMP КАРТЫ ПАМЯТИ И РИДЕРЫ',
 'ACCCOMP ФЛЭШ НАКОПИТЕЛИ') or product_name_modified2 like '%FLASH%' then 'FLASH CARD'
when product_name_modified2 in ('32 К АВТОПАКЕТ 10ГБ NIGHT + USB МОДЕМ MF190','3G РОУТЕР BEELINE','ACCGSM ТАРИФНЫЕ ПЛАНЫ И СИМ КАРТЫ','BEELINE','ALTEL') then 'ПРОДУКТЫ МОБИЛЬНОЙ СВЯЗИ'
when product_name_modified2 in ('3D-КАМЕРА LG (ПОДАРОК)') then '3D-КАМЕРА'
when product_name_modified2 like '%3D%ОЧКИ%' or  product_name_modified2 like '%ОЧКИ%3D%' then '3D-ОЧКИ'
when product_name_modified2 in ('3ГАЗ+1ЭЛ.ПЛИТА GORENJE') then 'ЭЛЕКТРИЧЕСКАЯ ПЛИТА'
when product_name_modified2 in ('6 РОЗЕТОК DEFENDER')  then '6 РОЗЕТОК'
when product_name_modified2 in ('6 ФОРМА Д. ВЫПЕЧКИ. 30 СМ.','CAKE BOX','CD TDK CAKE BOX (10ШТ.)','CD TDK CAKE BOX (25ШТ.)') then 'ФОРМА ДЛЯ ВЫПЕЧКИ'

when product_name_modified2 in ('ACCCE AV БЫТ ХИМИЯ','ACCCOMP БЫТ ХИМИЯ','ALPIN','CКРЕБОК ДЛЯ ЧИСТКИ ПЛИТ MAGIC POWER',
  'FB ТАБЛЕТКИ ДЛЯ ПОСУДОМОЕЧНЫХ МАШИН 60 ШТ.','FINISH QUANTUM POWERBALL ТАБЛЕТКИ ДЛЯ ПОСУДОМОЕЧНЫХ МАШИН 20 ТАБ',
  'FINISH БЛЕСК+ЭКСПРЕСС СУШКА ОПОЛАСКИВАТЕЛЬ ДЛЯ ПОСУД.МАШ.400МЛ','FINISH МОЮЩЕЕ СР-ВО ДЛЯ ПОСУДОМОЕЧНЫХ МАШИН 1 КГ 000052-075W') then 'БЫТОВАЯ ХИМИЯ'

when product_name_modified2 like '%КАБЕЛ%' then 'КАБЕЛЬ'
when product_name_modified2 like '%КРЕПЛЕН%' then 'TB КРЕПЛЕНИЯ'
when product_name_modified2 in ('ACCCE TB ТУМБЫ') then 'TB ТУМБЫ'
when product_name_modified2 in ('ACCCE БАТАРЕИ, ЗАРЯДКИ И ФОНАРИ') then 'БАТАРЕИ, ЗАРЯДКИ И ФОНАРИ'
when product_name_modified2 in ('ACCCE МЕДИА','ACCCE МИКРОФОНЫ','ACCCE ПУЛЬТЫ ДУ','ACCCOMP ACTION','BLU RAY КИНОТЕАТР') then 'DIGITAL PRODUCTS'
when product_name_modified2 in ('ACCPV ВСПЫШКИ','ACCPV ОБЪЕКТИВЫ','ACCPV АКСЕССУАРЫ ДЛЯ ФОТО-ВИДЕО','ACCPV ФОТОРАМКИ','ACCPV ШТАТИВЫ',
  'GLOSSY PHOTO PAPER') then 'ФОТО АКСЕССУАРЫ'
when product_name_modified2 like '%ПОСУДА%' or product_name_modified2 like '%ПОСУДЫ%' or product_name_modified2 like '%CКОВОРОДА%'
  or product_name_modified2 like '%НОЖ%' then 'ПОСУДА'

when product_name_modified2 in ('APPLE','ACCCOMP АКСЕССУАРЫ ДЛЯ APPLE' ) then 'АКСЕССУАРЫ ДЛЯ APPLE'
when product_name_modified2 in ('ACCMDA АКСЕССУАРЫ ДЛЯ ПЛИТ','ACCMDA АКСЕССУАРЫ ДЛЯ СТИРАЛЬНЫХ МАШИН','ACCMDA АКСЕССУАРЫ ДЛЯ ХОЛОДИЛЬНИКОВ','ACCMDA КОРЗИНЫ ДЛЯ БЕЛЬЯ',
  'ACCMDA ФИЛЬТРЫ ДЛЯ ВЫТЯЖКИ','ACCSDA АКСЕССУАРЫ ДЛЯ ПЫЛЕСОСОВ','ACCSDA ЗАПАСНЫЕ ЧАСТИ/РАСХОДНЫЕ МАТЕРИАЛЫ ДЛЯ КОНДИЦИОНЕРОВ',
  'ACCSDA РАСХОДНЫЕ МАТЕРИАЛЫ ДЛЯ ОЧИСТИТЕЛЕЙ/УВЛАЖНИТЕЛЕЙ ВОЗДУХА','ACCSDA ЧАСЫ НАСТЕННЫЕ','FILTERO АНТИВИБРАЦИОННЫЕ ПОДСТАВКИ ДЛЯ СТИРАЛЬНЫХ МАШИН (909)') then 'АКСЕССУАРЫ БЫТОВОЙ ТЕХНИКИ'
when product_name_modified2 in ('ACCCOMP КОМПЬЮТЕРНЫЕ КОЛОНКИ','ACCCOMP МЫШКИ','ACCCOMP НАУШНИКИ','ACCGSM АУДИО СТАНЦИИ ДЛЯ МОБИЛЬНЫХ УСТРОЙСТВ',
  'ACCGSM ЗАЩИТНЫЕ НАКЛЕЙКИ','ACCGSM ЗАЩИТНЫЕ ПЛЕНКИ','ACCGSM ЭЛЕМЕНТЫ ПИТАНИЯ','BLUETOOTH ГАРНИТУРА JABRA','BLUETOOTH-НАУШНИКИ PLANTRONICS','DC',
  'DDR','HEADPHONE','HEADPHONE + MIC GENIUS','HI-FI','HTC','HTC BLUETOOTH HEADSET MINI+','KОЛОНКИ SVEN')  or product_name_modified2 like '%АКСЕССУАР%'
   then 'АКСЕССУАРЫ (action)'

when product_name_modified2 in ('ACCCOMP ВЕБ КАМЕРЫ') then 'ВЕБ КАМЕРЫ'
when product_name_modified2 in ('ACCCOMP ВНЕШНИЕ ЖЕСТКИЕ ДИСКИ') then 'ВНЕШНИЕ ЖЕСТКИЕ ДИСКИ'
when product_name_modified2 in ('CD CHANGER','CD PLAYER') or product_name_modified2 like '%ПРОИГРЫВ%' then 'ПРОИГРЫВАТЕЛИ'
when product_name_modified2 like '%ГЕЙМИНГ%' or product_name_modified2 like '%ИГРА%'   or product_name_modified2 like '%ИГРЫ%'
  or product_name_modified2 in ('FIFA 14 PS4','FIGHT/СХВАТКА (RUS) PS3','GRAN TURISMO 5 (RUS)  PS3','KILLZONE В ПЛЕНУ СУМРАКА (RUS) PS4','KIMPLER',
  'KINECT JOY RIDE X-BOX 360','KITFORT') then 'GAMING'
when product_name_modified2 in ('ACCCOMP ИГРУШКИ') then 'ИГРУШКИ'
when product_name_modified2 in ('ACCCOMP ИНСТРУМЕНТЫ') then 'ИНСТРУМЕНТЫ'
when product_name_modified2 in ('ACCCOMP КЛАВИАТУРЫ') then 'КЛАВИАТУРЫ'
when product_name_modified2 like '%МЕБЕЛ%' or product_name_modified2 like '%ГАРНИТУР%' or product_name_modified2 in ('GOSR_NABOR') then 'МЕБЕЛЬ'
when product_name_modified2 in ('ACCCOMP МЕДИА НОСИТЕЛИ') then 'МЕДИА НОСИТЕЛИ'
when product_name_modified2 like '%ПЛЕЙЕР%' or product_name_modified2 like '%ПЛЕЕР%' or product_name_modified2 like '%DVD%ПЛЕ%' then 'ПЛЕЙЕРЫ'
when product_name_modified2 in ('ACCCOMP ПРОГРАММНОЕ ОБЕСПЕЧЕНИЕ','DR.WEB АНТИВИРУС 6 МЕС. НА 1ПК OEM-CARD (ПОДАРОК)') then 'ПРОГРАММНОЕ ОБЕСПЕЧЕНИЕ'
when product_name_modified2 in ('ACCCOMP СЕТЕВОЕ ОБОРУДОВАНИЕ','ACCCOMP СЕТЕВЫЕ ФИЛЬТРЫ, UPS, ЗАРЯДНЫЕ УСТРОЙСТВА','ACCGSM МОДЕМЫ И РОУТЕРЫ',
  'FM МОДУЛЯТОР','LAN МОДЕМЫ') then 'СЕТЕВОЕ ОБОРУДОВАНИЕ'
when product_name_modified2 in ('ACCCOMP СУВЕНИРЫ') then 'СУВЕНИРЫ'
when product_name_modified2 in ( '%СУМК%') then 'СУМКИ'
when product_name_modified2 in ('L7 II DUAL P715 (БЕЛЫЙ, ГЕЛЕВЫЙ)','L7 II DUAL P715 (ЧЕРНЫЙ, ГЕЛЕВЫЙ)') or product_name_modified2 like '%JEKOD'
  or product_name_modified2 like '%ЧЕХЛ%' then 'ЧЕХЛЫ'
when product_name_modified2 like '%ЗАРЯД%' then 'ЗАРЯДНЫЕ УСТРОЙСТВА'
when product_name_modified2 like '%ЧАСЫ%' then 'ЧАСЫ'

when product_name_modified2 in ('HP CC643HE №121 КАРТРИДЖ С ТРЕХ ЦВЕТНЫМИ ЧЕРНИЛАМИ') or product_name_modified2 like '%ПРИНТЕР%' then 'ПРИНТЕРЫ/АКСЕССУАРЫ'
when product_name_modified2 in ('ACCSDA ДИСПЕНСЕРЫ') then 'ДИСПЕНСЕРЫ'
when product_name_modified2 in ('ACCSDA ЛАМПЫ','ACCSDA СВЕТИЛЬНИКИ') then 'ЛАМПЫ'

when product_name_modified2 in ('ACCSDA СУШИЛКИ И ГЛАДИЛЬНЫЕ ДОСКИ ДЛЯ БЕЛЬЯ','KITFORT','KRASKA DLYA V','KИСТОЧКА ИЗ СИЛИКОНА  MARMITONI')
  or product_name_modified2 like '%УХОД%' then 'УХОД ЗА ДОМОМ'

when product_name_modified2 in ('ACCSDAPERSONAL/АКСЕССУАРЫ') then 'АКСЕССУАРЫ-ПРОЧЕЕ'
when product_name_modified2 in ('AIO','CARD ZTE','HDD','-RW+RW DRIVE USB','BLU RAY USB','HDD USB','KEYBOARD USB','KEYBORD')
  or product_name_modified2 like '%МОНИТОР%' or product_name_modified2 like '%ДИСПЛЕЙ%' then 'КОМПЬЮТЕРНЫЕ ПРИНАДЛЕЖНОСТИ'

when product_name_modified2 in ('HT ST 5.1','HT TB 5.1') or product_name_modified2 like '%ТЕЛЕВИЗОР%'
  or product_name_modified2 like '%LCD%' or product_name_modified2 like '%LCD%TV%' or product_name_modified2 like '%LED%TV%'
  or product_name_modified2 like '%КИНОТЕАТР%'then 'ТЕЛЕВИЗОР'

when product_name_modified2 in ('BUH') then 'ГАРАНТИЙНЫЙ ТАЛОН'
when product_name_modified2 in ('CAM - МОДУЛЬ АЛМА ТВ','CAМ-МОДУЛЬ OTAU TV') then 'КАБЕЛЬНОЕ ТЕЛЕВИДЕНИЕ'
when product_name_modified2 in ('CAMCORDER HDD','DIGITAL CAMERA') or product_name_modified2 like '%ВИДЕОКАМЕРА%'then 'ВИДЕОКАМЕРА'
when product_name_modified2 like '%ФОТОКАМЕРА%' then 'ФОТОКАМЕРА'
when product_name_modified2 like ('%ФИЛЬТР%') then 'ФИЛЬТРЫ'
when product_name_modified2 in ('CD','CD-DISC','CD-ROM') then 'CD'
when product_name_modified2 in ('CRYSIS 3 PS3') then 'МЕЛОМАН ПРОДУКТЫ'
when product_name_modified2 in ('CВЧ-ПЕЧЬ PANASONIC') then 'ПЕЧЬ'
when product_name_modified2 in ('GPS НАВИГАТОР') then 'GPS НАВИГАТОР'
when product_name_modified2 in ('DECT','DECT+ПРОВОДНОЙ ТЕЛЕФОН') then 'ТЕЛЕФОНЫ'

when product_name_modified2 in ('DSK_NEXT-2') then 'СПОРТИВНЫЕ ТОВАРЫ'
when product_name_modified2='DVB-T2 ПРИЕМНИК STRONG' or product_name_modified2 like '%DVD%' then 'DVD PRODUCTS'
when product_name_modified2 in ('E-BOOK','M-BOOK') then 'E-BOOK'
when product_name_modified2 in ('KОНДИЦИОНЕР CAMERON') then 'KОНДИЦИОНЕРЫ'
when product_name_modified2 in ('LG - КРОНШТЕЙН') then 'КРОНШТЕЙН'

when product_name_modified2 like 'FAX%' then 'ФАКС'
when product_name_modified2 like 'DW%' or product_name_modified2 like '%ПОСУДОМО%' then 'ПОСУДОМОЕЧНАЯ МАШИНА'
when product_name_modified2 like 'IPAD%' then 'IPAD'
when product_name_modified2 in ('CОТ.ТЕЛ. LG','IPHONE') or product_name_modified2 like 'GSM%' or product_name_modified2 like '%HTC'
  then 'МОБИЛЬНЫЕ ТЕЛЕФОНЫ'
when product_name_modified2 in ('IPOD') then 'IPOD'
when product_name_modified2 in ('IVY BRIDGE УЛЬТРАБУК LENOVO') or product_name_modified2 like '%НОУТБУК%' then 'НОУТБУКИ'
when product_name_modified2 in  ('ACCSDA PIC NIC','AS','BLU RAY','COVER/OTHER','DIZZY ЭНЕРДЖИ СТЕКЛО ЭНЕРГ. НАПИТ','INVERSION [PC, JEWEL, РУССКАЯ ВЕРСИЯ]','KOMBIN_BAR')
  or product_name_modified2 like 'F7P1%' then 'ПРОЧЕЕ'
  else 'OTHER' end as pr_name

from v_tmp_d_products5 p1;
grant select on U1.V_TMP_D_PRODUCTS6 to LOADDB;
grant select on U1.V_TMP_D_PRODUCTS6 to LOADER;


