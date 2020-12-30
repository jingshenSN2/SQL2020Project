-- 增加员工
create procedure pku_company.admin_add_employee (
	_name VARCHAR(20),
	_gender ENUM('F', 'M'),
	_birthdate DATE,
	_nationid CHAR(18),
	_tel VARCHAR(11),
	_email VARCHAR(30),
	_hiredate DATE,
	_level ENUM('Employee', 'Manager', 'Admin'),
	_dept_id INT) 
    insert into pku_company.employee values 
		(null, _name, _gender, _birthdate, _nationid, _tel, _email, _hiredate, _level, _dept_id);

-- 增加部门
create procedure pku_company.admin_add_department(
	_dept_id INT,
	_dept_name VARCHAR(20),
	_description VARCHAR(50),
	_manager_id INT)
    insert into pku_company.department values
		(_dept_id, _dept_name, _description, _manager_id);

-- 修改员工信息
delimiter $$
create procedure pku_company.admin_alter_employee (
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
		if _name is not null then set @name = _name; end if;
		if _gender is not null then set @gender = _gender; end if;
		if _birthdate is not null then set @birthdate = _birthdate; end if;
		if _nationid is not null then set @nationid = _nationid; end if;
		if _hiredate is not null then set @hiredate = _hiredate; end if;
		if _level is not null then set @level = _level; end if;
		if _dept_id is not null then set @dept_id = _dept_id; end if;
		update pku_company.employee set 
			name = @name, gender = @gender, birthdate = @birthdate, nationid = @nationid, 
			tel = _tel, email = _email, hiredate = @hiredate, level = @level, dept_id = @dept_id
			where e_id = _e_id;
	end$$
delimiter ;
        
-- 修改部门信息
create procedure pku_company.admin_alter_department(
	_dept_id INT,
	_dept_name VARCHAR(20),
	_description VARCHAR(50),
	_manager_id INT)
    update pku_company.department set
		dept_name = _dept_name, description = _description, manager_id = _manager_id
        where dept_id = _dept_id;

-- 修改考勤表
delimiter $$
create procedure pku_company.admin_alter_attend(
	_attend_id INT,
	_e_id INT,
	_date DATE,
	_in_time TIME,
	_out_time TIME,
	_is_late TINYINT,
	_is_overtime TINYINT,
	_is_absence TINYINT)
    begin
		if _e_id is not null then set @e_id = _e_id; end if;
		if _date is not null then set @date = _date; end if;
		update pku_company.attend set
			e_id = @e_id, date = @date, in_time = _in_time, out_time = _out_time, 
			is_late = _is_late, is_overtime = _is_overtime, is_absence = _is_absence
			where attend_id = _attend_id;
	end$$
delimiter ;

-- 修改请假表
delimiter $$
create procedure pku_company.admin_alter_leaving (
	_leave_id INT,
	_e_id INT,
	_reason VARCHAR(40),
	_summit_time DATE,
	_start_time DATE,
	_end_time DATE,
	_verifier_id INT,
	_status ENUM('Summited', 'Approved', 'Rejected'))
    begin
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
	end$$
delimiter ;

-- 修改工资表
delimiter $$
create procedure pku_company.admin_alter_salary (
	_salary_id INT,
    _e_id INT,
    _ym DATE,
    _basic_salary DECIMAL(10,2),
    _deduction DECIMAL(10,2),
    _award DECIMAL(10,2),
	_pay_time DATETIME,
	_verifier_id INT)
    begin
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
	end$$
delimiter ;

-- 删除员工
create procedure pku_company.admin_delete_employee (_e_id INT)
	delete from pku_company.employee
		where e_id = _e_id;

-- 删除部门
delimiter $$
create procedure pku_company.admin_delete_department(_dept_id INT)
	begin
		update pku_company.employee set
			dept_id = null
			where dept_id = _dept_id;
		delete from pku_company.department
			where dept_id = _dept_id;
	end$$
delimiter ;

-- 删除考勤记录
create procedure pku_company.admin_delete_attend(_attend_id INT)
    delete from pku_company.attend 
		where attend_id = _attend_id;

-- 删除请假记录
create procedure pku_company.admin_delete_leaving(_leave_id INT)
    delete from pku_company.leaving 
		where leave_id = _leave_id;

-- 删除工资记录
create procedure pku_company.admin_delete_salary(_salary_id INT)
    delete from pku_company.salary
		where salary_id = _salary_id;

-- 审核请假记录
create procedure pku_company.admin_verify_leaving(
	_leave_id INT,
	_status ENUM('Approved', 'Rejected'))
    call pku_company.admin_alter_leaving(_leave_id, null, null, null, null, null, substring_index(user(), '@', 1), _status);

-- 审核工资记录
create procedure pku_company.admin_verify_salary(_salary_id INT)
    call pku_company.admin_alter_salary(_salary_id, null, null, null, null, null, null, substring_index(user(), '@', 1))

