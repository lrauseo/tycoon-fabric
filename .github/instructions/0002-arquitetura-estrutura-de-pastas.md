# 0002 — Arquitetura & Estrutura de Pastas (Flutter + Flame 2.5D)

## Objetivo
Padronizar a estrutura do projeto para permitir trabalho paralelo (devs/agents) e testes.

## Estrutura sugerida
```
lib/
  app/
    main.dart
    di/                  # injeção (Riverpod ProviderScope)
    router/
    theme/
  game/
    core/
      factory_game.dart  # FlameGame principal
      tick_engine.dart   # loop de simulação
      event_bus.dart
      constants.dart
    world/
      iso_grid.dart      # conversões grid <-> world para isométrico
      depth_sort.dart    # z-order por Y
      map_loader.dart    # Tiled (TMX/JSON)
    components/
      conveyor_component.dart
      machine_component.dart
      junction_component.dart
      worker_component.dart
      item_component.dart
    services/
      economy_service.dart
      production_service.dart
      inventory_service.dart
      save_service.dart
      balance_service.dart
    assets/
      sprites.dart       # registrador de atlases/sprites
      atlases/
    overlays/            # Flutter overlays via GameWidget
      hud.dart
      store.dart
      upgrades.dart
      pause_menu.dart
  data/
    models/
      machine.dart
      conveyor.dart
      recipe.dart
      savegame.dart
    repositories/
      local/
        hive_adapters.dart
        save_repository.dart
  integrations/
    analytics/
      ga4.dart
    ads/
      ads_manager.dart
    iap/
      iap_manager.dart
  utils/
    logger.dart
    result.dart
test/
assets/
  images/
  sprites/
  maps/
  audio/
```

## Padrões
- **Flutter UI + FlameGame** dentro de `GameWidget` com **overlays**.
- **Riverpod** p/ estado meta-jogo; **Streams/ValueNotifier** para bridge Game↔UI.
- **Entidades imutáveis** (copyWith) nos modelos; **services** sem estado global.
- **Tick Engine** roda lógica; Components cuidam apenas de render/input.

## Critérios de Aceite
- Projeto compila com esqueleto e smoke test (tela vazia + GameWidget).
- Testes unitários básicos de conversão isométrica (grid/world).

## Entregáveis
- Projeto inicial com pastas/criadores de arquivos e comentários-guia.
