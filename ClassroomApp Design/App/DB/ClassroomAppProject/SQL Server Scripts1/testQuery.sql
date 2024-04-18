Select	c.title, u.name as teacher_name, 
		AVG(Cast(cr.rating as Float)) as Avg_rating,  
		COUNT(*) as Num_reviews
from	courses c join teachers t on c.teacher_id = t.id
		join users u on t.id = u.id
		join course_review cr on c.id = cr.course_id
where c.id = 1
Group by c.title, u.name;


Select  ss.title, sst.status
From	sessions ss join courses c on ss.course_id = c.id
		join session_status sst on ss.id = sst.session_id
where	c.id = 1 and sst.student_id = 3;
	
Select  Count(*) as Total_sessions
From	sessions ss join courses c on ss.course_id = c.id
where	c.id = 1;

Select  Count(*) as Completed_num
From	sessions ss join courses c on ss.course_id = c.id
		join session_status sst on ss.id = sst.session_id
where	c.id = 1 and sst.student_id = 3 and sst.status = 'Completed';

Select	Count(*) as Total_discussion
From	session_discuss ssd
Where	ssd.session_id = 1;

Select	ssd.*
From	session_discuss ssd
Where	ssd.session_id = 1;