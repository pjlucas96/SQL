select t.online_or_in_person,
  ltrim(t.quarter,'Q') as Quarter,
  t.quarterly_targets,
  sum(s.value) as total_value,
  t.quarterly_targets - sum(s.value) as variance
  from "PD2023_WK03_TARGETS" t
unpivot(Quarterly_Targets for quarter in (Q1, Q2, Q3, Q4))
inner join "PD2023_WK01" s
on ltrim(t.quarter, 'Q') = EXTRACT('QUARTER',to_date(s.transaction_date, 'DD/MM/YYYY HH:MI:SS')::TIMESTAMP_NTZ)
and t.online_or_in_person = case
    when s.online_or_in_person = 1 then 'Online'
    when s.online_or_in_person = 2 then 'In-Person'
end
where split_part(s.transaction_code, '-', 1) = 'DSB'
group by 1, 2, 3
;