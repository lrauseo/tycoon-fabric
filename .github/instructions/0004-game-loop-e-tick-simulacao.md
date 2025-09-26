# 0004 — Game Loop & Tick de Simulação

## Objetivo
Implementar engine de “ticks” para produção/economia independente do framerate.

## Requisitos
- Ticks a cada 200ms (configurável).
- `TickEngine` acumula `dt` no `update()` do FlameGame e emite eventos.
- Serviços (`production_service`, `economy_service`) assinam o tick.

## Pseudocódigo
```dart
class TickEngine {
  final Duration tick = Duration(milliseconds: 200);
  Duration _acc = Duration.zero;
  final _controller = StreamController<int>.broadcast();
  int _tickCount = 0;

  void update(Duration dt) {
    _acc += dt;
    while (_acc >= tick) {
      _acc -= tick;
      _controller.add(++_tickCount);
    }
  }

  Stream<int> get onTick => _controller.stream;
}
```

## Critérios de Aceite
- Loga no console a contagem de ticks constante, mesmo com FPS variando.
- Serviços conseguem assinar/receber ticks.

## Entregáveis
- `tick_engine.dart` testado.
