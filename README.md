# domiatek-core

Cerebro del sistema autónomo de Domiatek. Coordina roadmap, agentes y ciclos de desarrollo.

## Estructura

```
domiatek-core/
├── roadmap.json                 # Roadmap priorizado — fuente de verdad
├── agents/config.json           # Configuración y roles de agentes
├── sprints/sprint-01.json       # Historial de sprints
└── .github/workflows/
    ├── ceo-cycle.yml            # Ciclo semanal del CEO Agent
    └── event-router.yml         # Enrutador de eventos
```

## Ciclo autónomo

```
CEO Agent (lunes 8:00 UTC) → analiza org → actualiza roadmap → dispatch
    ↓
Dev Agent → branch agent/{issue}-{slug} → commits → PR → develop
    ↓
QA Agent → review → merge | request changes
    ↓
Learning Agent → claude-mem → siguiente sprint mejorado
```

## Activación manual

```bash
# Ciclo completo (análisis + dispatch)
gh workflow run ceo-cycle.yml --repo Domiatek/domiatek-core --field cycle_type=full-cycle

# Solo actualizar roadmap
gh workflow run ceo-cycle.yml --repo Domiatek/domiatek-core --field cycle_type=roadmap-update
```

## Secrets requeridos (org-level)

| Secret | Descripción |
|--------|-------------|
| `PROJECT_PAT` | GitHub PAT con permisos de org (repo + workflow + issues) |
| `ANTHROPIC_API_KEY` | Clave API de Anthropic |

## Convenciones

| Elemento | Formato |
|----------|---------|
| Branch | `agent/{issue-number}-{slug}` |
| Commit | `feat(scope): description (#{issue})` |
| PR | `[agent] feat: title (#{issue})` |
| Issue agente | `[agent] feat: title` |
