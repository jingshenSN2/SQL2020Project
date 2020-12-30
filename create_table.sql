CREATE TABLE `pku_company`.`employee` (
	`e_id` INT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(20) NOT NULL,
	`gender` ENUM('F', 'M') NOT NULL,
	`birthdate` DATE NOT NULL,
	`nationid` CHAR(18) NOT NULL,
	`tel` VARCHAR(11),
	`email` VARCHAR(30),
	`hiredate` DATE NOT NULL,
	`level` ENUM('Employee', 'Manager', 'Admin') NOT NULL,
	`dept_id` INT,
	PRIMARY KEY (`e_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 100000;

CREATE TABLE `pku_company`.`department` (
	`dept_id` INT NOT NULL AUTO_INCREMENT,
	`dept_name` VARCHAR(20) NOT NULL,
	`description` VARCHAR(50),
	`manager_id` INT,
	PRIMARY KEY (`dept_id`),
	FOREIGN KEY (`manager_id`)
		REFERENCES `pku_company`.`employee` (`e_id`)
		ON DELETE SET NULL
		ON UPDATE CASCADE);

CREATE TABLE `pku_company`.`attend` (
	`attend_id` INT NOT NULL,
	`e_id` INT NOT NULL,
	`date` DATE NOT NULL,
	`in_time` TIME NULL,
	`out_time` TIME NULL,
	`is_late` TINYINT NULL,
	`is_overtime` TINYINT NULL,
	`is_absence` TINYINT NULL,
	PRIMARY KEY (`attend_id`),
	FOREIGN KEY (`e_id`)
		REFERENCES `pku_company`.`employee` (`e_id`)
		ON DELETE CASCADE
		ON UPDATE CASCADE);

CREATE TABLE `pku_company`.`leaving` (
	`leave_id` INT NOT NULL,
	`e_id` INT NOT NULL,
	`reason` VARCHAR(40) NOT NULL,
	`summit_time` DATE NOT NULL,
	`start_time` DATE NOT NULL,
	`end_time` DATE NOT NULL,
	`verifier_id` INT NULL,
	`status` ENUM('Summited', 'Approved', 'Rejected') NOT NULL,
	PRIMARY KEY (`leave_id`),
	FOREIGN KEY (`e_id`)
		REFERENCES `pku_company`.`employee` (`e_id`)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (`verifier_id`)
		REFERENCES `pku_company`.`employee` (`e_id`)
		ON DELETE SET NULL
		ON UPDATE CASCADE);

CREATE TABLE `pku_company`.`salary` (
	`salary_id` INT NOT NULL,
    `e_id` INT NOT NULL,
    `ym` DATE NOT NULL,
    `basic_salary` DECIMAL(10,2) NOT NULL,
    `deduction` DECIMAL(10,2) NOT NULL,
    `award` DECIMAL(10,2) NOT NULL,
	`real_salary` DECIMAL(10,2) GENERATED ALWAYS AS (basic_salary + award - deduction) VIRTUAL,
	`pay_time` DATETIME NULL,
	`verifier_id` INT NULL,
	PRIMARY KEY (`salary_id`),
	FOREIGN KEY (`e_id`)
		REFERENCES `pku_company`.`employee` (`e_id`)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (`verifier_id`)
		REFERENCES `pku_company`.`employee` (`e_id`)
		ON DELETE SET NULL
		ON UPDATE CASCADE);

CREATE TABLE `pku_company`.`login` (
	`e_id` INT NOT NULL,
	`password` TEXT(256) NOT NULL,
	PRIMARY KEY (`e_id`),
	FOREIGN KEY (`e_id`)
		REFERENCES `pku_company`.`employee` (`e_id`)
		ON DELETE CASCADE
		ON UPDATE CASCADE);

CREATE TABLE `pku_company`.`admin` (
	`admin_id` INT NOT NULL,
	`password` TEXT(256) NOT NULL,
	PRIMARY KEY (`admin_id`));
