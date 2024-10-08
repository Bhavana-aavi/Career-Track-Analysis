select count(a.track_completed) from(
select a.student_track_id,
    a.student_id,
    a.track_name,
    a.date_enrolled,
    a.track_completed,
    a.days_for_completion,
case 
	when days_for_completion = 0 then 'Same day'
    when days_for_completion between 1 and 7 then '1 to 7 days'
    when days_for_completion between 8 and 30 then '8 to 30 days'
    when days_for_completion between 31 and 60 then '31 to 60 days'
    when days_for_completion between 61 and 90 then '61 to 90 days'
    when days_for_completion between 91 and 365 then '91 to 365 days'
    ELSE '366+ days' 
    end as completion_bucket
from
(select e.student_id, i.track_name, e.date_enrolled, e.date_completed, 
ROW_NUMBER () OVER (order by e.student_id, i.track_name desc) as student_track_id,
IF (e.date_completed is null, 0, 1) as track_completed,
DATEDIFF (e.date_completed, e.date_enrolled) as days_for_completion
from career_track_student_enrollments e
join career_track_info i
on e.track_id = i.track_id) a)a;