-- Verificações das duas partes. Qualquer falha interrompe com erro.
USE company;

DELIMITER $$

CREATE PROCEDURE espera_erro(IN descricao VARCHAR(200), IN comando TEXT)
BEGIN
  DECLARE falhou BOOLEAN DEFAULT FALSE;
  BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET falhou = TRUE;
    SET @comando = comando;
    PREPARE stmt FROM @comando;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END;
  IF NOT falhou THEN
    SET @msg = CONCAT('FALHOU (deveria ser recusado): ', descricao);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @msg;
  END IF;
  SELECT CONCAT('ok  ', descricao) AS resultado;
END$$

CREATE PROCEDURE espera_igual(IN descricao VARCHAR(200), IN obtido VARCHAR(100), IN esperado VARCHAR(100))
BEGIN
  IF NOT (obtido <=> esperado) THEN
    SET @msg = CONCAT('FALHOU: ', descricao, ' (obtido ', COALESCE(obtido, 'NULL'), ', esperado ', COALESCE(esperado, 'NULL'), ')');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @msg;
  END IF;
  SELECT CONCAT('ok  ', descricao) AS resultado;
END$$

DELIMITER ;

-- Parte 1: índices existem e são usados
CALL espera_igual('índice composto de employee por departamento e nome',
  (SELECT GROUP_CONCAT(column_name ORDER BY seq_in_index) FROM information_schema.statistics
   WHERE table_schema = 'company' AND index_name = 'idx_employee_dno_nome'), 'dno,lname,fname');
CALL espera_igual('índice de dept_locations começa pela cidade',
  (SELECT column_name FROM information_schema.statistics
   WHERE table_schema = 'company' AND index_name = 'idx_dept_locations_cidade' AND seq_in_index = 1), 'dlocation');
CALL espera_igual('departamento com mais pessoas',
  (SELECT d.dname FROM employee e JOIN department d ON d.dnumber = e.dno GROUP BY d.dname ORDER BY COUNT(*) DESC LIMIT 1), 'Research');
CALL espera_igual('Houston tem dois departamentos',
  (SELECT COUNT(*) FROM dept_locations WHERE dlocation = 'Houston'), '2');

-- Parte 2: procedures (rodam depois dos exemplos de uso)
CALL espera_igual('aluno inserido pela procedure', (SELECT COUNT(*) FROM universidade.aluno WHERE email = 'marina.lopes@uni.edu'), '1');
CALL espera_igual('atualização parcial mantém o nome', (SELECT CONCAT(nome, ' ', email) FROM universidade.aluno WHERE id = 1), 'Lucas Martins lucas.m@uni.edu');
CALL espera_igual('aluno removido', (SELECT COUNT(*) FROM universidade.aluno WHERE id = 3), '0');
CALL espera_erro('ação inválida é recusada', 'CALL universidade.gerenciar_aluno(9, NULL, NULL, NULL, NULL)');
CALL espera_erro('atualizar aluno inexistente é erro', "CALL universidade.gerenciar_aluno(3, 999, 'X', NULL, NULL)");
CALL espera_erro('inserir sem e-mail é recusado', "CALL universidade.gerenciar_aluno(2, NULL, 'X', NULL, 1)");

CALL espera_igual('produto inserido pela procedure', (SELECT COUNT(*) FROM ecommerce_procedures.produto WHERE nome = 'Teclado Mecânico'), '1');
CALL espera_igual('preço atualizado sem mexer no estoque', (SELECT CONCAT(preco, ' ', estoque) FROM ecommerce_procedures.produto WHERE id = 2), '54.90 80');
CALL espera_igual('produto removido', (SELECT COUNT(*) FROM ecommerce_procedures.produto WHERE id = 3), '0');
CALL espera_erro('estoque negativo é recusado', 'CALL ecommerce_procedures.gerenciar_produto(3, 1, NULL, NULL, NULL, -5)');
CALL espera_erro('remover produto inexistente é erro', 'CALL ecommerce_procedures.gerenciar_produto(4, 999, NULL, NULL, NULL, NULL)');

DROP PROCEDURE espera_erro;
DROP PROCEDURE espera_igual;
SELECT 'todas as verificações passaram' AS resultado;
