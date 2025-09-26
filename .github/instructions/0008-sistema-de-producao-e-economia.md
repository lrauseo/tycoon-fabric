# 0008 — Sistema de Produção & Economia

## Objetivo
Criar serviços de **produção** (processamento, buffers) e **economia** (custo/receita).

## Requisitos
- `ProductionService`: consome insumos de buffers próximos, agenda conclusão por ticks, entrega saída.
- `EconomyService`: atualiza dinheiro por venda (automática em ponto de venda simples), custos de construção/manutenção.
- `InventoryService`: quantidades de itens, slots, transações.

## Critérios de Aceite
- Ao completar processamento, estoque aumenta e dinheiro sobe quando vendido.
- Custos de colocar/remover estruturas impactam saldo.

## Entregáveis
- `production_service.dart`, `economy_service.dart`, `inventory_service.dart` + testes unitários.
