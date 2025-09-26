# 0014 — Analytics (GA4) & Remote Config

## Objetivo
Instrumentar funil básico e permitir tunagem via Remote Config.

## Eventos
- `tutorial_start`, `tutorial_complete`
- `first_production`
- `first_sale`
- `ad_reward_granted`
- `iap_purchase_success`

## Remote Config (exemplos)
- `tick_ms`: 200
- `boost_multiplier`: 1.5
- `boost_duration_sec`: 120
- `base_price_plank`: 5

## Critérios de Aceite
- Eventos aparecem no DebugView do GA4.
- Alterar RC reflete em runtime (após fetch/activate).

## Entregáveis
- `ga4.dart`, `remote_config.dart`, guia de verificação.
