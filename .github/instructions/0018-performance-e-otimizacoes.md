# 0018 — Performance & Otimizações

## Objetivo
Garantir 60 FPS estáveis em aparelhos mid-range.

## Ações
- Batching de sprites, atlases, evitar overdraw.
- Limitar draw calls; usar `cache` de caminhos A*.
- Mover simulação pesada para **Isolate** se necessário.
- Profile com `flutter run --profile` e `DevTools`.

## Critérios de Aceite
- FPS > 50 em device alvo com 50 esteiras + 10 máquinas.
- GC não causa stutters perceptíveis.

## Entregáveis
- Relatório de perfil, flags/otimizações documentadas.
