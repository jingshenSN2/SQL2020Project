-- 查询下属员工信息
delimiter $$
create procedure pku_company.manager_view_employee()
	begin
		set @operator_id = substring_index(user(), '@', 1);
		select * from pku_company.basic_info_view
			where manager_id = @operator_id and e_id <> @operator_id;
	end$$
delimiter ;

-- 查询下属员工的考勤信息
delimiter $$
create procedure pku_company.manager_view_employee_attend(_e_id INT)
	begin
		set @operator_id = substring_index(user(), '@', 1);
		if @operator_id not in 
			(select manager_id from basic_info_view where e_id = _e_id) then
			resignal set message_text = '权限不足！';
		else
			select * from pku_company.attend_view
				where manager_id = @operator_id and e_id = _e_id;
		end if;
	end$$
delimiter ;

-- 查询下属员工的请假信息
delimiter $$
create procedure pku_company.manager_view_employee_leaving(_e_id INT)
	begin
		set @operator_id = substring_index(user(), '@', 1);
		if @operator_id not in 
			(select manager_id from basic_info_view where e_id = _e_id) then
			resignal set message_text = '权限不足！';
		else
			select * from pku_company.leaving_view
				where manager_id = @operator_id and e_id = _e_id;
		end if;
	end$$
delimiter ;

-- 查询下属员工的工资信息
delimiter $$
create procedure pku_company.manager_view_employee_salary(_e_id INT)
	begin
		set @operator_id = substring_index(user(), '@', 1);
		if @operator_id not in 
			(select manager_id from basic_info_view where e_id = _e_id) then
			resignal set message_text = '权限不足！';
		else
			select * from pku_company.salary_view
				where manager_id = @operator_id and e_id = _e_id;
		end if;
	end$$
delimiter ;

-- 修改部门信息
delimiter $$
create procedure pku_company.manager_alter_department (
	_dept_id INT,
    _dept_name VARCHAR(20),
    _description VARCHAR(50))
    begin
		set @operator_id = substring_index(user(), '@', 1);
		if @operator_id not in (select manager_id from department where dept_id = _dept_id) then
			resignal set message_text = '权限不足！';
		else
			if _dept_name is not null then set @dept_name = _dept_name; end if;
			if _description is not null then set @description = _description; end if;
			update pku_company.department set
				dept_name = @dept_name, description = @description
				where dept_id = _dept_id and manager_id = @operator_id;
		end if;
    end$$
delimiter ;

-- 修改下属员工信息
delimiter $$
create procedure pku_company.manager_alter_employee (
	_e_id INT,
	_name VARCHAR(20),
	_gender ENUM('F', 'M'),
	_birthdate DATE,
	_nationid CHAR(18),
	_tel VARCHAR(11),
	_email VARCHAR(30),
	_hiredate DATE,
	_level ENUM('Employee', 'Manager', 'Admin'),
	_dept_id INT) 
    begin
		set @operator_id = substring_index(user(), '@', 1);
		if @operator_id not in 
			(select manager_id from basic_info_view where e_id = _e_id) then
			resignal set message_text = '权限不足！';
		else
			update pku_company.employee set 
				name = _name, gender = _gender, birthdate = _birthdate, nationid = _nationid, 
				tel = _tel, email = _email, hiredate = _hiredate, level = _level, dept_id = _dept_id
				where e_id = _e_id;
		end if;
    end$$
delimiter ;

-- 修改下属考勤表
delimiter $$
create procedure pku_company.manager_alter_attend(
	_attend_id INT,
	_e_id INT,
	_date DATE,
	_in_time TIME,
	_out_time TIME,
	_is_late TINYINT,
	_is_overtime TINYINT,
	_is_absence TINYINT)
    begin
		set @operator_id = substring_index(user(), '@', 1);
		if @operator_id not in 
			(select manager_id from basic_info_view where e_id = _e_id) then
			resignal set message_text = '权限不足！';
		else
			if _e_id is not null then set @e_id = _e_id; end if;
			if _date is not null then set @date = _date; end if;
			update pku_company.attend set
				e_id = @e_id, date = @date, in_time = _in_time, out_time = _out_time, 
				is_late = _is_late, is_overtime = _is_overtime, is_absence = _is_absence
				where attend_id = _attend_id;
		end if;
	end$$
delimiter ;

-- 修改下属请假表
delimiter $$
create procedure pku_company.manager_alter_leaving (
	_leave_id INT,
	_e_id INT,
	_reason VARCHAR(40),
	_summit_time DATE,
	_start_time DATE,
	_end_time DATE,
	_verifier_id INT,
	_status ENUM('Summited', 'Approved', 'Rejected'))
    begin
		set @operator_id = substring_index(user(), '@', 1);
		if @operator_id not in 
			(select manager_id from basic_info_view where e_id = _e_id) then
			resignal set message_text = '权限不足！';
		else
			if _e_id is not null then set @e_id = _e_id; end if;
			if _reason is not null then set @reason = _reason; end if;
			if _summit_time is not null then set @summit_time = _summit_time; end if;
			if _start_time is not null then set @start_time = _start_time; end if;
			if _end_time is not null then set @end_time = _end_time; end if;
			if _verifier_id is not null then set @verifier_id = _verifier_id; end if;
			if _status is not null then set @status = _status; end if;
			update pku_company.leaving set
				e_id = @e_id, reason = @reason, summit_time = @summit_time, start_time = @start_time,
				end_time = @end_time, verifier_id = @verifier_id, status = @status
				where leave_id = _leave_id;
		end if;
	end$$
delimiter ;

-- 修改下属工资表
delimiter $$
create procedure pku_company.manager_alter_salary (
	_salary_id INT,
    _e_id INT,
    _ym DATE,
    _basic_salary DECIMAL(10,2),
    _deduction DECIMAL(10,2),
    _award DECIMAL(10,2),
	_pay_time DATETIME,
	_verifier_id INT)
    begin
		set @operator_id = substring_index(user(), '@', 1);
		if @operator_id not in 
			(select manager_id from basic_info_view where e_id = _e_id) then
			resignal set message_text = '权限不足！';
		else
			if _e_id is not null then set @e_id = _e_id; end if;
			if _ym is not null then set @ym = _ym; end if;
			if _basic_salary is not null then set @basic_salary = _basic_salary; end if;
			if _deduction is not null then set @deduction = _deduction; end if;
			if _award is not null then set @award = _award; end if;
			if _pay_time is not null then set @pay_time = _pay_time; end if;
			if _verifier_id is not null then set @verifier_id = _verifier_id; end if;
			update pku_company.salary set
				e_id = @e_id, ym = @ym, basic_salary = @basic_salary, deduction = @deduction,
				award = @award, pay_time = @pay_time, verifier_id = @verifier_id
				where salary_id = _salary_id;
		end if;
	end$$
delimiter ;

-- 审核请假记录
create procedure pku_company.manager_verify_leaving(
	_leave_id INT,
	_status ENUM('Approved', 'Rejected'))
    call pku_company.manager_alter_leaving(_leave_id, null, null, null, null, null, substring_index(user(), '@', 1), _status);

-- 审核工资记录
create procedure pku_company.manager_verify_salary(_salary_id INT)
    call pku_company.manager_alter_salary(_salary_id, null, null, null, null, null, null, substring_index(user(), '@', 1))



