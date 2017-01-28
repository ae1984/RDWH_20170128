create or replace force view u1.vintage_corr as
select q.yy_mm_report,v1.quarter,
v1."0"-q."0" as "0", v1."1"-q."1" as "1" ,v1."2"-q."2" as "2" ,v1."3"-q."3" as "3" ,v1."4"-q."4" as "4" ,v1."5"-q."5" as "5" ,v1."6"-q."6" as "6" ,v1."7"-q."7" as "7" ,
v1."8"-q."8" as "8" ,v1."9"-q."9" as "9" ,v1."10"-q."10" as "10", v1."11"-q."11" as "11" ,v1."12"-q."12" as "12" ,v1."13"-q."13" as "13" ,v1."14"-q."14" as "14" ,
v1."15"-q."15" as "15" ,v1."16"-q."16" as "16" ,v1."17"-q."17" as "17" ,v1."18"-q."18" as "18" ,v1."19"-q."19" as "19" ,v1."20"-q."20" as "20" ,v1."21"-q."21" as "21" ,
v1."22"-q."22" as "22" ,v1."23"-q."23" as "23" ,v1."24"-q."24" as "24" ,v1."25"-q."25" as "25" ,v1."26"-q."26" as "26" ,v1."27"-q."27" as "27" ,v1."28"-q."28" as "28" ,
v1."29"-q."29" as "29" ,v1."30"-q."30" as "30" ,v1."31"-q."31" as "31" ,v1."32"-q."32" as "32" ,v1."33"-q."33" as "33" ,v1."34"-q."34" as "34" ,v1."35"-q."35" as "35" ,
v1."36"-q."36" as "36" ,v1."37"-q."37" as "37" ,v1."38"-q."38" as "38" ,v1."39"-q."39" as "39" ,v1."40"-q."40" as "40" ,v1."41"-q."41" as "41" ,v1."42"-q."42" as "42" ,
v1."43"-q."43" as "43" ,v1."44"-q."44" as "44" ,v1."45"-q."45" as "45" ,v1."46"-q."46" as "46" ,v1."47"-q."47" as "47" ,v1."48"-q."48" as "48" ,v1."49"-q."49" as "49" ,
v1."50"-q."50" as "50" ,v1."51"-q."51" as "51" ,v1."52"-q."52" as "52" ,v1."53"-q."53" as "53" ,v1."54"-q."54" as "54" ,v1."55"-q."55" as "55" ,v1."56"-q."56" as "56" ,
v1."57"-q."57" as "57" ,v1."58"-q."58" as "58" ,v1."59"-q."59" as "59" ,v1."60"-q."60" as "60" ,v1."61"-q."61" as "61" ,v1."62"-q."62" as "62" ,v1."63"-q."63" as "63" ,
v1."64"-q."64" as "64" ,v1."65"-q."65" as "65" ,v1."66"-q."66" as "66" ,v1."67"-q."67" as "67" ,v1."68"-q."68" as "68" ,v1."69"-q."69" as "69" ,v1."70"-q."70" as "70"
 from Vintage_Records_v1 v1
join (with vintage(id, num, value) as(
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
grant select on U1.VINTAGE_CORR to LOADDB;
grant select on U1.VINTAGE_CORR to LOADER;


