with a as
(
  select
    NTILE(4) OVER (PARTITION BY SUBJECT ORDER BY SCORE DESC) AS NTILE,
    full_name,
    trim(class, ' ') class,
    subject,
    score
  from 
  PD2023_WK23_RESULTS r
  unpivot(score for subject in (english, economics, psychology))
  join 
  PD2023_WK23_STUDENT_INFO si
  on r.student_id = si.x_student_id
)
,

b as 
(
  select full_name,
    subject,
    class,
    range,
    case
      when (class = '9A' or class = '9B') and ntile = 4 then 1
      else 0
    end flag
  from 
  a
  join
  PD2023_WK24_TILES t
  on t.number = a.ntile
)
,

c as
(
  select full_name,
    case
      when sum(b.flag) >= 2 then 'Yes'
      else 'No'
    end as flag
    from b
    group by 1
    having sum(b.flag) >= 2
)

  select b.full_name, 
    c.flag as flag, 
    b.class, 
    MAX("'ENGLISH'") as english, 
    MAX("'ECONOMICS'") as economics, 
    MAX("'PSYCHOLOGY'") as psychology
  from b
  pivot(min(range) for subject in ('ENGLISH', 'ECONOMICS', 'PSYCHOLOGY'))
  join c
  on b.full_name = c.full_name
  group by 1, 2, 3
  ORDER BY b.FULL_NAME;