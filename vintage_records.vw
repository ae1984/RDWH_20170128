﻿create or replace force view u1.vintage_records as
select q.yy_mm_report,q.quarter,
nvl(v1."0",0)+q."0" as "0", nvl(v1."1",0)+q."1" as "1" ,nvl(v1."2",0)+q."2" as "2" ,nvl(v1."3",0)+q."3" as "3" ,nvl(v1."4",0)+q."4" as "4" ,
nvl(v1."5",0)+q."5" as "5" ,nvl(v1."6",0)+q."6" as "6" ,nvl(v1."7",0)+q."7" as "7" ,nvl(v1."8",0)+q."8" as "8" ,nvl(v1."9",0)+q."9" as "9" ,
nvl(v1."10",0)+q."10" as "10", nvl(v1."11",0)+q."11" as "11" ,nvl(v1."12",0)+q."12" as "12" ,nvl(v1."13",0)+q."13" as "13" ,nvl(v1."14",0)+q."14" as "14" ,
nvl(v1."15",0)+q."15" as "15" ,nvl(v1."16",0)+q."16" as "16" ,nvl(v1."17",0)+q."17" as "17" ,nvl(v1."18",0)+q."18" as "18" ,nvl(v1."19",0)+q."19" as "19" ,
nvl(v1."20",0)+q."20" as "20" ,nvl(v1."21",0)+q."21" as "21" ,nvl(v1."22",0)+q."22" as "22" ,nvl(v1."23",0)+q."23" as "23" ,nvl(v1."24",0)+q."24" as "24" ,
nvl(v1."25",0)+q."25" as "25" ,nvl(v1."26",0)+q."26" as "26" ,nvl(v1."27",0)+q."27" as "27" ,nvl(v1."28",0)+q."28" as "28" ,nvl(v1."29",0)+q."29" as "29" ,
nvl(v1."30",0)+q."30" as "30" ,nvl(v1."31",0)+q."31" as "31" ,nvl(v1."32",0)+q."32" as "32" ,nvl(v1."33",0)+q."33" as "33" ,nvl(v1."34",0)+q."34" as "34" ,
nvl(v1."35",0)+q."35" as "35" ,nvl(v1."36",0)+q."36" as "36" ,nvl(v1."37",0)+q."37" as "37" ,nvl(v1."38",0)+q."38" as "38" ,nvl(v1."39",0)+q."39" as "39" ,
nvl(v1."40",0)+q."40" as "40" ,nvl(v1."41",0)+q."41" as "41" ,nvl(v1."42",0)+q."42" as "42" ,nvl(v1."43",0)+q."43" as "43" ,nvl(v1."44",0)+q."44" as "44" ,
nvl(v1."45",0)+q."45" as "45" ,nvl(v1."46",0)+q."46" as "46" ,nvl(v1."47",0)+q."47" as "47" ,nvl(v1."48",0)+q."48" as "48" ,nvl(v1."49",0)+q."49" as "49" ,
nvl(v1."50",0)+q."50" as "50" ,nvl(v1."51",0)+q."51" as "51" ,nvl(v1."52",0)+q."52" as "52" ,nvl(v1."53",0)+q."53" as "53" ,nvl(v1."54",0)+q."54" as "54" ,
nvl(v1."55",0)+q."55" as "55" ,nvl(v1."56",0)+q."56" as "56" ,nvl(v1."57",0)+q."57" as "57" ,nvl(v1."58",0)+q."58" as "58" ,nvl(v1."59",0)+q."59" as "59" ,
nvl(v1."60",0)+q."60" as "60" ,nvl(v1."61",0)+q."61" as "61" ,nvl(v1."62",0)+q."62" as "62" ,nvl(v1."63",0)+q."63" as "63" ,nvl(v1."64",0)+q."64" as "64" ,
nvl(v1."65",0)+q."65" as "65" ,nvl(v1."66",0)+q."66" as "66" ,nvl(v1."67",0)+q."67" as "67" ,nvl(v1."68",0)+q."68" as "68" ,nvl(v1."69",0)+q."69" as "69" ,
nvl(v1."70",0)+q."70" as "70"
 from Vintage_corr v1
right join (with vintage(id, num, value) as(
select tm.quarter,
       months_between(to_date(p.yy_mm_report,'yyyy - mm'),to_date(p.yy_mm_start,'yyyy - mm')) as months,
       count(distinct case when p.delinq_days_old >= 90 then p.client_id end) as col
from V_PORTFOLIO p
join V_TIME_MONTHS tm on p.yy_mm_start = tm.text_yyyy_mm
where tm.quarter >= '2009-Q1'
group by tm.quarter,
         months_between(to_date(p.yy_mm_report,'yyyy - mm'),to_date(p.yy_mm_start,'yyyy - mm'))
)
select *
from vintage
join VINTAGE_REP_QUAR vin on vin.quarter = id
pivot
(
     listagg(value) within group(order by value)
     for num in (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,
                 27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,
                 51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70)
)) q on v1.yy_mm_report = q.yy_mm_report and v1.quarter = q.quarter;
grant select on U1.VINTAGE_RECORDS to LOADDB;
grant select on U1.VINTAGE_RECORDS to LOADER;


