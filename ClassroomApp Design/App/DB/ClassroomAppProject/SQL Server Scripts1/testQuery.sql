USE ClassroomApp;

Select	c.title, u.name as teacher_name, 
		AVG(Cast(cr.rating as Float)) as Avg_rating,  
		COUNT(*) as Num_reviews
From	courses c
		join users u on c.teacher_id = u.id
		join course_review cr on c.id = cr.course_id
Where	c.id = 1
Group by c.title, u.name;


Select  ss.order_index as order_id, 
		ss.title as session_title, 
		sstype.status_name as status,
		sst.update_at as last_modify
From	session_status sst
		join sessions ss on sst.session_id = ss.id 
		join session_status_type sstype on sst.status_id = sstype.id
where	ss.course_id = 1 and sst.student_id = 3;

Select  Top 1
		ss.order_index as order_id, 
		ss.title as session_title, 
		sstype.status_name as status,
		sst.update_at as last_modify
From	session_status sst
		join sessions ss on sst.session_id = ss.id 
		join session_status_type sstype on sst.status_id = sstype.id
where	ss.course_id = 1 and sst.student_id = 3
Order By sst.update_at DESC;
	
Select  Count(*) as Total_sessions
From	sessions ss join courses c on ss.course_id = c.id
where	c.id = 1;

Select  Count(*) as Completed_num
From	sessions ss join courses c on ss.course_id = c.id
		join session_status sst on ss.id = sst.session_id
where	c.id = 1 and sst.student_id = 3 and sst.status_id = 1;

Select	Count(*) as Total_discussion
From	session_discuss ssd
Where	ssd.session_id = 1;

Select	ssd.*
From	session_discuss ssd
Where	ssd.session_id = 1;

Select	ssd.id as discuss_id, img.image_path as img_path
From	session_discuss ssd 
		join session_discuss_image ssdi on ssd.id = ssdi.session_discuss_id
		join images img on ssdi.image_id = img.id 
where	ssd.session_id = 1;


select	u.id, 
		u.name, 
		count(e.course_id) as num_courses
from	users u
left join	enrollments e on u.id = e.student_id
inner join	user_role ur on	u.id = ur.userId
where ur.roleId = 2
group by	u.id, 
			u.name;

with max_course_num as (
	select	u.id, 
			u.name,
			count(e.course_id) as num_courses
	from	users u
	left join	enrollments e on u.id = e.student_id
	inner join	user_role ur on	u.id = ur.userId
	where ur.roleId = 2
	group by	u.id,
				u.name
)

select	*
from	max_course_num
where	num_courses = (select min(num_courses) from max_course_num);