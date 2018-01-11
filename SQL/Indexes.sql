--indexes
create index in_user_id_r on review(user_id);
create index in_user_id_v on vote(user_id);
create index in_user_id_bo on business_ownership(owner_id);
create index in_user_id_ui on user_image(user_id);

/*
indexes on business_id make the search_business query much faster (time consumed decreased from 15+ seconds to 1 second)
also make business_details and user_details 10-time faster
*/
create index in_business_id_bt on business_tag(business_id);
create index in_business_id_bh on business_hour(business_id);
create index in_business_id_bat on business_attr_text(business_id);
create index in_business_id_ban on business_attr_number(business_id);
create index in_business_id_bad on business_attr_date(business_id);
create index in_business_id_r on review(business_id);
create index in_business_id_bi on business_image(business_id);

create index in_tag_id_bt on business_tag(tag_id);

create index in_review_id_v on vote(review_id);

create index in_rating_r on review(rating);

create index in_test on review(creation_time);

