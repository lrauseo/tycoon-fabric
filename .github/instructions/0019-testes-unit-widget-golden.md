# 0019 — Testes: Unit, Widget, Golden

## Objetivo
Cobrir conversões isométricas, serviços e UI crítica.

## Cobertura mínima
- 80% nos serviços (`production`, `economy`, `save`).
- Golden tests para HUD e Loja (estados principais).
- Testes do `TickEngine` e conversões grid/world.

## Critérios de Aceite
- CI roda `flutter test` e gera relatório.
- Quebra deliberada em serviço crítico falha os testes.

## Entregáveis
- Testes implementados + README de como rodar.
