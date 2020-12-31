-- 查询个人基本信息
create procedure pku_company.employee_view_info(_e_id INT)
	select * from pku_company.basic_info_view where e_id = _e_id;

-- 查询本人考勤信息
create procedure pku_company.employee_view_attend(_e_id INT)
	select * from pku_company.attend_view where e_id = _e_id;

-- 查询本人请假信息
create procedure pku_company.employee_view_leaving(_e_id INT)
	select * from pku_company.leaving_view where e_id = _e_id;

-- 查询本人工资信息
create procedure pku_company.employee_view_salary(_e_id INT)
	select * from pku_company.salary_view where e_id = _e_id;

-- 修改电话
create procedure pku_company.employee_alter_tel(_e_id INT, _tel VARCHAR(11))
	update pku_company.employee set tel = _tel where e_id = _e_id;

-- 修改邮箱
create procedure pku_company.employee_alter_email(_e_id INT, _email VARCHAR(30))
	update pku_company.employee set email = _email where e_id = _e_id;

-- 上班打卡
create procedure pku_company.employee_check_in(
	_e_id INT,
	_date DATE,
    _in_time TIME)
	update pku_company.attend set
		in_time = _in_time, is_late = (timediff(_in_time, '09:00') > 0)
        where e_id = _e_id and date = _date;

-- 下班打卡
create procedure pku_company.employee_check_out(
	_e_id INT,
	_date DATE,
    _out_time TIME)
	update pku_company.attend set
		out_time = _out_time, is_overtime = (timediff(_out_time, '19:00') > 0)
		where e_id = _e_id and date = _date;

-- 提交请假申请
create procedure pku_company.employee_summit_leaving(
	_e_id INT,
	_reason VARCHAR(40),
	_summit_time DATE,
	_start_time DATE,
	_end_time DATE)
	insert into pku_company.leaving values
			(null, _e_id, _reason, _summit_time, _start_time, _end_time, null, 'Summited');