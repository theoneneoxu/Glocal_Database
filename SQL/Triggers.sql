--triggers
create or replace trigger tri_user_info_insert
before insert on user_info
for each row
begin
:new.user_id := seq_user_id.nextval;
:new.creation_time := sysdate;
end;

create or replace trigger tri_user_info_update
before update on user_info
for each row
begin
:new.modification_time := sysdate;
end;

create or replace trigger tri_user_credential_insert
before insert on user_credential
for each row
begin
:new.creation_time := sysdate;
end;

create or replace trigger tri_user_credential_update
before update on user_credential
for each row
begin
:new.modification_time := sysdate;
end;

create or replace trigger tri_user_access_token_insert
before insert on user_access_token
for each row
begin
:new.token_id := seq_token_id.nextval;
:new.creation_time := sysdate;
end;

create or replace trigger tri_user_access_token_update
before update on user_access_token
for each row
begin
:new.modification_time := sysdate;
end;

create or replace trigger tri_business_insert
before insert on business
for each row
begin
:new.business_id := seq_business_id.nextval;
:new.creation_time := sysdate;
end;

create or replace trigger tri_business_update
before update on business
for each row
begin
:new.modification_time := sysdate;
end;

create or replace trigger tri_business_tag_insert
before insert on business_tag
for each row
declare
tag_count integer;
max_count integer :=3;
begin
/* conflict with pack_business.proc_handle_business_tag
--check business tag count
select count(*) into tag_count
from business_tag where business_id = :new.business_id;
if tag_count >= max_count
then
raise_application_error(-20001, 'Business is not allowed to have more than 3 Tags.');
end if;
*/
--set creation time
:new.creation_time := sysdate;
end;

create or replace trigger tri_business_tag_update
before update on business_tag
for each row
begin
:new.modification_time := sysdate;
end;

create or replace trigger tri_business_hour_insert
before insert on business_hour
for each row
begin
:new.hour_id := seq_hour_id.nextval;
:new.creation_time := sysdate;
end;

create or replace trigger tri_business_hour_update
before update on business_hour
for each row
begin
:new.modification_time := sysdate;
end;

create or replace trigger tri_business_ownership_insert
before insert on business_ownership
for each row
begin
:new.creation_time := sysdate;
end;

create or replace trigger tri_business_ownership_update
before update on business_ownership
for each row
begin
:new.modification_time := sysdate;
end;

create or replace trigger tri_review_insert
before insert on review
for each row
begin
:new.review_id := seq_review_id.nextval;
:new.creation_time := sysdate;
end;

create or replace trigger tri_review_update
before update on review
for each row
begin
:new.modification_time := sysdate;
end;

create or replace trigger tri_vote_insert
before insert on vote
for each row
begin
:new.vote_id := seq_vote_id.nextval;
:new.creation_time := sysdate;
end;

create or replace trigger tri_vote_update
before update on vote
for each row
begin
:new.modification_time := sysdate;
end;

create or replace trigger tri_image_insert
before insert on image
for each row
begin
:new.image_id := seq_image_id.nextval;
:new.creation_time := sysdate;
end;

create or replace trigger tri_image_update
before update on image
for each row
begin
:new.modification_time := sysdate;
end;

create or replace trigger tri_user_image_insert
before insert on user_image
for each row
begin
:new.creation_time := sysdate;
end;

create or replace trigger tri_user_image_update
before update on user_image
for each row
begin
:new.modification_time := sysdate;
end;

create or replace trigger tri_business_image_insert
before insert on business_image
for each row
begin
:new.creation_time := sysdate;
end;

create or replace trigger tri_business_image_update
before update on business_image
for each row
begin
:new.modification_time := sysdate;
end;

create or replace trigger tri_business_attr_text_insert
before insert on business_attr_text
for each row
begin
:new.text_id := seq_text_id.nextval;
:new.creation_time := sysdate;
end;

create or replace trigger tri_business_attr_text_update
before update on business_attr_text
for each row
begin
:new.modification_time := sysdate;
end;

create or replace trigger tri_business_attr_num_insert
before insert on business_attr_number
for each row
begin
:new.number_id := seq_number_id.nextval;
:new.creation_time := sysdate;
end;

create or replace trigger tri_business_attr_num_update
before update on business_attr_number
for each row
begin
:new.modification_time := sysdate;
end;

create or replace trigger tri_business_attr_date_insert
before insert on business_attr_date
for each row
begin
:new.date_id := seq_date_id.nextval;
:new.creation_time := sysdate;
end;

create or replace trigger tri_business_attr_date_update
before update on business_attr_date
for each row
begin
:new.modification_time := sysdate;
end;




