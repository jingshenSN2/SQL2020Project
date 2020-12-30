-- 查询个人基本信息
delimiter $$
create procedure pku_company.employee_view_info()
	begin
		set @operator_id = substring_index(user(), '@', 1);
		select * from pku_company.basic_info_view
			where e_id = @operator_id;
	end$$
delimiter ;

-- 查询本人考勤信息
delimiter $$
create procedure pku_company.employee_view_attend()
	begin
		set @operator_id = substring_index(user(), '@', 1);
		select * from pku_company.attend_view
			where e_id = @operator_id;
	end$$
delimiter ;

-- 查询本人请假信息
delimiter $$
create procedure pku_company.employee_view_leaving(_e_id INT)
	begin
		set @operator_id = substring_index(user(), '@', 1);
		select * from pku_company.leaving_view
			where e_id = @operator_id;
	end$$
delimiter ;

-- 查询本人工资信息
delimiter $$
create procedure pku_company.employee_view_salary(_e_id INT)
	begin
		set @operator_id = substring_index(user(), '@', 1);
		select * from pku_company.salary_view
			where e_id = @operator_id;
	end$$
delimiter ;

-- 修改电话
delimiter $$
create procedure pku_company.employee_alter_tel(_tel VARCHAR(11))
	begin
		set @operator_id = substring_index(user(), '@', 1);
		update pku_company.employee set
			tel = _tel
            where e_id = @operator_id;
	end$$
delimiter ;

-- 修改邮箱
delimiter $$
create procedure pku_company.employee_alter_email(_email VARCHAR(30))
	begin
		set @operator_id = substring_index(user(), '@', 1);
		update pku_company.employee set
			email = _email
            where e_id = @operator_id;
	end$$
delimiter ;

-- 上班打卡
delimiter $$
create procedure pku_company.employee_check_in(
	_date DATE,
    _in_time TIME)
	begin
		set @operator_id = substring_index(user(), '@', 1);
		update pku_company.attend set
			in_time = _in_time
            where e_id = @operator_id and date = _date;
		set @timediff = timediff(_in_time, '09:00');
        if @timediff > 0 then -- 迟到
			update pku_company.attend set
			is_late = 1
            where e_id = @operator_id and date = _date;
        end if;
	end$$
delimiter ;

-- 下班打卡
delimiter $$
create procedure pku_company.employee_check_out(
	_date DATE,
    _out_time TIME)
	begin
		set @operator_id = substring_index(user(), '@', 1);
		update pku_company.attend set
			out_time = _out_time
            where e_id = @operator_id and date = _date;
		set @timediff = timediff(_out_time, '19:00');
        if @timediff > 0 then -- 加班
			update pku_company.attend set
			is_overtime = 1
            where e_id = @operator_id and date = _date;
        end if;
	end$$
delimiter ;

-- 提交请假申请
delimiter $$
create procedure pku_company.employee_summit_leaving(
	_reason VARCHAR(40),
	_summit_time DATE,
	_start_time DATE,
	_end_time DATE)
	begin
		set @operator_id = substring_index(user(), '@', 1);
		insert into pku_company.leaving values
			(null, @operator_id, _reason, _summit_time, _start_time, _end_time, null, 'Summited');
	end$$
delimiter ;