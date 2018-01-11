--tables
create table config_dropdown(
drop_category varchar2(50 byte) not null,
drop_option varchar2(50 byte) not null,
drop_description varchar2(50 byte),
constraint pk_config_dropdown primary key (drop_category, drop_option)
);

create table config_user_type(
user_type_id number(38,0) not null,
user_type_name varchar2(30 byte) not null,
view_user_settings number(1,0) not null,
modify_user_settings number(1,0) not null,
view_user_profile number(1,0) not null,
view_business number(1,0) not null,
create_business number(1,0) not null,
modify_business number(1,0) not null,
delete_business number(1,0) not null,
view_review number(1,0) not null,
create_review number(1,0) not null,
modify_review number(1,0) not null,
delete_review number(1,0) not null,
create_vote number(1,0) not null,
delete_vote number(1,0) not null,
view_business_dashboard number(1,0) not null,
view_business_analysis number(1,0) not null,
search_business number(1,0) not null,
constraint pk_user_type_id primary key (user_type_id),
constraint uk_user_type_name unique (user_type_name)
);

create table config_tag(
tag_id number(38,0) not null,
tag_name varchar2(30 byte) not null,
constraint pk_tag_id primary key (tag_id),
constraint uk_tag_name unique (tag_name)
);

create table config_weekday(
weekday_id number(38,0) not null,
weekday_name varchar2(10 byte) not null,
constraint pk_weekday_id primary key (weekday_id),
constraint uk_weekday_name unique (weekday_name)
);

create table config_business_attr(
attr_id number(38,0) not null,
attr_name varchar2(50 byte) not null,
attr_type varchar2(10 byte) not null,
constraint pk_attr_id primary key (attr_id)
);

create table config_business_attr_drop(
attr_id number(38,0) not null,
drop_option varchar2(50 byte) not null,
constraint pk_config_business_attr_drop primary key (attr_id, drop_option),
constraint fk_attr_id_cbad foreign key (attr_id) references config_business_attr(attr_id)
);

create table user_info(
user_id number(38,0) not null,
user_type_id number(38,0) not null,
first_name varchar2(50 byte) not null,
last_name varchar2(50 byte) not null,
email varchar2(100 byte) not null,
city varchar2(50 byte) not null,
state varchar2(5 byte) not null,
modification_time date,
creation_time date,
constraint pk_user_id primary key (user_id),
constraint uk_user_email unique (email),
constraint fk_user_type_id_ui foreign key (user_type_id) references config_user_type(user_type_id)
);

create table user_credential(
user_id number(38,0) not null,
salt varchar2(255 byte),
password varchar2(255 byte) not null,
modification_time date,
creation_time date,
constraint pk_user_credential primary key (user_id),
constraint uk_salt unique (salt),
constraint uk_password unique (password),
constraint fk_user_id_uc foreign key (user_id) references user_info(user_id)
);

create table user_access_token(
token_id number(38,0) not null,
user_id number(38,0) not null,
token varchar2(255 byte) not null,
modification_time date,
creation_time date,
constraint pk_token_id primary key (token_id),
constraint uk_token unique (token),
constraint fk_user_id_uat foreign key (user_id) references user_info(user_id)
);

create table business(
business_id number(38,0) not null,
business_name varchar2(100 byte) not null,
address_line1 varchar2(100 byte),
address_line2 varchar2(100 byte),
city varchar2(50 byte) not null,
state varchar2(5 byte) not null,
zip varchar2(10 byte),
phone varchar2(30 byte),
website varchar2(100 byte),
latitude number(11,8),
longitude number(11,8),
price_range number(1,0),
status varchar2(10 byte) not null,
modification_time date,
creation_time date,
constraint pk_business_id primary key (business_id),
constraint check_price_range check (price_range in (1, 2, 3, 4))
);

create table business_tag(
business_id number(38,0) not null,
tag_id number(38,0) not null,
modification_time date,
creation_time date,
constraint pk_business_tag primary key (business_id, tag_id),
constraint fk_business_id_bt foreign key (business_id) references business(business_id),
constraint fk_tag_id_bt foreign key (tag_id) references config_tag(tag_id)
);

create table business_hour(
hour_id number(38,0) not null,
business_id number(38,0) not null,
weekday_id number(38,0) not null,
open_time date not null,
close_time date not null,
modification_time date,
creation_time date,
constraint pk_hour_id primary key (hour_id),
constraint uk_business_hour_weekday unique (business_id, weekday_id),
constraint fk_business_id_bh foreign key (business_id) references business(business_id),
constraint fk_weekday_id_bh foreign key (weekday_id) references config_weekday(weekday_id)
);

create table business_ownership(
business_id number(38,0) not null,
owner_id number(38,0) not null,
modification_time date,
creation_time date,
constraint pk_business_ownership primary key (business_id),
constraint fk_business_id_bo foreign key (business_id) references business(business_id),
constraint fk_user_id_bo foreign key (owner_id) references user_info(user_id)
);

create table review(
review_id number(38,0) not null,
user_id number(38,0) not null,
business_id number(38,0) not null,
rating number(2,1) not null,
text clob not null,
modification_time date,
creation_time date,
constraint pk_review_id primary key (review_id),
constraint fk_user_id_r foreign key (user_id) references user_info(user_id),
constraint fk_business_id_r foreign key (business_id) references business(business_id),
constraint check_rating check (rating in (1, 2, 3, 4, 5))
);

create table vote(
vote_id number(38,0) not null,
user_id number(38,0) not null,
review_id number(38,0) not null,
modification_time date,
creation_time date,
constraint pk_vote_id primary key (vote_id),
constraint uk_vote_user_review unique (user_id, review_id),
constraint fk_user_id_v foreign key (user_id) references user_info(user_id),
constraint fk_review_id_v foreign key (review_id) references review(review_id)
);

create table image(
image_id number(38,0) not null,
image_url varchar2(255 byte) not null,
caption varchar2(255 byte),
modification_time date,
creation_time date,
constraint pk_image_id primary key (image_id),
constraint uk_image_url unique (image_url)
);

create table user_image(
user_id number(38,0) not null,
image_id number(38,0) not null,
modification_time date,
creation_time date,
constraint pk_user_image primary key (image_id),
constraint fk_user_id_ui foreign key (user_id) references user_info(user_id),
constraint fk_image_id_ui foreign key (image_id) references image(image_id)
);

create table business_image(
business_id number(38,0) not null,
image_id number(38,0) not null,
modification_time date,
creation_time date,
constraint pk_business_image primary key (image_id),
constraint fk_business_id_bi foreign key (business_id) references business(business_id),
constraint fk_image_id_bi foreign key (image_id) references image(image_id)
);

create table business_attr_text(
text_id number(38,0) not null,
business_id number(38,0) not null,
attr_id number(38,0) not null,
text_value varchar2(255 byte) not null,
modification_time date,
creation_time date,
constraint pk_text_id primary key (text_id),
constraint uk_business_attr_text unique (business_id, attr_id),
constraint fk_business_id_bat foreign key (business_id) references business(business_id),
constraint fk_attr_id_bat foreign key (attr_id) references config_business_attr(attr_id)
);

create table business_attr_number(
number_id number(38,0) not null,
business_id number(38,0) not null,
attr_id number(38,0) not null,
number_value number(38,6) not null,
modification_time date,
creation_time date,
constraint pk_number_id primary key (number_id),
constraint uk_business_attr_number unique (business_id, attr_id),
constraint fk_business_id_ban foreign key (business_id) references business(business_id),
constraint fk_attr_id_ban foreign key (attr_id) references config_business_attr(attr_id)
);

create table business_attr_date(
date_id number(38,0) not null,
business_id number(38,0) not null,
attr_id number(38,0) not null,
date_value date not null,
modification_time date,
creation_time date,
constraint pk_date_id primary key (date_id),
constraint uk_business_attr_date unique (business_id, attr_id),
constraint fk_business_id_bad foreign key (business_id) references business(business_id),
constraint fk_attr_id_bad foreign key (attr_id) references config_business_attr(attr_id)
);

