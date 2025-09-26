# 0013 — Ads Recompensado (google_mobile_ads)

## Objetivo
Oferecer anúncio recompensado que concede **boost temporário** (+50% produção por 2 min).

## Requisitos
- Configurar App ID e unit IDs de teste.
- `AdsManager` para carregar/exibir rewarded ad.
- Aplicar **buff** via `balance_service` com temporizador visual (HUD).

## Critérios de Aceite
- Assistir ao anúncio aplica boost; expira corretamente.
- Erro de rede tratado com fallback (mensagem amigável).

## Entregáveis
- `ads_manager.dart`, integração com HUD, documentação de IDs.
