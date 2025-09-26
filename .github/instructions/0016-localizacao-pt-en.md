# 0016 — Localização (pt-BR/en-US)

## Objetivo
Suportar pelo menos **pt-BR** e **en-US** via JSON de strings.

## Requisitos
- `i18n/strings_pt.json`, `i18n/strings_en.json`.
- Helper `t(key)` com fallback e interpolação.
- Troca de idioma em Settings (persistir).

## Critérios de Aceite
- Todas as telas usam `t(key)` (sem textos hard-coded).
- Arquivo de chaves documentado.

## Entregáveis
- Sistema i18n, planilha de chaves, validação de chaves órfãs.
