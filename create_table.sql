CREATE TABLE `pku_company`.`employee` (
  `e_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  `gender` ENUM('F', 'M') NOT NULL,
  `birthdate` DATETIME NOT NULL,
  `nationid` CHAR(18) NOT NULL,
  `hiredate` DATETIME NOT NULL,
  `level` ENUM('Employee', 'Manager', 'Admin') NOT NULL,
  PRIMARY KEY (`e_id`),
  UNIQUE INDEX `e_id_UNIQUE` (`e_id` ASC),
  UNIQUE INDEX `nationid_UNIQUE` (`nationid` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 100000;

CREATE TABLE `pku_company`.`contact_info` (
  `e_id` INT NOT NULL,
  `tel` VARCHAR(11) NULL,
  `email` VARCHAR(30) NULL,
  PRIMARY KEY (`e_id`),
  CONSTRAINT `contact_e_id`
    FOREIGN KEY (`e_id`)
    REFERENCES `pku_company`.`employee` (`e_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);

CREATE TABLE `pku_company`.`department` (
  `dept_id` INT NOT NULL AUTO_INCREMENT,
  `dept_name` VARCHAR(20) NOT NULL,
  `description` VARCHAR(50) NULL,
  `manager_id` INT NULL,
  PRIMARY KEY (`dept_id`),
  INDEX `manager_id_idx` (`manager_id` ASC),
  CONSTRAINT `manager_id`
    FOREIGN KEY (`manager_id`)
    REFERENCES `pku_company`.`employee` (`e_id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION);

CREATE TABLE `pku_company`.`work_at` (
  `e_id` INT NOT NULL,
  `dept_id` INT NULL,
  INDEX `dept_id_idx` (`dept_id` ASC),
  PRIMARY KEY (`e_id`),
  CONSTRAINT `work_at_e_id`
    FOREIGN KEY (`e_id`)
    REFERENCES `pku_company`.`employee` (`e_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `work_at_dept_id`
    FOREIGN KEY (`dept_id`)
    REFERENCES `pku_company`.`department` (`dept_id`)
    ON DELETE CASCADE
ON UPDATE NO ACTION);

CREATE TABLE `pku_company`.`attend` (
  `attend_id` INT NOT NULL,
  `e_id` INT NOT NULL,
  `date` DATETIME NOT NULL,
  `in_time` DATETIME NULL,
  `out_time` DATETIME NULL,
  `is_late` TINYINT NULL,
  `is_overtime` TINYINT NULL,
  `is_absence` TINYINT NULL,
  PRIMARY KEY (`attend_id`),
  INDEX `attend_e_id_idx` (`e_id` ASC),
  CONSTRAINT `attend_e_id`
    FOREIGN KEY (`e_id`)
    REFERENCES `pku_company`.`employee` (`e_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);

CREATE TABLE `pku_company`.`leaving` (
  `leave_id` INT NOT NULL,
  `e_id` INT NOT NULL,
  `reason` VARCHAR(40) NOT NULL,
  `summit_time` DATETIME NOT NULL,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NOT NULL,
  `verifier_id` INT NULL,
  `status` ENUM('Summited', 'Approved') NOT NULL,
  PRIMARY KEY (`leave_id`),
  INDEX `leaving_e_id_idx` (`e_id` ASC),
  INDEX `leaving_v_id_idx` (`verifier_id` ASC),
  CONSTRAINT `leaving_e_id`
    FOREIGN KEY (`e_id`)
    REFERENCES `pku_company`.`employee` (`e_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `leaving_v_id`
    FOREIGN KEY (`verifier_id`)
    REFERENCES `pku_company`.`employee` (`e_id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION);

CREATE TABLE `pku_company`.`salary` (
  `salary_id` INT NOT NULL,
  `e_id` INT NOT NULL,
  `ym` DATETIME NOT NULL,
  `basic_salary` DECIMAL(10,2) NOT NULL,
  `deduction` DECIMAL(10,2) NOT NULL,
  `award` DECIMAL(10,2) NOT NULL,
  `real_salary` DECIMAL(10,2) GENERATED ALWAYS AS (basic_salary + award - deduction) VIRTUAL,
  `pay_time` DATETIME NULL,
  `verifier_id` INT NULL,
  PRIMARY KEY (`salary_id`),
  INDEX `salary_e_id_idx` (`e_id` ASC),
  INDEX `salary_v_id_idx` (`verifier_id` ASC),
  CONSTRAINT `salary_e_id`
    FOREIGN KEY (`e_id`)
    REFERENCES `pku_company`.`employee` (`e_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `salary_v_id`
    FOREIGN KEY (`verifier_id`)
    REFERENCES `pku_company`.`employee` (`e_id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION);

CREATE TABLE `pku_company`.`login` (
  `e_id` INT NOT NULL,
  `password` TEXT(256) NOT NULL,
  PRIMARY KEY (`e_id`),
  CONSTRAINT `login_e_id`
    FOREIGN KEY (`e_id`)
    REFERENCES `pku_company`.`employee` (`e_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);

CREATE TABLE `pku_company`.`admin` (
  `admin_id` INT NOT NULL,
  `password` TEXT(256) NOT NULL,
  PRIMARY KEY (`admin_id`));
