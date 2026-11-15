#!/usr/bin/env bash
# Recria os três bancos, roda índices, consultas e procedures, e depois as verificações.
# Os argumentos vão direto para o cliente mysql. Exemplo: ./testar.sh -u root -p
set -euo pipefail
cd "$(dirname "$0")"
for arquivo in sql/company/0*.sql sql/universidade/0*.sql sql/ecommerce/0*.sql tests/verificacoes.sql; do
  echo "== $arquivo"
  if ! saida=$(mysql --default-character-set=utf8mb4 "$@" < "$arquivo" 2>&1); then
    echo "$saida"
    exit 1
  fi
  grep -E '^ok|passaram' <<< "$saida" || true
done
