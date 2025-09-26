# 0009 — Funcionários: FSM & Pathfinding Isométrico

## Objetivo
Adicionar NPCs básicos para reparo e coleta manual (opcional no MVP, mas deixa a base).

## Requisitos
- FSM simples: `Idle → Move → Repair/Carry → Idle`.
- Pathfinding A* no grid isométrico (4 direções).
- Colisão simples com tiles bloqueados.
- Animações 4 direções (sprites placeholders).

## Critérios de Aceite
- Funcionário alcança máquina quebrada e “repara” após X ticks.
- Caminhada respeita ordem de desenho.

## Entregáveis
- `worker_component.dart`, `pathfinding.dart` + testes de caminho.
