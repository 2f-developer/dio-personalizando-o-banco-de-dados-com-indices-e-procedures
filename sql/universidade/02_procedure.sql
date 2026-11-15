USE universidade;

DROP PROCEDURE IF EXISTS gerenciar_aluno;

DELIMITER $$

-- Uma procedure para as quatro operações sobre alunos. A variável de controle
-- p_acao escolhe o que fazer:
--   1 = consultar   (p_id NULL lista todos)
--   2 = inserir     (usa p_nome, p_email, p_curso_id)
--   3 = atualizar   (p_id obrigatório; campos NULL ficam como estão)
--   4 = remover     (p_id obrigatório)
CREATE PROCEDURE gerenciar_aluno(
  IN p_acao TINYINT,
  IN p_id INT UNSIGNED,
  IN p_nome VARCHAR(120),
  IN p_email VARCHAR(120),
  IN p_curso_id INT UNSIGNED
)
BEGIN
  IF p_acao IN (3, 4) AND NOT EXISTS (SELECT 1 FROM aluno WHERE id = p_id) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Aluno não encontrado.';
  END IF;

  CASE p_acao
    WHEN 1 THEN
      SELECT a.id, a.nome, a.email, c.nome AS curso, a.ingresso
      FROM aluno a
      JOIN curso c ON c.id = a.curso_id
      WHERE p_id IS NULL OR a.id = p_id
      ORDER BY a.nome;

    WHEN 2 THEN
      IF p_nome IS NULL OR p_email IS NULL OR p_curso_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Para inserir, informe nome, e-mail e curso.';
      END IF;
      INSERT INTO aluno (nome, email, curso_id) VALUES (p_nome, p_email, p_curso_id);
      SELECT LAST_INSERT_ID() AS id_criado;

    WHEN 3 THEN
      UPDATE aluno
      SET nome = COALESCE(p_nome, nome),
          email = COALESCE(p_email, email),
          curso_id = COALESCE(p_curso_id, curso_id)
      WHERE id = p_id;
      SELECT ROW_COUNT() AS linhas_alteradas;

    WHEN 4 THEN
      DELETE FROM aluno WHERE id = p_id;
      SELECT ROW_COUNT() AS linhas_removidas;

    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ação inválida: use 1 (consultar), 2 (inserir), 3 (atualizar) ou 4 (remover).';
  END CASE;
END$$

DELIMITER ;

-- Exemplos de uso
CALL gerenciar_aluno(2, NULL, 'Marina Lopes', 'marina.lopes@uni.edu', 2);
CALL gerenciar_aluno(3, 1, NULL, 'lucas.m@uni.edu', NULL);
CALL gerenciar_aluno(4, 3, NULL, NULL, NULL);
CALL gerenciar_aluno(1, NULL, NULL, NULL, NULL);
