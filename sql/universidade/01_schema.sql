DROP DATABASE IF EXISTS universidade;
CREATE DATABASE universidade CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE universidade;

CREATE TABLE curso (
  id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome  VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE aluno (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome       VARCHAR(120) NOT NULL,
  email      VARCHAR(120) NOT NULL UNIQUE,
  curso_id   INT UNSIGNED NOT NULL,
  ingresso   DATE NOT NULL DEFAULT (CURRENT_DATE),
  FOREIGN KEY (curso_id) REFERENCES curso (id)
);

INSERT INTO curso (id, nome) VALUES (1, 'Ciência da Computação'), (2, 'Sistemas de Informação'), (3, 'Engenharia de Software');
INSERT INTO aluno (nome, email, curso_id, ingresso) VALUES
  ('Lucas Martins', 'lucas.martins@uni.edu', 1, '2024-02-05'),
  ('Beatriz Rocha', 'beatriz.rocha@uni.edu', 2, '2024-02-05'),
  ('Tiago Fernandes', 'tiago.f@uni.edu', 3, '2025-02-03');
