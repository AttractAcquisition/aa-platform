# CLAUDE.md — Attract Acquisition Platform System Bible

This file is the authoritative context document for Claude Code. Read it in full before touching any file in this workspace.

---

## 1. SYSTEM OVERVIEW

Attract Acquisition is a performance marketing agency for UK tradesmen running a fully AI-first operating system. The system consists of **5 frontend applications** all sharing **one Supabase backend** as the single source of truth.

Every application in this workspace connects to the same Supabase project. There is no separate staging Supabase project — all environments point to the same instance. Claude runs as an autonomous operator via Supabase Edge Functions. A cron runner on Railway fires all scheduled SOPs on their configured schedules.

---

## 2. THE FIVE APPLICATIONS

### `AICOS/` — React + Vite + TypeScript
**The AI control panel.**
- Deployed at `https://operator.attractacq.com`
- Primary operator interface: daily briefings, approval queue, sprint monitoring, pipeline, clients, finance, analytics, all 58 SOPs
- Claude runs as an autonomous operator via Supabase Edge Functions
- Cron runner fires all scheduled SOPs via a separate Railway cron service

### `Outreach-System/` — React + Vite + TypeScript
**The WhatsApp command centre.**
- Deployed at `https://outreach.attractacq.com`
- Manages all WhatsApp conversations, inbound message handling, AI reply suggestions, outreach queue approval, template management, suppression list
- Authentication via Supabase email/password

### `COS/` — React + Vite + TypeScript
**The main internal operations platform.**
- Deployed at `https://app.attractacq.com`
- Contains proof sprint management, client delivery, content production, brand intelligence, and broader agency operations
- Shares all core tables with AICOS

### `Proof-Capture/` — React + Vite + TypeScript
**Proof capture and client results documentation.**
- Deployed at `https://proof.attractacq.com`
- Clients submit proof of results which feeds into reporting and case studies

### `Website/` — Public marketing website
**The public-facing marketing website for Attract Acquisition.**
- Deployed at `https://attractacq.com`
- Represents the brand externally to prospective tradesman clients
- Purpose: lead generation, brand presence, case studies, service information, conversion to Proof Sprint sign-up
- May share Supabase for form submissions, lead capture, and populating the `prospects` table
- Any form submission that creates a prospect must set `status='new'` and `source_list='website'` so SOP 03 enrichment fires automatically via the database webhook
- All public-facing pages, case studies, service descriptions, and conversion flows live here

---

## 3. SINGLE SOURCE OF TRUTH — SUPABASE

| Field | Value |
|---|---|
| Project name | AICOS |
| URL | `https://fgyvcyksgbivhrqoxkmj.supabase.co` |
| Project ref | `fgyvcyksgbivhrqoxkmj` |

All 5 applications read and write to this single Supabase project. Edge Functions are deployed here and shared across all apps.

**NEVER create a second Supabase project — always use this one.**

---

## 4. COMPLETE TABLE REGISTRY — PUBLIC SCHEMA

### Core prospect and client tables (owned by AICOS)

| Table | Purpose |
|---|---|
| `prospects` | All lead data, pipeline status, enrichment data, quality scores, reply classification |
| `clients` | Client records, tier (proof_sprint/proof_brand/authority_brand), MRR, status, contact details |
| `sprints` | Active proof sprint tracking, CPL, ROAS, spend, leads, day number |
| `sprint_logs` | Daily sprint performance snapshots |
| `ad_set_performance_logs` | Meta ads performance history per ad set |
| `prospect_batches` | Daily batch staging records |

### Automation and operations tables (owned by AICOS)

| Table | Purpose |
|---|---|
| `approval_queue` | All items requiring human approval before action (non-WhatsApp content types only) |
| `ai_task_log` | Shared append-only audit log of every Claude API call across all apps |
| `ai_alerts` | System-generated alerts requiring operator attention |
| `cron_schedule` | All 18 cron job schedules, run history, status, last error |
| `daily_briefings` | SOP 58 morning briefing structured JSON output |
| `knowledge_base` | SOPs, HTML templates (MJR, SPOA), reference documents |
| `push_subscriptions` | Web Push notification browser subscriptions |

### Finance tables (owned by AICOS)

| Table | Purpose |
|---|---|
| `finance_ledger` | Income and expense entries, invoice tracking |
| `finance_snapshots` | Weekly finance dashboard snapshot JSON |
| `kpi_snapshots` | Monthly KPI review data with trend analysis |

### Document and storage tables (owned by AICOS)

| Table | Purpose |
|---|---|
| `documents` | References to files stored in Supabase Storage (MJR, SPOA, offer docs, onboarding briefs) |
| `client_reports` | Weekly client report records |

### WhatsApp domain tables (owned by Outreach-System)

| Table | Purpose |
|---|---|
| `whatsapp_conversations` | One row per prospect conversation, stage, service window, AI metadata |
| `whatsapp_messages` | Full message ledger inbound and outbound, status tracking |
| `whatsapp_ai_suggestions` | AI-drafted replies awaiting human approval |
| `whatsapp_outreach_queue` | SOP 01 cold outreach batches awaiting approval before send |
| `whatsapp_suppression_list` | Opt-outs and do-not-contact list, checked before every send |
| `whatsapp_templates` | Approved Meta WhatsApp message templates |
| `client_ai_context` | Assembled AI context for reply suggestion generation |
| `integration_events` | Append-only log of all WhatsApp integration events |
| `audit_events` | Compliance audit trail for all sends and actions |

### COS platform tables (owned by COS)

| Table | Purpose |
|---|---|
| `campaigns` | Campaign tracking linked to clients and prospects |
| `profiles` | User profiles |
| `proof_sprint_ad_variants` | Ad creative variants per sprint |
| `proof_sprint_assets` | Creative assets for sprints |
| `proof_sprint_business_intelligence` | Competitive intelligence per client |
| `proof_sprint_acceleration_reports` | Sprint performance acceleration analysis |
| `portal_documents` | Client portal document sharing |
| `portal_messages` | Client portal messaging |
| `portal_tasks` | Client portal task tracking |
| `ledger_entries` | COS financial ledger |
| `delivery_metrics` | Client delivery performance metrics |
| `delivery_progress` | Sprint delivery progress tracking |
| `distribution_metrics` | Outreach distribution metrics |
| `distribution_progress` | Outreach distribution progress |
| `content_calendar_entries` | Content scheduling |
| `content_bundles` | Grouped content pieces |
| `content_runs` | Content production runs |
| `organic_posts` | Organic social content |
| `brand_intelligence` | Brand research and competitor data |
| `brand_presets` | Brand style presets |
| `brand_settings` | Per-client brand configuration |
| `one_pagers` | Client one-pager documents |
| `one_pagers_v2` | Updated one-pager format |
| `positioning_documents` | Client positioning documents |
| `profile_builds` | Profile build tracking |
| `proof_assets` | Proof of results assets |
| `proof_cards` | Client results proof cards |
| `designs` | Design asset tracking |
| `assets` | General asset library |
| `knowledge_documents` | Knowledge base documents |
| `knowledge_chunks` | Chunked knowledge for vector search |
| `knowledge_queries` | Knowledge query history |
| `aa_scripts` | Video/content scripts |
| `aa_scene_plans` | Scene planning for video content |
| `aa_video_renders` | Video render tracking |

---

## 5. EDGE FUNCTIONS DEPLOYED

All deployed to `fgyvcyksgbivhrqoxkmj`. All deployed with `--no-verify-jwt` unless noted.

### SOP execution functions

| Function | Model | Purpose |
|---|---|---|
| `run-sop` | varies | Generic SOP executor with agentic Claude loop and tool use |
| `claude-chat` | Sonnet | Streaming chat interface with full tool access (**verify_jwt: true**) |
| `sop-58-daily-briefing` | Sonnet | Morning briefing, parallel DB queries, single Sonnet call, writes to `daily_briefings` |
| `sop-06-reply-triage` | Haiku | WhatsApp reply classification, updates `prospects` and `whatsapp_conversations` |
| `sop-01-outreach-drafts` | Sonnet | Personalised outreach drafting, writes to `whatsapp_outreach_queue` |
| `sop-02-prospect-scraper` | Haiku | Prospect scraping and staging, triggers enrichment webhook |
| `sop-03-enrichment` | Haiku | Prospect enrichment and quality scoring with web search |
| `sop-04-crm-staging` | Haiku | CRM batch staging, creates `prospect_batches` records |
| `sop-05-lead-sourcing` | Sonnet | Lead source analysis and recommendation |
| `sop-07-call-brief` | Sonnet | Discovery call brief with web research |
| `sop-08-mjr-build` | Sonnet | Missed Jobs Report HTML generation, stores in Supabase Storage |
| `sop-10-delivery-sequence` | Sonnet | MJR delivery WhatsApp sequence |
| `sop-12-spoa-build` | Sonnet | SPOA document generation, stores in Supabase Storage |
| `sop-15-offer-prep` | Sonnet | Offer document and call prep cheat sheet |
| `sop-17-onboarding-brief` | Sonnet | Client onboarding brief with campaign strategy |
| `sop-21-sprint-daily-ops` | Sonnet | Sprint daily ops, KPI logging, alert creation |
| `sop-23-ads-monitoring` | Sonnet | Meta ads kill/scale logic, pauses underperforming ad sets |
| `sop-26-sprint-closeout` | Sonnet | Day 14 sprint closeout analysis and recommendation |
| `sop-31-proof-brand-ops` | Sonnet | Proof Brand monthly delivery tracking with upsell detection |
| `sop-33-sop-versioning` | Sonnet | SOP performance review and improvement suggestions |
| `sop-35-upsell-detection` | Sonnet | Deterministic upsell scoring, Claude only for qualifying clients |
| `sop-41-weekly-review` | Sonnet | Weekly review briefing with nine parallel queries |
| `sop-43-authority-brand-ops` | Sonnet | Authority Brand monthly delivery review |
| `sop-46-billing` | Sonnet | Billing, invoice tracking, payment chase message drafting |
| `sop-47-weekly-reports` | Sonnet | Weekly client HTML report generation |
| `sop-49-content` | Sonnet | Social media content brief generation |
| `sop-51-admin-check` | Haiku | Admin health check, flags stale approvals and cron failures |
| `sop-52-backup-check` | Haiku | Backup and security check with dry-run ping |
| `sop-53-kpi-review` | Sonnet | Monthly KPI review with period comparison |
| `sop-56-finance-dashboard` | Haiku | Weekly finance aggregation and snapshot |

### WhatsApp functions

| Function | Purpose |
|---|---|
| `meta-whatsapp-webhook` | Inbound message handler with HMAC verification, idempotency, opt-out detection |
| `send-whatsapp-message` | Outbound free-form message send with suppression check and service window validation |
| `send-whatsapp-template-message` | Outbound template message send |
| `generate-whatsapp-reply-suggestion` | AI reply draft using conversation history and prospect context |
| `sync-whatsapp-templates` | Meta template sync from Business Account |
| `whatsapp-integration-health` | Integration health metrics and environment check |

### Other functions

| Function | Purpose |
|---|---|
| `meta-ads-sync` | Meta Marketing API performance sync, writes to `proof_sprints` table |
| `send-push-notification` | Web Push notification sender using VAPID, auto-removes expired subscriptions |
| `update-prospect-from-conversation` | Maps `whatsapp_conversations.stage` → `prospects.status`, called by Outreach-System instead of direct DB write |
| `mark-prospect-won` | Sets `prospects.status = 'closed_won'`, called by COS Clients page when converting a prospect to client |
| `update-user-role` | Accepts `{user_id, role, metadata_id}`, validates role in admin/delivery/distribution/client, writes `app_metadata` via Supabase admin API |
| `proof-sprint-run-deliverable` | Accepts `{client_id, deliverable_key, input_json}`, calls Sonnet to generate D1–D15 sprint deliverable content, upserts to `proof_sprint_client_data` |
| `apify-start` | Accepts Scraper payload, triggers Apify Google Maps actor run; stubs when `APIFY_API_TOKEN` not set |
| `apify-results` | Polls Apify run by `run_id`, maps dataset items to ProspectRow shape; stub mode returns sample data |

---

## 6. MODEL ROUTING — STRICT TWO-TIER STRATEGY

### HAIKU (`claude-haiku-4-5-20251001`)
Use for **mechanical tasks with structured output only**:
- SOPs 02, 03, 04, 06, 51, 52, 56
- Dedup checks, CRM staging, finance aggregation, reply classification, status updates
- Any function that does not generate creative or analytical text

### SONNET (`claude-sonnet-4-6`)
Use for **everything that requires generation, reasoning, or analysis**:
- All document builds (MJR, SPOA, onboarding briefs, offer docs)
- Outreach drafts, reports, briefings, call briefs
- Ads analysis, sprint analysis, KPI reviews
- Chat interface, content generation

**NEVER use Opus in any function in this system.** Sonnet handles all complex tasks. If output quality is insufficient, improve the prompt rather than escalating to Opus.

---

## 7. CRON SCHEDULE

All 18 jobs run via `cron-runner.js` on the Railway `AICOS-cron` service. All times in `Europe/London` timezone.

### Daily jobs
| Time | Job |
|---|---|
| 05:00 | SOP 58 daily briefing (`sop-58-daily-briefing`) |
| 06:30 | SOP 21 sprint daily ops (`run-sop`) |
| 07:00 | SOP 23 ads monitoring (`run-sop`), SOP 26 sprint closeout (`sop-26-sprint-closeout`) |
| 07:30 | SOP 06 reply triage (`run-sop`) |

### Weekday jobs (Mon–Fri)
| Time | Job |
|---|---|
| 08:00 | SOP 01 outreach drafts (`run-sop`) |

### Monday jobs
| Time | Job |
|---|---|
| 06:00 | SOP 56 finance dashboard (`sop-56-finance-dashboard`) |
| 08:00 | SOP 02 prospect scraper (`sop-02-prospect-scraper`) |
| 08:30 | SOP 51 admin check (`sop-51-admin-check`), SOP 46 billing (`sop-46-billing`) |
| 09:00 | SOP 35 upsell detection (`run-sop`) |

### Friday jobs
| Time | Job |
|---|---|
| 16:00 | SOP 41 weekly review (`sop-41-weekly-review`) |
| 17:00 | SOP 47 weekly reports (`run-sop`) |

### Sunday jobs
| Time | Job |
|---|---|
| 01:00 | SOP 52 backup check (`sop-52-backup-check`) |

### Monthly jobs (1st of month)
| Time | Job |
|---|---|
| 08:00 | SOP 53 KPI review (`sop-53-kpi-review`) |
| 09:00 | SOP 31 Proof Brand ops (`run-sop`) |
| 10:00 | SOP 43 Authority Brand ops (`run-sop`) |
| 11:00 | SOP 33 SOP versioning (`sop-33-sop-versioning`) |

---

## 8. DEPLOYMENT INFRASTRUCTURE

### Railway project `37c7a8ab` (victorious-simplicity)
- `AICOS-cron` service — runs `node cron-runner.js`, uses `railway.cron.json`
- Required env vars: `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`

### Railway project `75d68c53` (refreshing-communication)
- `AICOS` web service — runs `node server.js`, uses `railway.json`, serves React frontend at `https://operator.attractacq.com`

### GitHub Pages
- `Outreach-System` — deployed via GitHub Actions at `https://outreach.attractacq.com` (custom domain, CNAME in `public/CNAME`)
- Requires GitHub Actions secrets: `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`

### Other
- `COS` — deployed at `https://app.attractacq.com`
- `Proof-Capture` — deployed at `https://proof.attractacq.com`
- `Website` — deployed at `https://attractacq.com`

---

## 9. KEY INTEGRATION RULES — READ BEFORE MAKING ANY CHANGES

### Table ownership and write rules

| Owner | Tables |
|---|---|
| **AICOS** | `prospects`, `clients`, `sprints`, `approval_queue`, `ai_alerts`, `cron_schedule`, `daily_briefings`, `knowledge_base`, `finance_ledger`, `finance_snapshots`, `kpi_snapshots`, `documents`, `push_subscriptions` |
| **Outreach-System** | `whatsapp_conversations`, `whatsapp_messages`, `whatsapp_ai_suggestions`, `whatsapp_outreach_queue`, `whatsapp_suppression_list`, `whatsapp_templates` |
| **COS** | All `proof_sprint_*` tables, `portal_*` tables, `campaigns`, `profiles`, `content_*` tables, `brand_*` tables, `ledger_entries`, `delivery_*` tables |
| **Shared append-only** | `ai_task_log`, `integration_events`, `audit_events` — all apps write, none delete |

### Cross-app data rules

- `Outreach-System` reads `prospects` and `clients` but **NEVER writes to them directly** — AICOS Edge Functions own all writes
- `AICOS` can write `ai_intent`, `needs_human`, `stage` to `whatsapp_conversations` but does not own the table
- WhatsApp AI drafts flow through `whatsapp_ai_suggestions` (warm lead replies) and `whatsapp_outreach_queue` (cold outreach batches) — **NEVER through `approval_queue`**
- `approval_queue` is for: `whatsapp_message` (outreach approval), `mjr_document`, `spoa_document`, `client_report`, `delivery_sequence`, `offer_document`, `call_brief`
- The suppression list **must** be checked via `checkSuppression()` before any WhatsApp send operation
- All write operations to shared tables must go through Edge Functions — **never allow direct browser inserts to cross-app tables**

### Security rules

- All Edge Functions must be deployed with `--no-verify-jwt` **EXCEPT** `claude-chat` which uses `verify_jwt: true`
- Frontend apps use the anon key — ensure anon SELECT policies exist on all tables the frontend reads
- Service role key is only used in Edge Functions and `cron-runner.js` — **never expose it in frontend code**
- VAPID keys (`VAPID_PUBLIC_KEY`, `VAPID_PRIVATE_KEY`, `VAPID_EMAIL`) are in Supabase secrets — `VITE_VAPID_PUBLIC_KEY` only in Railway/GitHub Actions

---

## 10. ENVIRONMENT VARIABLES BY SERVICE

### Railway `AICOS` web service
```
VITE_SUPABASE_URL
VITE_SUPABASE_ANON_KEY
ANTHROPIC_API_KEY
META_ACCESS_TOKEN
META_AD_ACCOUNT_ID
META_GRAPH_API_VERSION
RESEND_API_KEY
RESEND_FROM_EMAIL
SUPABASE_ANON_KEY
SUPABASE_SERVICE_ROLE_KEY
SUPABASE_URL
WEBHOOK_VERIFY_TOKEN
WHATSAPP_ACCESS_TOKEN
WHATSAPP_PHONE_NUMBER_ID
VITE_VAPID_PUBLIC_KEY
```

### Railway `AICOS-cron` service
```
SUPABASE_URL
SUPABASE_SERVICE_ROLE_KEY
```

### Supabase Edge Function secrets
```
ANTHROPIC_API_KEY
META_ACCESS_TOKEN
META_AD_ACCOUNT_ID
META_GRAPH_API_VERSION
SUPABASE_URL
SUPABASE_SERVICE_ROLE_KEY
SUPABASE_ANON_KEY
WHATSAPP_ACCESS_TOKEN
WHATSAPP_PHONE_NUMBER_ID
WHATSAPP_BUSINESS_ACCOUNT_ID
WHATSAPP_APP_SECRET
WHATSAPP_WEBHOOK_VERIFY_TOKEN
WHATSAPP_GRAPH_API_VERSION
RESEND_API_KEY
RESEND_FROM_EMAIL
VAPID_PUBLIC_KEY
VAPID_PRIVATE_KEY
VAPID_EMAIL
AI_PROVIDER
AI_MODEL
```

### GitHub Actions (`Outreach-System`)
```
VITE_SUPABASE_URL
VITE_SUPABASE_ANON_KEY
```

---

## 11. BEFORE MAKING ANY CHANGE — CHECKLIST

1. **Which application owns** the feature or table being changed?
2. **Does this change affect shared tables?** If yes, identify all apps that read that table and check for breaking changes.
3. **Is a new table needed?** Create a migration file with timestamp, add RLS policies, run `npx supabase db push`.
4. **Is a new Edge Function needed?** Create in `supabase/functions/<name>/index.ts`, deploy with `npx supabase functions deploy <name> --no-verify-jwt`.
5. **Does the frontend need updating?** Update the correct app's React components using React Query patterns already established.
6. **Are new environment variables needed?** Add to all required places: Railway, Supabase secrets, GitHub Actions, `.env.example`.
7. **Commit each repo independently** with a clear commit message.
8. **After any Edge Function change**, redeploy it immediately.
9. **Check `docs/sop-audit.md`** in `AICOS` for SOP coverage status before adding new SOP automations.

---

## 12. COMMON OPERATIONS RUNBOOK

### Deploy an Edge Function
```bash
npx supabase functions deploy <function-name> --no-verify-jwt
```

### Run a database migration
```bash
npx supabase db push
# If conflicts:
npx supabase migration repair --status applied <timestamp>
npx supabase db push
```

### Trigger a SOP manually from CLI
```bash
curl -X POST https://fgyvcyksgbivhrqoxkmj.supabase.co/functions/v1/<function-name> \
  -H 'Authorization: Bearer <service-role-key>' \
  -H 'Content-Type: application/json' \
  -d '{}'
```

### Check what is in ai_task_log
```bash
npx supabase db query \
  'select sop_id, sop_name, status, created_at, output_summary from ai_task_log order by created_at desc limit 20' \
  --linked
```

### Check cron schedule status
```bash
npx supabase db query \
  'select sop_id, sop_name, is_active, last_run, last_status, next_run, last_error from cron_schedule order by next_run asc' \
  --linked
```

### Add a new user to Outreach-System
Supabase dashboard → Authentication → Users → Add User → enter email and password.

### Rotate the Supabase access token
```bash
# supabase.com → Account → Access Tokens → delete current → generate new
export SUPABASE_ACCESS_TOKEN=new-token
```

---

## 13. WEBSITE

Repo: `Website/`

The public marketing website for Attract Acquisition, representing the brand externally to prospective tradesman clients.

**Purpose:** lead generation, brand presence, case studies, service information, conversion to Proof Sprint sign-up.

**Supabase integration:** may use the shared Supabase project for contact form submissions, lead capture, and populating the `prospects` table when a tradesman enquires via the website.

**Lead capture rule:** any form submission that creates a prospect must write to the `prospects` table with these columns:
```
business_name, owner_name, phone, niche, status='new', source_list='website'
```
This ensures SOP 03 enrichment fires automatically via the database webhook.

When editing this repo: ensure any lead capture forms write to `prospects` with the correct column names and do not conflict with the RLS policies on that table.
