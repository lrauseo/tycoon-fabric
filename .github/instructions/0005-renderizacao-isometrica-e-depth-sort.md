# 0005 — Renderização Isométrica & Depth Sort

## Objetivo
Exibir grid isométrico com **ordem de desenho correta** (componentes “atrás/à frente” conforme Y).

## Requisitos
- Conversões grid↔world (losango) com tile base (ex.: 64×32).
- `DepthSort`: ordenar `components` por `position.y` antes de desenhar.
- Suporte a 4 direções de sprites (N, S, L, O) para esteiras/máquinas.

## Fórmulas (exemplo)
- world.x = (grid.x - grid.y) * tileWidth/2
- world.y = (grid.x + grid.y) * tileHeight/2

## Critérios de Aceite
- Componentes andando “atrás” de outros com aparência correta.
- Prova visual: funcionário caminha entre duas máquinas e fica oculto parcialmente.

## Entregáveis
- `iso_grid.dart`, `depth_sort.dart` com testes de conversão.
