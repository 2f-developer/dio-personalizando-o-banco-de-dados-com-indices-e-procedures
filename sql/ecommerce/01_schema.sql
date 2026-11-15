DROP DATABASE IF EXISTS ecommerce_procedures;
CREATE DATABASE ecommerce_procedures CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE ecommerce_procedures;

CREATE TABLE categoria (
  id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome  VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE produto (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome          VARCHAR(120) NOT NULL,
  categoria_id  INT UNSIGNED NOT NULL,
  preco         DECIMAL(10, 2) NOT NULL,
  estoque       INT UNSIGNED NOT NULL DEFAULT 0,
  CONSTRAINT ck_produto_preco CHECK (preco > 0),
  FOREIGN KEY (categoria_id) REFERENCES categoria (id)
);

INSERT INTO categoria (id, nome) VALUES (1, 'Eletrônicos'), (2, 'Casa'), (3, 'Acessórios');
INSERT INTO produto (nome, categoria_id, preco, estoque) VALUES
  ('Fone Bluetooth', 1, 249.90, 120),
  ('Caneca Artesanal', 2, 59.90, 80),
  ('Cabo USB-C 2 m', 3, 39.90, 500);
