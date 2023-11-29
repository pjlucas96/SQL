with a as
(
select
class,
subject,
round(avg(score),1) score
from 
PD2023_WK23_RESULTS r
unpivot(score for subject in (english, economics, psychology))
join 
PD2023_WK23_STUDENT_INFO si
on r.student_id = si.x_student_id
group by 1,2
)

select subject, class, score
from a
order by rank () over (partition by subject order by score)
limit 3;