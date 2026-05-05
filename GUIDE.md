# Domiatek Autonomous System — Guía de uso

## Qué es este sistema

Una organización de desarrollo de software 100% autónoma. Cada mañana analiza el roadmap, elige la tarea más prioritaria, la implementa, abre un PR y lo revisa — sin intervención humana. Tú recibes un Telegram con el plan y puedes redirigir el trabajo si quieres.

---

## Ciclo diario automático

| Hora (Madrid) | Qué pasa |
|--------------|---------|
| 06:00 AM | Recibes Telegram con el plan del día — proyectos activos, tarea elegida, PRs pendientes |
| 07:00 AM | El agente coder implementa la tarea del roadmap y abre un PR |
| 09:00 AM | El agente QA revisa todos los PRs abiertos — aprueba o pide cambios |
| Lunes 10:00 AM | CEO Agent actualiza métricas del roadmap y analiza nuevas ideas de proyectos |

**El sistema trabaja aunque tengas el PC apagado.** Corre en GitHub Actions, Anthropic Cloud y Cloudflare.

---

## Bot de Telegram — comandos disponibles

Escribe estos mensajes directamente al bot en Telegram:

### Consultar estado

| Comando | Qué devuelve |
|---------|-------------|
| `estado` | Qué se está implementando ahora mismo, qué está programado hoy, cuántas tareas en cola |
| `roadmap` | Las próximas 6 tareas del sprint actual con estado y repo |
| `sprint` | Resumen del sprint: completadas, en progreso, en cola |
| `prs` | Todos los PRs abiertos en todos los repos de Domiatek |
| `ayuda` | Lista de comandos disponibles |

### Proponer nuevo proyecto

```
0: [descripción del proyecto]
```

Ejemplos:
```
0: App de control de stock para talleres mecánicos
0: Módulo de nóminas para el ERP
0: Integración con WhatsApp Business para RalloApp
```

Esto crea automáticamente un issue en GitHub con label `project-analysis`. El CEO Agent lo analiza el lunes siguiente y decide si entra al roadmap del próximo sprint.

---

## Cómo modificar prioridades

### Opción 1 — Responder al Telegram de las 6 AM

Cada mañana el sistema crea un "daily issue" en GitHub con el plan del día. Si comentas en ese issue antes de las 07:00 AM, el agente coder lo lee y puede cambiar la tarea.

Formato del comentario:
```
override: WD-001
```
_(usa el ID del item del roadmap que quieres que implemente hoy)_

### Opción 2 — Escribir al bot

```
0: Necesito urgente el módulo de facturación
```
El CEO Agent lo analizará el lunes y puede reprioritizar.

### Opción 3 — Editar roadmap directamente

Edita `roadmap.json` en `Domiatek/domiatek-core` y cambia el campo `priority` de cualquier item. El CEO Agent respeta las prioridades manuales.

---

## Repositorios gestionados

| Repo | Stack | Qué contiene |
|------|-------|-------------|
| `domiatek-core` | — | Cerebro: roadmap, agentes, workflows |
| `RalloApp` | Flutter / BLoC / Firebase | App móvil de agenda para profesionales |
| `proges-app` | Flutter / SQLite | App de gestión para talleres (APK) |
| `erp-domiatek` | Node.js / Express / SQLite | ERP interno de Domiatek |
| `app-energia` | Next.js | App de análisis de facturas de luz |
| `web-domiatek` | Next.js / React | Web corporativa de Domiatek |

---

## Cómo añadir un nuevo repo al sistema

1. Crear el repo en `github.com/Domiatek`
2. Añadir el repo a la lista `meta.repos` en `roadmap.json`
3. Crear el issue de kick-off con descripción del proyecto
4. Añadir el item al roadmap con status `queued`
5. El sistema lo gestiona desde el siguiente ciclo del lunes

---

## Agentes del sistema

| Agente | Cuándo actúa | Modelo | Qué hace |
|--------|-------------|--------|---------|
| `morning-telegram` | 06:00 AM diario | GitHub Actions | Envía plan por Telegram, crea daily issue |
| `domiatek-coder` | 07:00 AM diario | Claude Sonnet | Lee roadmap, implementa tarea, abre PR |
| `domiatek-qa` | 09:00 AM diario | Claude Sonnet | Revisa PRs, aprueba o pide cambios |
| `ceo-cycle` | Lunes 10:00 AM | GitHub Actions + Claude | Actualiza roadmap, analiza ideas nuevas |
| `domiatek-bot` | 24/7 | Cloudflare Workers | Responde comandos en Telegram |

---

## Estados del roadmap

| Estado | Significado |
|--------|------------|
| `backlog` | Definido pero no en sprint activo |
| `queued` | En el sprint, listo para implementar |
| `scheduled` | Elegido para hoy |
| `in_progress` | Agente trabajando en ello ahora |
| `completed` | PR merged |

---

## Solución de problemas

**El bot de Telegram no responde**
- Verifica que el Worker está activo: `https://domiatek-bot.sanchez-ad23.workers.dev`
- Revisa los logs: `npx wrangler tail` en `C:\Users\DARIO\domiatek-bot`

**No llegó el Telegram de las 6 AM**
- Revisa el workflow: `gh run list --repo Domiatek/domiatek-core --workflow morning-telegram.yml`
- Verifica los secrets: `gh secret list --org Domiatek`

**El agente no implementó nada**
- Revisa el run del coder: `gh run list --repo Domiatek/domiatek-core`
- Comprueba que hay items con `status: queued` en el roadmap

**Ver logs de cualquier agente CCR**
- Ir a: `https://claude.ai/code/routines`

---

## Estructura de archivos clave

```
Domiatek/domiatek-core/
├── roadmap.json              ← fuente de verdad del sistema
├── sprints/sprint-01.json    ← métricas del sprint actual
├── scripts/morning_plan.py   ← lógica del Telegram de las 6 AM
├── learning/patterns.json    ← aprendizaje acumulado de los agentes
└── .github/workflows/
    ├── morning-telegram.yml  ← cron 06:00 AM
    ├── ceo-cycle.yml         ← cron lunes 10:00 AM
    ├── event-router.yml      ← enruta eventos entre repos
    ├── project-analysis.yml  ← analiza nuevas ideas
    └── learning-agent.yml    ← registra patrones al cerrar issues
```
