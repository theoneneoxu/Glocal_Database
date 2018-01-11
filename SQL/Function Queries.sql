--query
--Top 3 Business

select TOP_3_BUSINESS.RATING "Rating", TOP_3_BUSINESS.TOP_BUSINESS_ID  "Business_ID",TOP_3_BUSINESS.COUNTREVIEWS "CountReviews",business.BUSINESS_NAME "Business_Name",business.PRICE_RANGE "Price_Range",business.CREATION_TIME "Creation_Time",image.IMAGE_URL "Image_Url"  from (select * from (  Select ROUND(AVG(review.RATING),1) as rating ,  review.BUSINESS_ID as TOP_BUSINESS_ID, COUNT(review.REVIEW_ID) as countReviews,  ROUND(ROUND(AVG(review.RATING),1)*COUNT(review.REVIEW_ID)/(select count(*) from REVIEW),4) as hotFactor  from REVIEW review  inner join BUSINESS business on business.BUSINESS_ID=review.BUSINESS_ID  where business.STATE=(SELECT STATE from USER_INFO where USER_ID=11000302)  group by review.BUSINESS_ID  order by hotFactor desc  ) TOP_BUSINESS  where rownum<=3) TOP_3_BUSINESS  inner join BUSINESS business on business.BUSINESS_ID=TOP_3_BUSINESS.TOP_BUSINESS_ID LEFT join BUSINESS_IMAGE business_image on business_image.BUSINESS_ID=business.BUSINESS_ID left join IMAGE image on image.IMAGE_ID=business_image.IMAGE_ID


--Top 3 Reviews
 select * from( select review.REVIEW_ID as "Review_Id", review.USER_ID as "User_Id",review.BUSINESS_ID as "Business_Id",review.RATING as "Rating",review.TEXT as "Text",business.BUSINESS_NAME as "Business_Name",review.CREATION_TIME as "Creation_Time",user_info.FIRST_NAME||' '||nvl(user_info.LAST_NAME,'') as "FullName",(Select COUNT(*) from REVIEW where USER_ID=user_info.USER_ID) as "CountReview", image.IMAGE_URL as "ImageUrl" from REVIEW review  inner join BUSINESS business on business.BUSINESS_ID=review.BUSINESS_ID  inner join USER_INFO user_info on user_info.USER_ID=REVIEW.USER_ID  left join USER_IMAGE user_image on user_image.USER_ID=user_info.USER_ID left join IMAGE image on image.IMAGE_ID=user_image.IMAGE_ID where user_info.STATE=(SELECT STATE from USER_INFO where USER_ID=11000302)  and review.USER_ID!=11000302  order by review.CREATION_TIME desc, review.RATING desc  ) TOP_3_REVIEWS  where rownum<=3 

 
--Days Since the last Reviews
 select ROUND(SYSDATE-temp.CREATION_TIME,0) as "no_days_since_last_review" from(select * from REVIEW where BUSINESS_ID=10003342 order by CREATION_TIME DESC) temp where rownum<=1

--Instate and out state review
select (select count(*) from REVIEW where BUSINESS_ID=10003342) as "totalReview", count(*) as "OutState",((select count(*) from REVIEW where BUSINESS_ID=10003342)-count(*)) as "InState" from (select review.REVIEW_ID,user_info.USER_ID,business.BUSINESS_ID, (CASE WHEN user_info.STATE <> business.STATE then 1 else 0 end ) as not_same_city_or_state from REVIEW review inner join USER_INFO user_info on user_info.USER_ID=review.USER_ID inner join BUSINESS business on business.BUSINESS_ID=review.BUSINESS_ID where business.BUSINESS_ID=10003342) temp where not_same_city_or_state=1 group by temp.BUSINESS_ID

--Unique User Logging
select count(DISTINCT USER_ID) as "unique_user_logging",BUSINESS_ID  from REVIEW where BUSINESS_ID=10003342 group BY BUSINESS_ID

--Rating Distribution
select RATING,count(RATING) as count_rating from REVIEW where BUSINESS_ID=10003342 group by RATING ORDER BY RATING DESC

--Year Wise Rating and average rating
select EXTRACT(YEAR from CREATION_TIME) as "year", count(RATING) as "count_rating", AVG(RATING) as "avg_rating" from REVIEW where BUSINESS_ID=10003342 GROUP BY BUSINESS_ID,EXTRACT(YEAR from CREATION_TIME) ORDER BY EXTRACT(YEAR from CREATION_TIME) DESC

--Month Wise rating for the year 2016
select EXTRACT(MONTH from CREATION_TIME) as "month_num", trim(to_char(CREATION_TIME, 'Month')) as "month", count(RATING) as "count_rating", AVG(RATING) as "avg_rating" from REVIEW  where BUSINESS_ID=10003342  and EXTRACT(YEAR from CREATION_TIME)=2016  GROUP BY BUSINESS_ID,EXTRACT(MONTH from CREATION_TIME),to_char(CREATION_TIME, 'Month')  order by EXTRACT(MONTH from CREATION_TIME) ASC







--query

select t4.rating, number_given, average_given, plot_against, plot_line from (

select t2.rating, number_given ,average_given from (

select count(user_id) as number_given, rating from (
select user_id, rating from (select user_id, rating from review
order by user_id desc )
where user_id = '11000001'
)
group by rating
order by rating desc
) t1
right join (
select count (USER_ID) as average_given, rating from review
group by rating
order by rating desc
)  t2

on t1.rating = t2.rating
) t3 inner join
(
select rating,plot_against, round((multwithavgdivby10*avgno)/10) as plot_line from (
select t2.rating, round((average_given/10000)*number_given) as plot_against,round(average_given/1000) as multwithavgdivby10 from (
select count(user_id) as number_given, rating from (
select user_id, rating from (select user_id, rating from review
order by user_id desc )
where user_id = '11000001'
)
group by rating
order by rating desc
) t1
right join (
select count (USER_ID) as average_given, rating from review
group by rating
order by rating desc
)  t2
on t1.rating = t2.rating
)t6 full join (
select avg(number_given) as avgno from (
select count(user_id) as number_given, rating from (
select user_id, rating from (select user_id, rating from review
order by user_id desc )
where user_id = '11000001'
)
group by rating
order by rating desc
) tavg1

right join (
select count (USER_ID) as average_given, rating from review
group by rating
order by rating desc

)tavg2
on tavg1.rating = tavg2.rating
)tright
on tright.avgno = tright.avgno 
)t4
on t3.rating = t4.rating
;




select tag_id, tagid.tag_name, font_size from (


select tag_name, (round(percentage/10,0) * 3) + 10 as font_size from (


select tag_name, round((count/sum)*100)as percentage from (

select * from (

select tag_name, count(tag_name) as count  from (

select * from (

select review_id, user_id, review.business_id, rating, text, creation_time, tag_id, tag_name from review


inner join (

select config_tag.tag_id, tag_name, business_id from config_tag, business_tag
where config_tag.tag_id = business_tag.tag_id

) btag

on btag.business_id = review.business_id

)

where user_id = '11000302'
)

group by tag_name

order by count desc
)

where rownum < 6
) t1

full join (

select sum(count) as sum from (

select tag_name, count(tag_name) as count  from (

select * from (

select review_id, user_id, review.business_id, rating, text, creation_time, tag_id, tag_name from review


inner join (

select config_tag.tag_id, tag_name, business_id from config_tag, business_tag
where config_tag.tag_id = business_tag.tag_id

) btag

on btag.business_id = review.business_id

)

where user_id = '11000302'
)

group by tag_name

order by count desc
)

where rownum < 6

) t2

on t2.sum = t2.sum
)
)tagid

inner join config_tag

on tagid.tag_name = config_tag.tag_name
;





--query
--see db connections
select * from v$session
where schemaname = 'NEO'
order by status, osuser
;

--see execution plan
select * from table(dbms_xplan.display);
explain plan for
--explain plan for

--paged selection of business searching
select t.*,
image.image_url
from
(select b.*
from
(select a.*, rownum rn
from
(select
business.*,
(select count(*) from review where review.business_id = business.business_id) as review_count,
(select round(nvl(avg(rating), 0), 1) from review where review.business_id = business.business_id) as rating,
count(*) over () row_count
from business
where lower(city) = 'las vegas'
and lower(state) = 'nv'
and (business_id in (select distinct business_id from business_tag where tag_id in (select tag_id from config_tag where lower(tag_name) like '%burger%')) or lower(business_name) like '%burger%')
--and (business_id in (select distinct business_id from business_tag where tag_id in (select tag_id from config_tag where lower(tag_name) in ('fast food', 'burger', 'pizza'))) and lower(business_name) like '%burger%')
and price_range in ('1', '2')
order by rating desc
) a
where rownum <= 1 * 10
) b
where b.rn > (1 - 1) * 10
) t
left join business_image
on business_image.business_id = t.business_id
left join image
on image.image_id = business_image.image_id
order by t.rn asc
;

--retrieve newest review of each business for business searching
select t.*,
image.image_url
from
(select a.*
from
(select review.*, row_number() over (partition by business_id order by creation_time desc) as rn
from review
where business_id in ('10000001', '10000002', '10000003', '10000005')
) a
where a.rn = 1
) t
left join user_image
on user_image.user_id = t.user_id
left join image
on image.image_id = user_image.image_id
;

--paged selection of reviews on user
select
t.*,
(select count(*) from vote where vote.review_id = t.review_id) as like_count,
business.business_name,
business.address_line1,
business.address_line2,
business.city,
business.state,
business.zip,
business.price_range,
image.image_url
from
(select b.*
from
(select a.*, rownum rn
from 
(select *
from review
where user_id = 10000001
order by creation_time desc, rating desc
) a
where rownum <= 1 * 10
) b
where b.rn > (1 - 1) * 10
) t
left join business
on business.business_id = t.business_id
left join business_image
on business_image.business_id = business.business_id
left join image
on image.image_id = business_image.image_id
order by t.rn asc
;

--paged selection of reviews on business
select
t.*,
(select count(*) from vote where vote.review_id = t.review_id) as like_count,
(select count(*) from review where review.user_id = user_info.user_id) as review_count,
user_info.first_name,
user_info.last_name,
user_info.city,
user_info.state,
image.image_url
from
(select b.*
from
(select a.*, rownum rn
from
(select *
from review
where business_id = 10001201
order by creation_time desc, rating desc
) a
where rownum <= 1 * 10
) b
where b.rn > (1 - 1) * 10
) t
left join user_info
on user_info.user_id = t.user_id
left join user_image
on user_image.user_id = user_info.user_id
left join image
on image.image_id = user_image.image_id
order by t.rn asc
;

--oracle 12 needed
select t.*, u.first_name, u.last_name, u.city, u.state, image.image_url,
(select count(*) from vote where vote.review_id = t.review_id) as like_count,
(select count(*) from review where review.user_id = u.user_id) as review_count
from
(select *
from review
where business_id = 10000052
order by creation_time desc
offset 10 rows fetch next 10 rows only
) t
left join user_info u
on t.user_id = u.user_id
left join user_image
on user_image.user_id = u.user_id
left join image
on image.image_id = user_image.image_id
order by t.creation_time desc
;

--example of using pack_business.proc_handle_business_sub_attr
declare
businessID number := 11000055;
tagTable pack_business.TypeBusinessTagTable;
hourTable pack_business.TypeBusinessHourTable;
textTable pack_business.TypeBusinessAttrTextTable;
numberTable pack_business.TypeBusinessAttrNumberTable;
dateTable pack_business.TypeBusinessAttrDateTable;
begin
tagTable(1).action := 'delete';
tagTable(1).tag_id := 1;
tagTable(2).action := 'delete';
tagTable(2).tag_id := 5;
tagTable(3).action := 'create';
tagTable(3).tag_id := 20;
hourTable(1).action := 'create';
hourTable(1).weekday_id := 1;
hourTable(1).open_time := to_date('1/1/2000 8:30 am', 'mm/dd/yyyy hh:mi am');
hourTable(1).close_time := to_date('1/1/2000 6:00 pm', 'mm/dd/yyyy hh:mi am');
hourTable(2).action := 'update';
hourTable(2).weekday_id := 2;
hourTable(2).open_time := to_date('1/1/2000 8:30 am', 'mm/dd/yyyy hh:mi am');
hourTable(2).close_time := to_date('1/1/2000 ', 'mm/dd/yyyy hh:mi am');
textTable(1).action := 'create';
textTable(1).attr_id := 4;
textTable(1).text_value := 'Upscale';
textTable(2).action := 'create';
textTable(2).attr_id := 41;
textTable(2).text_value := 'What is Matrix?';
numberTable(1).action := 'create';
numberTable(1).attr_id := 40;
numberTable(1).number_value := 12;
pack_business.proc_handle_business_sub_attr(businessID, tagTable, hourTable, textTable, numberTable, dateTable);
end;

--retrieveBusinessAttrConfigAndValue
select
config_business_attr.*,
t.text_value,
n.number_value,
d.date_value
from config_business_attr
left join (select * from business_attr_text where business_id = 11000001) t
on t.attr_id = config_business_attr.attr_id
left join (select * from business_attr_number where business_id = 11000001) n
on n.attr_id = config_business_attr.attr_id
left join (select * from business_attr_date where business_id = 11000001) d
on d.attr_id = config_business_attr.attr_id
order by config_business_attr.attr_name asc
;
