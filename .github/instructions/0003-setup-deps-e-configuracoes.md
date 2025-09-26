# 0003 — Setup, Dependências & Configurações (Flutter + Flame)

## Objetivo
Configurar o projeto com dependências e flags necessárias.

## Dependências (pubspec.yaml)
- flame, flame_tiled
- flutter_riverpod (ou riverpod)
- hive / hive_flutter (ou isar) + build_runner para adapters
- google_mobile_ads
- in_app_purchase
- firebase_core, firebase_analytics, firebase_remote_config
- collection, freezed, json_serializable (opcionais p/ modelos)

## Passo a Passo
1. Criar projeto Flutter (`flutter create factory_tycoon`).
2. Adicionar dependências; rodar `flutterfire configure` p/ Firebase.
3. Android: setar minSdk 23+, ícones/splash, permissões (INTERNET).
4. iOS: atualizar `Info.plist` p/ Ads/IAP; checar iOS 13+.
5. Ativar **Google Mobile Ads** com App ID; **IAP** com produtos de teste.
6. Ativar **GA4** e **Remote Config** no Firebase.
7. Habilitar **orientação portrait** e target SDK 35.

## Critérios de Aceite
- App abre em branco com GA4 inicializado (log no console).
- Ads test device configurado (sem crash).
- `flutter test` roda sem falhas.

## Entregáveis
- Projeto inicial com `README` de setup e variáveis.
