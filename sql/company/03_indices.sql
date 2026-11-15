-- Índices criados a partir das três perguntas da parte 1 (ver 04_consultas.sql).
-- O InnoDB só cria índices B-tree: "USING HASH" é aceito na sintaxe, mas ignorado.
-- B-tree também é o que serve aqui, porque atende igualdade, prefixo e ordenação.
USE company;

-- Pergunta 1 (departamento com mais pessoas) e 3 (empregados por departamento):
-- as duas agrupam ou juntam employee por dno. O MySQL já cria um índice para a
-- chave estrangeira, mas só com dno. Este índice composto cobre dno + nome, então
-- a relação de empregados por departamento sai ordenada direto do índice, sem filesort.
CREATE INDEX idx_employee_dno_nome ON employee (dno, lname, fname);
-- Como dno é o primeiro campo, o composto também serve à chave estrangeira, e o
-- MySQL descarta sozinho o índice implícito que tinha criado só para a FK.

-- Pergunta 2 (departamentos por cidade): a busca é por dlocation. A chave primária
-- (dnumber, dlocation) começa por dnumber e não ajuda a filtrar ou agrupar por cidade.
CREATE INDEX idx_dept_locations_cidade ON dept_locations (dlocation, dnumber);

-- O que deliberadamente NÃO indexei:
--  * department.dname já é UNIQUE (portanto já tem índice) e tem só algumas linhas;
--  * employee.sex / colunas de baixa seletividade: um índice quase não filtraria nada;
--  * salary: nenhuma das perguntas filtra por salário, e cada índice extra custa em INSERT/UPDATE.
