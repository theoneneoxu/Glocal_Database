--views
create or replace view view_config_business_attr_drop
as
select
config_business_attr.attr_id,
config_business_attr.attr_name,
config_business_attr_drop.drop_option
from config_business_attr_drop
left join config_business_attr
on config_business_attr_drop.attr_id = config_business_attr.attr_id
with read only;

create or replace view view_user_info
as
select
user_info.*,
image.image_url,
(select count(*) from review where review.user_id = user_info.user_id) as review_count,
(select round(avg(rating), 1) from review where review.user_id = user_info.user_id) as average_rating,
(select count(*) from review where review.user_id = user_info.user_id and review.rating = 1) as rating_1_count,
(select count(*) from review where review.user_id = user_info.user_id and review.rating = 2) as rating_2_count,
(select count(*) from review where review.user_id = user_info.user_id and review.rating = 3) as rating_3_count,
(select count(*) from review where review.user_id = user_info.user_id and review.rating = 4) as rating_4_count,
(select count(*) from review where review.user_id = user_info.user_id and review.rating = 5) as rating_5_count,
(select count(*) from vote where vote.user_id = user_info.user_id) as voted_like_count,
(select count(*) from vote, review where vote.review_id = review.review_id and review.user_id = user_info.user_id) as received_like_count,
config_user_type.user_type_name
from user_info
left join user_image
on user_image.user_id = user_info.user_id
left join image
on image.image_id = user_image.image_id
left join config_user_type
on config_user_type.user_type_id = user_info.user_type_id
with read only;

create or replace view view_user_permission
as
select
user_info.user_id,
config_user_type.*
from user_info
left join config_user_type
on config_user_type.user_type_id = user_info.user_type_id
with read only;

create or replace view view_business_info
as
select
business.*,
image.image_url,
(select count(*) from review where review.business_id = business.business_id) as review_count,
(select round(avg(rating), 1) from review where review.business_id = business.business_id) as average_rating,
(select count(*) from review where review.business_id = business.business_id and review.rating = 1) as rating_1_count,
(select count(*) from review where review.business_id = business.business_id and review.rating = 2) as rating_2_count,
(select count(*) from review where review.business_id = business.business_id and review.rating = 3) as rating_3_count,
(select count(*) from review where review.business_id = business.business_id and review.rating = 4) as rating_4_count,
(select count(*) from review where review.business_id = business.business_id and review.rating = 5) as rating_5_count,
(select count(*) from business_tag where business_tag.business_id = business.business_id) as tag_count,
business_ownership.owner_id
from business
left join business_image
on business_image.business_id = business.business_id
left join image
on image.image_id = business_image.image_id
left join business_ownership
on business_ownership.business_id = business.business_id
with read only;

create or replace view view_business_tag
as
select
business_tag.business_id,
business_tag.tag_id,
config_tag.tag_name,
business_tag.modification_time,
business_tag.creation_time
from business_tag
left join config_tag
on config_tag.tag_id = business_tag.tag_id
with read only;

create or replace view view_business_hour
as
select
business_hour.*,
to_char(business_hour.open_time, 'fmHHfm:MI am') as open_time_text,
to_char(business_hour.close_time, 'fmHHfm:MI am') as close_time_text,
config_weekday.weekday_name
from business_hour
left join config_weekday
on config_weekday.weekday_id = business_hour.weekday_id
with read only;

create or replace view view_review_info
as
select
review.*,
(select count(*) from vote where vote.review_id = review.review_id) as like_count
from review
with read only;

create or replace view view_business_attr_text
as
select
business_attr_text.text_id,
business_attr_text.business_id,
business_attr_text.attr_id,
config_business_attr.attr_name,
config_business_attr.attr_type,
business_attr_text.text_value,
business_attr_text.modification_time,
business_attr_text.creation_time
from business_attr_text
left join config_business_attr
on business_attr_text.attr_id = config_business_attr.attr_id
with read only;

create or replace view view_business_attr_number
as
select
business_attr_number.number_id,
business_attr_number.business_id,
business_attr_number.attr_id,
config_business_attr.attr_name,
config_business_attr.attr_type,
business_attr_number.number_value,
business_attr_number.modification_time,
business_attr_number.creation_time
from business_attr_number
left join config_business_attr
on business_attr_number.attr_id = config_business_attr.attr_id
with read only;

create or replace view view_business_attr_date
as
select
business_attr_date.date_id,
business_attr_date.business_id,
business_attr_date.attr_id,
config_business_attr.attr_name,
config_business_attr.attr_type,
business_attr_date.date_value,
business_attr_date.modification_time,
business_attr_date.creation_time
from business_attr_date
left join config_business_attr
on business_attr_date.attr_id = config_business_attr.attr_id
with read only;

