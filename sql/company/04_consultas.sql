USE company;

-- 1. Qual o departamento com maior número de pessoas? (empates aparecem juntos)
WITH contagem AS (
  SELECT dno, COUNT(*) AS pessoas FROM employee GROUP BY dno
)
SELECT d.dname AS departamento, c.pessoas
FROM contagem c
JOIN department d ON d.dnumber = c.dno
WHERE c.pessoas = (SELECT MAX(pessoas) FROM contagem);

-- 2. Quais são os departamentos por cidade?
SELECT l.dlocation AS cidade, GROUP_CONCAT(d.dname ORDER BY d.dname SEPARATOR ', ') AS departamentos
FROM dept_locations l
JOIN department d ON d.dnumber = l.dnumber
GROUP BY l.dlocation
ORDER BY l.dlocation;

-- 3. Relação de empregados por departamento.
SELECT d.dname AS departamento, CONCAT(e.fname, ' ', e.lname) AS empregado, e.salary
FROM department d
JOIN employee e ON e.dno = d.dnumber
ORDER BY d.dname, e.lname, e.fname;

-- Como os índices são usados:
EXPLAIN SELECT dno, COUNT(*) FROM employee GROUP BY dno;
EXPLAIN SELECT dnumber FROM dept_locations WHERE dlocation = 'Houston';
EXPLAIN SELECT lname, fname FROM employee WHERE dno = 5 ORDER BY lname, fname;
