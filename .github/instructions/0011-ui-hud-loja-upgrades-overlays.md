# 0011 — UI Flutter: HUD, Loja & Upgrades (Overlays)

## Objetivo
Construir UI em Flutter (overlays do GameWidget) para controlar o jogo.

## Requisitos
- **HUD**: dinheiro, inventário, throughput, botão de pausa.
- **Loja**: catálogo (esteiras, máquinas, junctions) com custo; preview verde/vermelho antes de colocar.
- **Upgrades**: melhorar velocidade/qualidade/energia (valores do `balance_service`).

## Critérios de Aceite
- Jogador consegue **comprar**, **colocar**, **remover** estruturas.
- Upgrades aplicam efeito imediato (no próximo tick).

## Entregáveis
- `hud.dart`, `store.dart`, `upgrades.dart`; integrações via Riverpod.
