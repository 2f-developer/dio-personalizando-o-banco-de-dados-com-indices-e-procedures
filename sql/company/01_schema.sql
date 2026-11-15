-- Cenário COMPANY (Elmasri & Navathe), em MySQL 8.
DROP DATABASE IF EXISTS company;
CREATE DATABASE company CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE company;

CREATE TABLE department (
  dnumber         INT PRIMARY KEY,
  dname           VARCHAR(40) NOT NULL,
  mgr_ssn         CHAR(9),
  mgr_start_date  DATE,
  CONSTRAINT uk_department_name UNIQUE (dname)
);

CREATE TABLE employee (
  ssn        CHAR(9) PRIMARY KEY,
  fname      VARCHAR(30) NOT NULL,
  minit      CHAR(1),
  lname      VARCHAR(30) NOT NULL,
  bdate      DATE,
  address    VARCHAR(100),
  sex        CHAR(1),
  salary     DECIMAL(10, 2) NOT NULL,
  super_ssn  CHAR(9),
  dno        INT NOT NULL,
  CONSTRAINT ck_employee_salary CHECK (salary > 0),
  CONSTRAINT fk_employee_super FOREIGN KEY (super_ssn) REFERENCES employee (ssn) ON DELETE SET NULL,
  CONSTRAINT fk_employee_department FOREIGN KEY (dno) REFERENCES department (dnumber)
);

ALTER TABLE department
  ADD CONSTRAINT fk_department_manager FOREIGN KEY (mgr_ssn) REFERENCES employee (ssn) ON DELETE SET NULL;

CREATE TABLE dept_locations (
  dnumber    INT,
  dlocation  VARCHAR(40),
  PRIMARY KEY (dnumber, dlocation),
  CONSTRAINT fk_dept_locations FOREIGN KEY (dnumber) REFERENCES department (dnumber) ON DELETE CASCADE
);

CREATE TABLE project (
  pnumber    INT PRIMARY KEY,
  pname      VARCHAR(40) NOT NULL UNIQUE,
  plocation  VARCHAR(40),
  dnum       INT NOT NULL,
  CONSTRAINT fk_project_department FOREIGN KEY (dnum) REFERENCES department (dnumber)
);

CREATE TABLE works_on (
  essn   CHAR(9),
  pno    INT,
  hours  DECIMAL(4, 1),
  PRIMARY KEY (essn, pno),
  CONSTRAINT fk_works_on_employee FOREIGN KEY (essn) REFERENCES employee (ssn) ON DELETE CASCADE,
  CONSTRAINT fk_works_on_project FOREIGN KEY (pno) REFERENCES project (pnumber)
);

CREATE TABLE dependent (
  essn            CHAR(9),
  dependent_name  VARCHAR(30),
  sex             CHAR(1),
  bdate           DATE,
  relationship    VARCHAR(10),
  PRIMARY KEY (essn, dependent_name),
  CONSTRAINT fk_dependent_employee FOREIGN KEY (essn) REFERENCES employee (ssn) ON DELETE CASCADE
);
