USE ecommerce_procedures;

DROP PROCEDURE IF EXISTS gerenciar_produto;

DELIMITER $$

-- Mesma ideia da procedure de alunos, agora com IF/ELSEIF para mostrar a outra
-- estrutura condicional. p_acao: 1 consultar, 2 inserir, 3 atualizar, 4 remover.
CREATE PROCEDURE gerenciar_produto(
  IN p_acao TINYINT,
  IN p_id INT UNSIGNED,
  IN p_nome VARCHAR(120),
  IN p_categoria_id INT UNSIGNED,
  IN p_preco DECIMAL(10, 2),
  IN p_estoque INT
)
BEGIN
  IF p_estoque < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque não pode ser negativo.';
  END IF;

  IF p_acao = 1 THEN
    SELECT p.id, p.nome, c.nome AS categoria, p.preco, p.estoque
    FROM produto p
    JOIN categoria c ON c.id = p.categoria_id
    WHERE p_id IS NULL OR p.id = p_id
    ORDER BY p.nome;

  ELSEIF p_acao = 2 THEN
    IF p_nome IS NULL OR p_categoria_id IS NULL OR p_preco IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Para inserir, informe nome, categoria e preço.';
    END IF;
    INSERT INTO produto (nome, categoria_id, preco, estoque)
    VALUES (p_nome, p_categoria_id, p_preco, COALESCE(p_estoque, 0));
    SELECT LAST_INSERT_ID() AS id_criado;

  ELSEIF p_acao = 3 THEN
    IF NOT EXISTS (SELECT 1 FROM produto WHERE id = p_id) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produto não encontrado.';
    END IF;
    UPDATE produto
    SET nome = COALESCE(p_nome, nome),
        categoria_id = COALESCE(p_categoria_id, categoria_id),
        preco = COALESCE(p_preco, preco),
        estoque = COALESCE(p_estoque, estoque)
    WHERE id = p_id;
    SELECT ROW_COUNT() AS linhas_alteradas;

  ELSEIF p_acao = 4 THEN
    IF NOT EXISTS (SELECT 1 FROM produto WHERE id = p_id) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produto não encontrado.';
    END IF;
    DELETE FROM produto WHERE id = p_id;
    SELECT ROW_COUNT() AS linhas_removidas;

  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ação inválida: use 1 (consultar), 2 (inserir), 3 (atualizar) ou 4 (remover).';
  END IF;
END$$

DELIMITER ;

-- Exemplos de uso
CALL gerenciar_produto(2, NULL, 'Teclado Mecânico', 1, 389.00, 45);
CALL gerenciar_produto(3, 2, NULL, NULL, 54.90, NULL);
CALL gerenciar_produto(4, 3, NULL, NULL, NULL, NULL);
CALL gerenciar_produto(1, NULL, NULL, NULL, NULL, NULL);
