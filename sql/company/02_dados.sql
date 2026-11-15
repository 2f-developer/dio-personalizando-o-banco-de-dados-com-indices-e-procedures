-- Dados do exemplo clássico do livro, com alguns funcionários e locais a mais.
USE company;

SET FOREIGN_KEY_CHECKS = 0;  -- department e employee se referenciam (gerente x lotação)

INSERT INTO department VALUES
  (1, 'Headquarters', '888665555', '1981-06-19'),
  (4, 'Administration', '987654321', '1995-01-01'),
  (5, 'Research', '333445555', '1988-05-22');

INSERT INTO employee VALUES
  ('888665555', 'James', 'E', 'Borg', '1937-11-10', '450 Stone, Houston, TX', 'M', 55000, NULL, 1),
  ('333445555', 'Franklin', 'T', 'Wong', '1955-12-08', '638 Voss, Houston, TX', 'M', 40000, '888665555', 5),
  ('987654321', 'Jennifer', 'S', 'Wallace', '1941-06-20', '291 Berry, Bellaire, TX', 'F', 43000, '888665555', 4),
  ('123456789', 'John', 'B', 'Smith', '1965-01-09', '731 Fondren, Houston, TX', 'M', 30000, '333445555', 5),
  ('666884444', 'Ramesh', 'K', 'Narayan', '1962-09-15', '975 Fire Oak, Humble, TX', 'M', 38000, '333445555', 5),
  ('453453453', 'Joyce', 'A', 'English', '1972-07-31', '5631 Rice, Houston, TX', 'F', 25000, '333445555', 5),
  ('999887777', 'Alicia', 'J', 'Zelaya', '1968-01-19', '3321 Castle, Spring, TX', 'F', 25000, '987654321', 4),
  ('987987987', 'Ahmad', 'V', 'Jabbar', '1969-03-29', '980 Dallas, Houston, TX', 'M', 25000, '987654321', 4),
  ('111222333', 'Laura', 'M', 'Pires', '1990-04-12', '12 Main, Houston, TX', 'F', 32000, '333445555', 5),
  ('444555666', 'Diego', 'R', 'Alves', '1993-08-02', '77 Elm, Sugarland, TX', 'M', 29000, '987654321', 4);

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO dept_locations VALUES
  (1, 'Houston'), (4, 'Stafford'), (5, 'Bellaire'), (5, 'Sugarland'), (5, 'Houston');

INSERT INTO project VALUES
  (1, 'ProductX', 'Bellaire', 5), (2, 'ProductY', 'Sugarland', 5), (3, 'ProductZ', 'Houston', 5),
  (10, 'Computerization', 'Stafford', 4), (20, 'Reorganization', 'Houston', 1), (30, 'Newbenefits', 'Stafford', 4);

INSERT INTO works_on VALUES
  ('123456789', 1, 32.5), ('123456789', 2, 7.5), ('666884444', 3, 40.0), ('453453453', 1, 20.0),
  ('453453453', 2, 20.0), ('333445555', 2, 10.0), ('333445555', 3, 10.0), ('333445555', 10, 10.0),
  ('333445555', 20, 10.0), ('999887777', 30, 30.0), ('999887777', 10, 10.0), ('987987987', 10, 35.0),
  ('987987987', 30, 5.0), ('987654321', 30, 20.0), ('987654321', 20, 15.0), ('888665555', 20, NULL),
  ('111222333', 3, 30.0), ('444555666', 30, 25.0);

INSERT INTO dependent VALUES
  ('333445555', 'Alice', 'F', '1986-04-05', 'Daughter'), ('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
  ('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'), ('987654321', 'Abner', 'M', '1942-02-28', 'Spouse'),
  ('123456789', 'Michael', 'M', '1988-01-04', 'Son');
