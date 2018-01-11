--temp








declare
cursor cr is select business_id from business where business_id >= 11000001;
bid number;
begin
open cr;
loop
fetch cr into bid;
exit when cr%notfound;
pack_business.proc_delete_business(bid);
end loop;
end;

commit;




declare
rev review%rowtype;
cursor ratingrange(
lr number,
hr number
) is
select *
from review
where user_id >= 11000001 and rating >= lr and rating <= hr;
begin
open ratingrange(0, 5);
loop
fetch ratingrange into rev;
exit when ratingrange%notfound;
dbms_output.put_line(rev.review_id || ' ' || rev.rating);
end loop;
close ratingrange;
end;



explain plan for (select * from business);
select * from table(dbms_xplan.display);


select user_id, count(*) from review group by user_id order by count(*) desc;



select r1.*
from review r1, review r2
where r1.business_id = r2.business_id and r1.creation_time >= r2.creation_time
;


select r1.*
from review r1, review r2
where r1.business_id = r2.business_id and r1.creation_time >= all (select creation_time from review where business_id = r1.business_id)

;






select business_id
from business
where city = 'Las Vegas'
and state = 'NV'
and business_id in (
select distinct business_id
from business_tag
where tag_id in (
select tag_id from config_tag
where lower(tag_name) like '%burger%'))
and rownum <= 500
union
select business_id
from business
where city = 'Las Vegas'
and state = 'NV'
and lower(business_name) like '%burger%'
;


select *
from business
where city = 'Las Vegas'
and state = 'NV'
and business_id in (
select distinct business_id
from business_tag
where tag_id in (
select tag_id from config_tag
where lower(tag_name) like '%burger%'))
and rownum <= 500
;


select *
from business
where city = 'Las Vegas'
and state = 'NV'
and lower(business_name) like '%burger%'
;


select distinct business_id
from business_tag
where tag_id in (
select tag_id from config_tag
where lower(tag_name) like '%burger%')
;






select *
from business
where city = 'Las Vegas'
and state = 'NV'
and lower(business_name) like 'office'

;


select *
from business
where city = 'Las Vegas'
and state = 'NV'
and lower(business_name) like '%_office%' or lower(business_name) like '%office_%'

;












select *
from review
where (business_id, creation_time) in (select business_id, min(creation_time) from review group by business_id);


select *
from review
inner join user_info
on user_info.user_id = review.user_id
where to_char(review.creation_time, 'mm') = 12
order by review.creation_time
;

select business_id, avg(rating)
from review
group by business_id
having avg(rating) = (select max(avg(rating)) from review group by business_id)
;


rollback;

commit;


insert into business_hour (business_id, weekday, open_time)

select * from config_tag where tag_id in (1, 2, 300);



declare
vr neodemo.TypeAttrText;
vt neodemo.TypeAttrTextTable;
--vt neodemo.TypeAttrTextTable := neodemo.TypeAttrTextTable((1, 'Yes', 'create'), (2, 'Yes', 'create'));
begin

--vr := (1, 'Yes', 'create');

--vt(1) := (1, 'Yes', 'create');
--vt(2) := (2, 'Yes', 'create');
--vt(3) := (4, 'Upscale', 'create');
/*
vr.attr_id := 1;
vr.text_value := 'Yes';
vr.action := 'delete';
vt(1) := vr;
vr.attr_id := 2;
vr.text_value := 'No';
vr.action := 'update';
vt(2) := vr;
vr.attr_id := 4;
vr.text_value := 'Divey';
vr.action := 'create';
vt(3) := vr;
*/
/*
vt(1).attr_id := 5;
vt(1).text_value := 'Formal';
vt(1).action := 'create';
vt(2).attr_id := 28;
vt(2).text_value := 'Quiet';
vt(2).action := 'create';
*/
dbms_output.put_line(vt.count);
neodemo.proc_handle_business_attr_text(11000001, vt);

end;





create or replace package neodemo is
type TypeAttrText is record(
attr_id number,
text_value varchar2(255 byte),
action varchar2(10 byte)
);
type TypeAttrTextTable is table of TypeAttrText index by binary_integer;

procedure proc_handle_business_attr_text(
businessID in number,
attrTextTable in TypeAttrTextTable
);
/*
procedure proc_upsert_business_attr_text(
businessID in number,
attrID in number,
textValue in varchar2
);
*/
end neodemo;



create or replace package body neodemo is


procedure proc_upsert_business_attr_text(
businessID in number,
attrID in number,
textValue in varchar2
)
is
begin
loop
begin
merge into business_attr_text using dual on (business_id = businessID and attr_id = attrID)
when matched then update set text_value = textValue
when not matched then insert (business_id, attr_id, text_value)
values (businessID, attrID, textValue);
exit; -- success? -> exit loop
exception
when no_data_found then -- the entry was concurrently deleted
null; -- exception? -> no op, i.e. continue looping
when dup_val_on_index then -- an entry was concurrently inserted
null; -- exception? -> no op, i.e. continue looping
end;
end loop;
end;


procedure proc_handle_business_attr_text(
businessID in number,
attrTextTable in TypeAttrTextTable
)
is
begin
savepoint sp;
for i in 1..attrTextTable.count loop
if attrTextTable(i).action = 'delete'
then
delete from business_attr_text where business_id = businessID and attr_id = attrTextTable(i).attr_id;
else
proc_upsert_business_attr_text(businessID, attrTextTable(i).attr_id, attrTextTable(i).text_value);
end if;
end loop;
exception
when others then
rollback to sp;
raise; --raise the error again, do not hide it
end;


end neodemo;












begin
proc_upsert_business_hour(11000001, 4, '2000-01-01 08:30', '2000-01-01 18:00');
end;



insert into business_hour (business_id, weekday_id, open_time) values (11000001, 3, '2000-01-01 09:00');











alter table config_user_type
add (
view_user_settings number(1,0),
modify_user_settings number(1,0),
view_user_profile number(1,0),
view_business number(1,0),
create_business number(1,0),
modify_business number(1,0),
delete_business number(1,0),
view_review number(1,0),
create_review number(1,0),
modify_review number(1,0),
delete_review number(1,0),
create_vote number(1,0),
delete_vote number(1,0),
view_business_dashboard number(1,0),
view_business_analysis number(1,0),
search_business number(1,0)
);


select * from review inner join business on business.business_id = review.review_id where review_id = 10000001;

alter table review
add constraint check_rating check (rating in (1, 2, 3, 4, 5));

alter table review
modify rating number(1,0);



declare
round number;
begin
for round in 1..6 loop
update user_info set (city, state) = (select city, state from business where business_id = user_info.user_id - 5000 * (round - 1))
where user_info.user_id >= 10000001 + 5000 * (round - 1) and user_info.user_id <= 10000000 + 5000 * round;
commit;
end loop;
end;




select * from view_review_on_business where business_id = 10000052 order by creation_time desc;



select count(*) from user_info where user_id = 100000021;







select t.*, u.FIRST_NAME, u.last_name, u.city, u.state, image.image_url,
(select count(*) from vote where vote.review_id = t.review_id) as review_like_count,
(select count(*) from review where review.user_id = u.user_id) as user_review_count
from
(SELECT b.* 
  FROM (SELECT a.*, rownum rn
          FROM (SELECT *
                  FROM review
                  where business_id = 10001201
                  order by creation_time desc
                  ) a
         WHERE rownum <= 1 * 10
         ) b
 WHERE b.rn > (1 - 1) * 10
) t
left join user_info u
on t.user_id = u.user_id
left join user_image
on user_image.user_id = u.user_id
left join image
on image.image_id = user_image.image_id
order by t.creation_time desc
;












select review.review_id, count(vote.review_id) as count_of_like
from review
left join vote
on review.review_id = vote.review_id
group by review.review_id
order by review.review_id;




select review.*, (select count(*) from vote where vote.review_id = review.review_id) as LikeCount
from review
where business_id = 10000001;








select business_attr_text.*, config_business_attr.attr_name
from business_attr_text
join config_business_attr
on business_attr_text.attr_id = config_business_attr.attr_id;



select * from business where lower(business_name) like '%panda express%';


select business_id, count(review_id)
from review
group by business_id
order by count(review_id) desc;




declare
bid number;
brecord business%rowtype;
begin
insert into business (business_name, status) values ('Neo Test 3', 'Open')
returning business_id into bid;
dbms_output.put_line('Generated BUSINESS_ID is ' || bid);
select * into brecord from business where business_id = bid;
dbms_output.put_line('Business ID is: ' || brecord.business_id);
dbms_output.put_line('Business Name is: ' || brecord.business_name);
dbms_output.put_line('Address Line 1 is: ' || brecord.address_line1);
end;









--neo practice sql and pl/sql
create or replace package pack_neo_demo is
type TypeReview is ref cursor;
type TypeReview2 is ref cursor return review%rowtype; --looks like no need to include "return review%rowtype"

procedure proc_neo1(
bid in number,
c1 out TypeReview
);
end pack_neo_demo;

create or replace package body pack_neo_demo is
procedure proc_neo1(
bid in number,
c1 out TypeReview
) is
--no need to use keywork declare
temp number;
begin
open c1 for
select * from review where business_id = bid;
end;
end pack_neo_demo;

declare
  bid number := 10000001;
  cr pack_neo_demo.TypeReview;
  rev review%rowtype;
begin
  pack_neo_demo.proc_neo1(bid, cr);
  loop
  fetch cr into rev;
  exit when cr%notfound;
  dbms_output.put_line(rev.review_id);
  end loop;
end;




