# 0006 — Integração com Tiled & Mapas

## Objetivo
Carregar mapas do **Tiled** (TMX/JSON) como piso isométrico e camadas decorativas.

## Requisitos
- flame_tiled para carregar mapa isométrico.
- Camadas: ground, decor (sem colisão, só visual).
- Exportar exemplo `assets/maps/floor_iso.tmx` + JSON.
- Sistema simples de colisão de construção: só permite construir dentro da área válida (mask do mapa).

## Critérios de Aceite
- Mapa carrega sem travar; câmera centraliza; zoom limitado.
- UI mostra erro ao tentar construir fora da área válida.

## Entregáveis
- `map_loader.dart`, mapa de exemplo, doc de como editar/exportar.
