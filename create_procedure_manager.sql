-- 查询下属员工信息
create procedure pku_company.manager_view_employee(_manager_id INT)
	select * from pku_company.basic_info_view
		where manager_id =_manager_id and e_id <> _manager_id;

-- 查询下属员工的考勤信息
create procedure pku_company.manager_view_employee_attend(_manager_id INT)
	select * from pku_company.attend_view
		where manager_id = _manager_id;

-- 查询下属员工的请假信息
create procedure pku_company.manager_view_employee_leaving(_manager_id INT)
	select * from pku_company.leaving_view
		where manager_id = _manager_id;

-- 查询下属员工的工资信息
create procedure pku_company.manager_view_employee_salary(_manager_id INT)
	select * from pku_company.salary_view
		where manager_id = _manager_id;

-- 修改部门信息
create procedure pku_company.manager_alter_department (
	_manager_id INT,
    _dept_name VARCHAR(20),
    _description VARCHAR(50))
	update pku_company.department set
		dept_name = _dept_name, description = _description
		where manager_id = _manager_id;

-- 修改下属员工信息
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
    update pku_company.employee set 
		name = _name, gender = _gender, birthdate = _birthdate, nationid = _nationid, 
		tel = _tel, email = _email, hiredate = _hiredate, level = _level, dept_id = _dept_id
		where e_id = _e_id;

-- 修改下属考勤表
create procedure pku_company.manager_alter_attend(
	_attend_id INT,
	_e_id INT,
	_date DATE,
	_in_time TIME,
	_out_time TIME,
	_is_late TINYINT,
	_is_overtime TINYINT,
	_is_absence TINYINT)
    update pku_company.attend set
		e_id = _e_id, date = _date, in_time = _in_time, out_time = _out_time, 
		is_late = _is_late, is_overtime = _is_overtime, is_absence = _is_absence
		where attend_id = _attend_id;

-- 修改下属请假表
create procedure pku_company.manager_alter_leaving (
	_leave_id INT,
	_e_id INT,
	_reason VARCHAR(40),
	_summit_time DATE,
	_start_time DATE,
	_end_time DATE,
	_verifier_id INT,
	_status ENUM('Summited', 'Approved', 'Rejected'))
	update pku_company.leaving set
		e_id = _e_id, reason = _reason, summit_time = _summit_time, start_time = _start_time,
		end_time = _end_time, verifier_id = _verifier_id, status = _status
		where leave_id = _leave_id;

-- 修改下属工资表
create procedure pku_company.manager_alter_salary (
	_salary_id INT,
    _e_id INT,
    _ym DATE,
    _basic_salary DECIMAL(10,2),
    _deduction DECIMAL(10,2),
    _award DECIMAL(10,2),
	_pay_time DATETIME,
	_verifier_id INT)
    update pku_company.salary set
		e_id = _e_id, ym = _ym, basic_salary = _basic_salary, deduction = _deduction,
		award = _award, pay_time = _pay_time, verifier_id = _verifier_id
		where salary_id = _salary_id;

-- 审核请假记录
create procedure pku_company.manager_verify_leaving(
	_manager_id INT,
	_leave_id INT,
	_status ENUM('Approved', 'Rejected'))
    update pku_company.leaving set
		verifier_id = _manager_id, status = _status
		where leave_id = _leave_id;

-- 审核工资记录
create procedure pku_company.manager_verify_salary(_manager_id INT, _salary_id INT)
    update pku_company.salary set
		verifier_id = _manager_id
		where salary_id = _salary_id;



