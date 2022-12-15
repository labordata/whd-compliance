create table flsa_details as select right.id as violation_id, left.type, left.back_wages from violations as left inner join violations as right using (case_id) where left.violations is null and right.type = 'flsa';

delete from violations where violations is null;
