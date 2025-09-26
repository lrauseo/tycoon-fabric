# 0010 — Salvamento & Carregamento (Hive)

## Objetivo
Persistir o estado do jogo localmente e permitir **continuar** a partida.

## Requisitos
- Modelo `SaveGame`: dinheiro, tempo, estruturas colocadas (tipo, grid.x, grid.y, direção), inventário, upgrades.
- Hive adapters + migração de versão (v1 do schema).
- Autosave a cada N segundos e ao pausar/sair.
- Botões: `Novo Jogo`, `Continuar`, `Apagar Save` (com confirmação).

## Critérios de Aceite
- Sair e voltar mantém a fábrica exatamente como antes.
- Corrupção de arquivo lida com fallback (último save válido).

## Entregáveis
- `savegame.dart`, `save_repository.dart`, `save_service.dart` + testes.
