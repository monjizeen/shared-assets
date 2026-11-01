# Monjizeen repos

One list of every `monjizeen/*` repo: what it is, whether it is active, and where it
deploys. It replaces MORA's `REGISTRY.yaml` (MORA was retired on 2026-11-01).
Add a row when you create a repo (`/new-project` Gate 4); change the status when
one is parked or archived.

Each repo keeps its own agent notes in `AGENTS.md` (with `CLAUDE.md` pointing to
it). Org skills live in `shared-assets/skills/`.

## Active (in the CEO project)

| Repo | What it is | Deploys to |
|------|------------|------------|
| `monjizeen-app` | Monjizeen work-management app (Laravel + Inertia + Vue): clients, projects, tickets, work updates, billing | VPS runner, `app.monjizeen.com` (+ staging) |
| `monjizeen-extension` | Chrome extension for the app | Chrome Web Store |
| `monjizeen-site` | Public website: landing and offer | VPS runner, monjizeen.com |
| `monjizeen-business` | Company notebook: ideas, offers, decisions (markdown) | Cloudflare (old site only) |
| `monjizeen-core` | Rules, QA checks and brief builder handed to AI tools per ticket | none |
| `shared-assets` | Org skills, shared GitHub Actions, deploy standard, client status files | none |
| `radar` | MENA web design and copy references (scraped sites) | VPS runner |
| `enjaz` | Design system (shadcn-vue base) and gallery; rename to Asaas being discussed | — |
| `kawader` | Talent directory; new plan is scraped, internally rated doers | — |

## Retired or parked (outside the CEO project)

From MORA's old registry. Not checked recently; ask Omar before working on one.

| Repo | What it was | Status |
|------|-------------|--------|
| `mora` | Old Cursor-based orchestrator (hooks, registry, Telegram bot) | Retired 2026-11-01; the CEO Claude project does its job |
| `studios` | Studios explorer (studios.mnjz.in) + Claude Code design studios | unknown |
| `daftar` | Link directory and library | unknown |
| `waqti` | Daily activity / habit tracker | unknown |
| `hadeed` | Gym exercises and protein calculator | unknown |
| `radsgh` | Radiology department task tracker | unknown |
| `modarraj-web` | Modarraj (Laravel + Inertia + Filament), app.modarraj.com | unknown |
| `modarraj-backend`, `modarraj-frontend` | Old Modarraj API and Flutter app | archived |
| `with-motion-backend`, `with-motion-frontend` | With Motion API and web app | parked |
| `monjizeen` | Older name for the app server repo (some docs still say `monjizeen/monjizeen`) | check against `monjizeen-app` |

## House habits for every agent

Kept from MORA:

- **Unclear which repo or product?** Ask Omar once before starting.
- **Push back before building.** Say in one line if a simpler or safer way exists.
- **Never mix clients.** One client's data never appears in another client's work.
