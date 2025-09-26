# 0021 — CI/CD (GitHub Actions)

## Objetivo
Automatizar testes, lint e build de release (manual dispatch).

## Pipeline
- Job 1: lint + tests (pull_request).
- Job 2: build Android (workflow dispatch).
- Job 3: build iOS (macOS runner) — opcional.

## Critérios de Aceite
- PR sem testes falha pipeline.
- Artefatos de build anexados no workflow.

## Entregáveis
- `.github/workflows/flutter-ci.yml` comentado.
