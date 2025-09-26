# 0012 — IAP (in_app_purchase) MVP

## Objetivo
Vender um **pack de moedas** (consumível) para acelerar progresso.

## Requisitos
- 1 produto consumível (ex.: `coins_pack_small`).
- Fluxo de compra de teste (sandbox), consumo e crédito de moedas.
- Tela de erros + recibo armazenado local para auditoria.
- Sem backend no MVP (nota: pós-MVP implementar verificação server-side).

## Critérios de Aceite
- Compra de teste conclui sem crash, saldo aumenta.
- Repetidas compras possíveis (consumível).

## Entregáveis
- `iap_manager.dart`, UI de compra, instruções de cadastro Play/App Store.
