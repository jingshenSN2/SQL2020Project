-- 员工基本信息视图
create view basic_info_view as 
	select e.e_id, e.name, e.gender, e.birthdate, e.tel, e.email,
		e.dept_id, d.dept_name, d.manager_id, e.level
		from employee as e left outer join department as d
        on e.dept_id = d.dept_id;

-- 考勤表视图
create view attend_view as
	select e.e_id, a.attend_id, e.name, e.dept_id, d.manager_id, a.date, a.in_time, a.out_time
		from attend as a join employee as e left outer join department as d
        on e.dept_id = d.dept_id;

-- 请假表视图
create view leaving_view as
	select e.e_id, l.leave_id, e.name, e.dept_id, d.manager_id, l.start_time, l.end_time, 
		l.reason, l.summit_time, l.verifier_id, l.status
		from leaving as l join employee as e left outer join department as d
        on e.dept_id = d.dept_id;

-- 工资表视图
create view salary_view as
	select e.e_id, s.salary_id, e.name, e.dept_id, d.manager_id, s.basic_salary,
		s.deduction, s.award, s.real_salary, s.ym, s.pay_time, s.verifier_id
		from salary as s join employee as e left outer join department as d
        on e.dept_id = d.dept_id;
