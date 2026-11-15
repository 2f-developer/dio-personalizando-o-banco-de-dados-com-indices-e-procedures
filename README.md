# Índices e procedures em MySQL

Desafio "Personalizando o Banco de Dados com Índices e Procedures", da formação SQL Database Specialist da DIO. São duas partes independentes:

1. **Índices**: no cenário COMPANY, responder a três perguntas e criar só os índices que essas consultas realmente usam, explicando o motivo;
2. **Procedures**: uma procedure por cenário (universidade e e-commerce) que consulta, insere, atualiza e remove, escolhendo a ação por uma variável de controle dentro de `CASE` ou `IF`.

## Parte 1: índices

O banco COMPANY é o do livro do Elmasri e Navathe (`sql/company/`). As perguntas e as consultas estão em `04_consultas.sql`:

| Pergunta | Como a consulta trabalha |
| --- | --- |
| Qual o departamento com maior número de pessoas? | agrupa `employee` por `dno` e pega o máximo (empates aparecem juntos) |
| Quais são os departamentos por cidade? | agrupa `dept_locations` por `dlocation` |
| Relação de empregados por departamento | junta `department` e `employee` por `dno`, ordenado por nome |

Os índices estão em `03_indices.sql`, cada um comentado:

**`idx_employee_dno_nome (dno, lname, fname)`.** A primeira e a terceira perguntas passam por `employee.dno`. O MySQL já cria um índice só com `dno` para a chave estrangeira, mas a relação de empregados também é ordenada pelo nome. Com o índice composto, a ordenação sai pronta do índice (o `EXPLAIN` mostra `Using index`, sem `filesort`). Como `dno` é o primeiro campo, o composto também atende a FK, e o MySQL descarta sozinho o índice implícito que tinha criado.

**`idx_dept_locations_cidade (dlocation, dnumber)`.** A chave primária de `dept_locations` é `(dnumber, dlocation)`. Por começar pelo número do departamento, ela não ajuda a buscar ou agrupar por cidade. Invertendo a ordem, a consulta por cidade vira um acesso direto ao índice, e como `dnumber` está nele, nem precisa ir à tabela.

**Por que B-tree.** É o único tipo que o InnoDB cria de fato: `USING HASH` é aceito na sintaxe e ignorado. Mesmo que não fosse, o hash só serve para igualdade, e aqui há agrupamento e ordenação.

**O que ficou de fora.** `dname` já é `UNIQUE`, portanto já tem índice. Colunas de baixa seletividade, como `sex`, não valem um índice. Nenhuma pergunta filtra por salário, e cada índice a mais custa em toda escrita.

O final de `04_consultas.sql` tem os `EXPLAIN` que mostram cada índice sendo usado.

## Parte 2: procedures

Cada cenário tem o seu banco e a sua procedure. A variável de controle `p_acao` decide a operação: `1` consultar, `2` inserir, `3` atualizar, `4` remover.

```sql
CALL universidade.gerenciar_aluno(2, NULL, 'Marina Lopes', 'marina.lopes@uni.edu', 2);  -- insere
CALL universidade.gerenciar_aluno(3, 1, NULL, 'lucas.m@uni.edu', NULL);               -- muda só o e-mail
CALL ecommerce_procedures.gerenciar_produto(3, 2, NULL, NULL, 54.90, NULL);           -- muda só o preço
CALL ecommerce_procedures.gerenciar_produto(1, NULL, NULL, NULL, NULL, NULL);         -- lista tudo
```

- `gerenciar_aluno` (`sql/universidade/02_procedure.sql`) usa `CASE`;
- `gerenciar_produto` (`sql/ecommerce/02_procedure.sql`) usa `IF / ELSEIF`, para mostrar as duas estruturas.

Nas atualizações, parâmetro `NULL` significa "não mexer neste campo". Ação inválida, id inexistente, inserção sem os campos obrigatórios e estoque negativo geram erro com mensagem clara (`SIGNAL`), em vez de não fazer nada em silêncio.

## Rodando

Com um MySQL 8 disponível:

```bash
./testar.sh -u root -p
```

O script recria os três bancos, aplica os índices, roda as consultas e os exemplos das procedures e, no fim, `tests/verificacoes.sql`: confere que os índices existem com as colunas certas, que as respostas estão corretas e que as procedures fazem e recusam o que deveriam. O GitHub Actions roda o mesmo num MySQL 8 a cada push.
