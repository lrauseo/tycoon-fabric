# 0023 — Balanceamento: Tabelas (JSON) & Painel Interno

## Objetivo
Configurar dados de **receitas**, **máquinas**, **preços** em JSON e criar painel interno para ajustes.

## Requisitos
- `assets/data/machines.json`, `recipes.json`, `prices.json`.
- `BalanceService` lê/valida; hot-reload simples (dev only).
- Tela interna (debug) para editar valores e ver impacto (UI Flutter).

## Critérios de Aceite
- Alterar preço/tempo reflete na simulação ao vivo (dev).
- Validação de schema com mensagens claras.

## Entregáveis
- JSONs exemplo + painel interno (`/overlays/balance_debug.dart`).
