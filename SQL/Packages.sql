--packages
create or replace package pack_business is
type TypeBusinessTag is record(
action varchar2(10 byte),
tag_id number(38,0)
);
type TypeBusinessTagTable is table of TypeBusinessTag index by binary_integer;
type TypeBusinessHour is record(
action varchar2(10 byte),
weekday_id number(38,0),
open_time date,
close_time date
);
type TypeBusinessHourTable is table of TypeBusinessHour index by binary_integer;
type TypeBusinessAttrText is record(
action varchar2(10 byte),
attr_id number(38,0),
text_value varchar2(255 byte)
);
type TypeBusinessAttrTextTable is table of TypeBusinessAttrText index by binary_integer;
type TypeBusinessAttrNumber is record(
action varchar2(10 byte),
attr_id number(38,0),
number_value number(38,6)
);
type TypeBusinessAttrNumberTable is table of TypeBusinessAttrNumber index by binary_integer;
type TypeBusinessAttrDate is record(
action varchar2(10 byte),
attr_id number(38,0),
date_value date
);
type TypeBusinessAttrDateTable is table of TypeBusinessAttrDate index by binary_integer;

procedure proc_handle_business_sub_attr(
businessID in number,
businessTagTable in TypeBusinessTagTable,
businessHourTable in TypeBusinessHourTable,
businessAttrTextTable in TypeBusinessAttrTextTable,
businessAttrNumberTable in TypeBusinessAttrNumberTable,
businessAttrDateTable in TypeBusinessAttrDateTable
);
procedure proc_delete_business(
businessID in number
);
end pack_business;

create or replace package body pack_business is
procedure proc_upsert_business_tag(
businessID in number,
tagID in number
) is
begin
loop
begin
merge into business_tag using dual on (business_id = businessID and tag_id = tagID)
when matched then update set modification_time = sysdate
when not matched then insert (business_id, tag_id) values (businessID, tagID);
exit;
exception
when no_data_found then null; --when the entry was concurrently deleted, continue loop
when dup_val_on_index then null; --when an entry was concurrently inserted, continue loop
end;
end loop;
end;

procedure proc_delete_business_tag(
businessID in number,
tagID in number
) is
begin
delete from business_tag where business_id = businessID and tag_id = tagID;
end;

procedure proc_upsert_business_hour(
businessID in number,
weekdayID in number,
openTime in date,
closeTime in date
) is
begin
loop
begin
merge into business_hour using dual on (business_id = businessID and weekday_id = weekdayID)
when matched then update set open_time = openTime, close_time = closeTime
when not matched then insert (business_id, weekday_id, open_time, close_time) values (businessID, weekdayID, openTime, closeTime);
exit;
exception
when no_data_found then null; --when the entry was concurrently deleted, continue loop
when dup_val_on_index then null; --when an entry was concurrently inserted, continue loop
end;
end loop;
end;

procedure proc_delete_business_hour(
businessID in number,
weekdayID in number
) is
begin
delete from business_hour where business_id = businessID and weekday_id = weekdayID;
end;

procedure proc_upsert_business_attr_text(
businessID in number,
attrID in number,
textValue in varchar2
) is
begin
loop
begin
merge into business_attr_text using dual on (business_id = businessID and attr_id = attrID)
when matched then update set text_value = textValue
when not matched then insert (business_id, attr_id, text_value) values (businessID, attrID, textValue);
exit;
exception
when no_data_found then null; --when the entry was concurrently deleted, continue loop
when dup_val_on_index then null; --when an entry was concurrently inserted, continue loop
end;
end loop;
end;

procedure proc_delete_business_attr_text(
businessID in number,
attrID in number
) is
begin
delete from business_attr_text where business_id = businessID and attr_id = attrID;
end;

procedure proc_upsert_business_attr_num(
businessID in number,
attrID in number,
numberValue in number
) is
begin
loop
begin
merge into business_attr_number using dual on (business_id = businessID and attr_id = attrID)
when matched then update set number_value = numberValue
when not matched then insert (business_id, attr_id, number_value) values (businessID, attrID, numberValue);
exit;
exception
when no_data_found then null; --when the entry was concurrently deleted, continue loop
when dup_val_on_index then null; --when an entry was concurrently inserted, continue loop
end;
end loop;
end;

procedure proc_delete_business_attr_num(
businessID in number,
attrID in number
) is
begin
delete from business_attr_number where business_id = businessID and attr_id = attrID;
end;

procedure proc_upsert_business_attr_date(
businessID in number,
attrID in number,
dateValue in date
) is
begin
loop
begin
merge into business_attr_date using dual on (business_id = businessID and attr_id = attrID)
when matched then update set date_value = dateValue
when not matched then insert (business_id, attr_id, date_value) values (businessID, attrID, dateValue);
exit;
exception
when no_data_found then null; --when the entry was concurrently deleted, continue loop
when dup_val_on_index then null; --when an entry was concurrently inserted, continue loop
end;
end loop;
end;

procedure proc_delete_business_attr_date(
businessID in number,
attrID in number
) is
begin
delete from business_attr_date where business_id = businessID and attr_id = attrID;
end;

procedure proc_handle_business_tag(
businessID in number,
businessTagTable in TypeBusinessTagTable
) is
begin
for i in 1..businessTagTable.count loop
if businessTagTable(i).action = 'delete'
then proc_delete_business_tag(businessID, businessTagTable(i).tag_id);
else proc_upsert_business_tag(businessID, businessTagTable(i).tag_id);
end if;
end loop;
end;

procedure proc_handle_business_hour(
businessID in number,
businessHourTable in TypeBusinessHourTable
) is
begin
for i in 1..businessHourTable.count loop
if businessHourTable(i).action = 'delete'
then proc_delete_business_hour(businessID, businessHourTable(i).weekday_id);
else proc_upsert_business_hour(businessID, businessHourTable(i).weekday_id, businessHourTable(i).open_time, businessHourTable(i).close_time);
end if;
end loop;
end;

procedure proc_handle_business_attr_text(
businessID in number,
businessAttrTextTable in TypeBusinessAttrTextTable
) is
begin
for i in 1..businessAttrTextTable.count loop
if businessAttrTextTable(i).action = 'delete'
then proc_delete_business_attr_text(businessID, businessAttrTextTable(i).attr_id);
else proc_upsert_business_attr_text(businessID, businessAttrTextTable(i).attr_id, businessAttrTextTable(i).text_value);
end if;
end loop;
end;

procedure proc_handle_business_attr_num(
businessID in number,
businessAttrNumberTable in TypeBusinessAttrNumberTable
) is
begin
for i in 1..businessAttrNumberTable.count loop
if businessAttrNumberTable(i).action = 'delete'
then proc_delete_business_attr_num(businessID, businessAttrNumberTable(i).attr_id);
else proc_upsert_business_attr_num(businessID, businessAttrNumberTable(i).attr_id, businessAttrNumberTable(i).number_value);
end if;
end loop;
end;

procedure proc_handle_business_attr_date(
businessID in number,
businessAttrDateTable in TypeBusinessAttrDateTable
) is
begin
for i in 1..businessAttrDateTable.count loop
if businessAttrDateTable(i).action = 'delete'
then proc_delete_business_attr_date(businessID, businessAttrDateTable(i).attr_id);
else proc_upsert_business_attr_date(businessID, businessAttrDateTable(i).attr_id, businessAttrDateTable(i).date_value);
end if;
end loop;
end;

procedure proc_handle_business_sub_attr(
businessID in number,
businessTagTable in TypeBusinessTagTable,
businessHourTable in TypeBusinessHourTable,
businessAttrTextTable in TypeBusinessAttrTextTable,
businessAttrNumberTable in TypeBusinessAttrNumberTable,
businessAttrDateTable in TypeBusinessAttrDateTable
) is
begin
savepoint sp;
proc_handle_business_tag(businessID, businessTagTable);
proc_handle_business_hour(businessID, businessHourTable);
proc_handle_business_attr_text(businessID, businessAttrTextTable);
proc_handle_business_attr_num(businessID, businessAttrNumberTable);
proc_handle_business_attr_date(businessID, businessAttrDateTable);
exception
when others then
rollback to sp;
raise; --raise the error again, do not hide it
end;

procedure proc_delete_business(
businessID in number
) is
type ImageID is table of number index by binary_integer;
businessImageIDTable ImageID;
begin
savepoint sp;
delete from business_ownership where business_id = businessID;
delete from business_tag where business_id = businessID;
delete from business_hour where business_id = businessID;
delete from business_attr_text where business_id = businessID;
delete from business_attr_number where business_id = businessID;
delete from business_attr_date where business_id = businessID;
--delete business image
select image_id bulk collect into businessImageIDTable from business_image where business_id = businessID;
delete from business_image where business_id = businessID;
for i in 1..businessImageIDTable.count loop
delete from image where image_id = businessImageIDTable(i);
end loop;
--delete vote of business related review
delete from vote where review_id in (select review_id from review where business_id = businessID);
delete from review where business_id = businessID;
delete from business where business_id = businessID;
exception
when others then
rollback to sp;
raise; --raise the error again, do not hide it
end;
end pack_business;

create or replace package pack_review is
procedure proc_delete_review(
reviewID in number
);
end pack_review;

create or replace package body pack_review is
procedure proc_delete_review(
reviewID in number
) is
begin
savepoint sp;
delete from vote where review_id = reviewID;
delete from review where review_id = reviewID;
exception
when others then
rollback to sp;
raise; --raise the error again, do not hide it
end;
end pack_review;

create or replace package pack_vote is
procedure proc_handle_vote(
action in varchar2,
userID in number,
reviewID in number
);
end pack_vote;

create or replace package body pack_vote is
procedure proc_upsert_vote(
userID in number,
reviewID in number
) is
begin
loop
begin
merge into vote using dual on (user_id = userID and review_id = reviewID)
when matched then update set modification_time = sysdate
when not matched then insert (user_id, review_id) values (userID, reviewID);
exit;
exception
when no_data_found then null; --when the entry was concurrently deleted, continue loop
when dup_val_on_index then null; --when an entry was concurrently inserted, continue loop
end;
end loop;
end;

procedure proc_delete_vote(
userID in number,
reviewID in number
) is
begin
delete from vote where user_id = userID and review_id = reviewID;
end;

procedure proc_handle_vote(
action in varchar2,
userID in number,
reviewID in number
) is
begin
savepoint sp;
if action = 'delete'
then proc_delete_vote(userID, reviewID);
else proc_upsert_vote(userID, reviewID);
end if;
exception
when others then rollback to sp;
raise; --raise the error again, do not hide it
end;
end pack_vote;


