# 0001 — Visão & Escopo do MVP (Factory Tycoon 2.5D em Flutter + Flame)

## Contexto
Criar um jogo **tycoon de fábrica** em **2.5D isométrico (sprites isométricos)** usando **Flutter + Flame**, com foco em um **MVP jogável**: colocar esteiras e máquinas, produzir itens, vender, evoluir a fábrica, ganhar dinheiro e desbloquear upgrades básicos.

## Objetivo
Definir visão, restrições, pilares do MVP e uma régua de sucesso para orientar o desenvolvimento paralelo por vários devs/agents/IA.

## Escopo (MVP)
- Cena principal com **grid isométrico** e ordem de desenho correta (depth-sort por Y).
- Colocação/remoção de **esteiras**, **máquinas** e **junctions**.
- **Loop de produção** com “ticks” (ex.: 200ms): entrada → processamento → saída.
- **Economia básica**: custo de construir/operar, receita por item, estoque e dinheiro.
- **UI Flutter**: HUD (dinheiro, estoque, throughput), loja de estruturas, painel de upgrades.
- **Salvar/Carregar** progresso local (Hive/Isar).
- **Analytics (GA4)** de funil mínimo (instalação → 1ª produção → 1ª venda).
- **Ads recompensados** (google_mobile_ads) para boost temporário.
- **IAP simples** (in_app_purchase) para pack de moedas (sem backend no MVP).

## Fora de escopo (MVP)
- Multiplayer/leaderboard.
- Arte final (usar placeholders).
- Loja/IAP com verificação server-side (pode entrar em pós-MVP).

## Critérios de Aceite
- App roda em Android e iOS.
- Usuário consegue construir uma pequena linha de produção, vender itens e aumentar saldo.
- Save/Load funciona (sair/voltar mantém progresso).
- Telemetria básica visível no GA4 (pelo menos 3 events chave).
- Ads recompensado entrega boost (ex.: +50% produção por 2 min).
- Tamanho de build ≤ 70 MB (alvo) e FPS estável em mid-range Android.

## Indicadores de Sucesso
- TTFP (time-to-first-production) < 2 min.
- D1 retenção simulada (playtest) > 35%.
- Crash-free > 99% (testes locais).

## Dependências
- 0002, 0003, 0004, 0005, 0011, 0012, 0013, 0014, 0018, 0020.

## Entregáveis
- Documento de visão (este arquivo), mapa de features do MVP, checklist de release.

## Observações
Escreva **todas as tasks** com linguagem prescritiva para que uma IA possa executar sem dúvidas. Placeholders de arte são suficientes no MVP.
