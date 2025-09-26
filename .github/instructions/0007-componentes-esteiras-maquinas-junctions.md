# 0007 — Componentes: Esteiras, Máquinas e Junctions

## Objetivo
Implementar os **componentes básicos** do chão de fábrica.

## Requisitos
- **Esteira**: direção (N/S/L/O), velocidade (tiles/tick), empurra `ItemComponent`.
- **Junction**: roteia itens conforme prioridade/estoque.
- **Máquina**: slots de entrada/saída, tempo de processamento (ticks), taxa de falha, consumo.

## Modelos
```json
{
  "machineId": "cutter_t1",
  "inputs": [{"item":"log","qty":1}],
  "outputs":[{"item":"plank","qty":2}],
  "timeMs": 1200,
  "failureRate": 0.02,
  "power": 5
}
```

## Critérios de Aceite
- Item se move pela esteira e entra/saí da máquina corretamente.
- Junction roteia para saída livre.
- Logs de throughput por minuto.

## Entregáveis
- `conveyor_component.dart`, `machine_component.dart`, `junction_component.dart`, sprites placeholder.
