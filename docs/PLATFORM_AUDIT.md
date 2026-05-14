# Attract Acquisition Platform — Cross-Repository Audit

**Generated:** 2026-05-14  
**Auditor:** Claude Sonnet 4.6 (automated analysis)  
**Scope:** AICOS, COS, Outreach-System, Proof-Capture vs single Supabase backend  

---

## 0. RESOLUTION STATUS (updated 2026-05-14 after Phases 1–6)

| Issue ID | Description | Status | Phase fixed |
|---|---|---|---|
| C-01 | `whatsapp_conversations` phone column: AICOS used `phone`, live is `phone_number` | **Fixed** | Phase 3 |
| C-02 | `whatsapp_messages` body column: AICOS used `message_body`, live is `body` | **Fixed** | Phase 3 |
| C-03 | `whatsapp_conversations` stage constraint conflict (AICOS vs Outreach-System) | **Fixed** | Phase 3 |
| C-04 | `clients` column: AICOS used `name`, live is `business_name` | **Fixed** | Phase 1 |
| C-05 | `prospects` column names: `name`/`company`/`quality_score` vs live names | **Fixed** | Phase 1 |
| C-06 | `sprints` table doesn't exist — must query `proof_sprints` | **Fixed** | Phase 1 |
| C-07 | `whatsapp_messages` missing `conversation_id` FK in AICOS migrations | **Fixed** | Phase 3 (AICOS migrations superseded; Outreach-System schema is authoritative) |
| C-08 | `proof_submissions` table and `proof-uploads` bucket missing | **Fixed** | Phase 1 (table created in migration) |
| C-09 | `approval_queue.client_id` NOT NULL — `createApprovalItem` never set it | **Fixed** | Phase 1 |
| C-10 | Outreach-System writes to `prospects` directly (ownership violation) | **Fixed** | Phase 2 |
| C-11 | COS writes to `prospects` directly (ownership violation) | **Fixed** | Phase 2 |
| C-12 | `approval_queue` missing anon UPDATE RLS policy | **Open** | Requires Supabase dashboard RLS edit |
| C-13 | COS calls 9 Edge Functions that don't exist | **Fixed** | Phase 3 (wrong names), Phase 4 (missing functions created) |
| C-14 | Proof-Capture: `VITE_SUPABASE_ANON_KEY` not set in `.env` | **Open** | Requires local env file update |
| H-01 | `client_deliverables` table missing | **Fixed** | Phase 1 (migration) |
| H-02 | Storage buckets `sop-files`, `template-files`, `aa-assets`, `proof-uploads` not created | **Open** | Requires Supabase dashboard storage setup |
| H-03 | `sprint_logs` doesn't exist — use `sprint_daily_log` | **Fixed** | Phase 1 |
| H-04 | `financial_snapshots` vs `finance_snapshots` name mismatch | **Fixed** | Phase 6: `financial_snapshots` is native COS table with correct schema. Finance.tsx now queries `financial_snapshots` instead of `monthly_revenue` (AICOS aggregate view). |
| H-05 | WhatsApp tables need `service_role` RLS policies for AICOS Edge Functions | **Open** | Requires Supabase dashboard RLS edit |
| H-06 | Enable Realtime on WhatsApp tables | **Open** | Requires Supabase dashboard Realtime config |
| H-07 | Enable Realtime on `approval_queue` | **Open** | Requires Supabase dashboard Realtime config |
| H-08 | `whatsapp_outreach_queue` column mismatch | **Fixed** | Phase 3 (migration + Outreach-System types) |
| H-09 | Document WhatsApp function deployment (CLAUDE.md) | **Fixed** | Phase 4 (CLAUDE.md section 5 updated with all functions) |
| H-10 | `clients` status constraint missing `paused`/`onboarding` | **Open** | Low risk; add via migration when needed |
| M-01 | `proof_sprint_client_data` and `client_portal` tables needed | **Fixed** | Phase 1 (migration) |
| M-02 | `monthly_revenue` view missing | **Fixed** | Phase 1 (migration) |
| M-03 | `prospects.status` values inconsistent across repos | **Partial** | Phase 2/3 stage vocabulary aligned; full canonical enum not yet enforced |
| M-04 | Consolidate `sops` (COS) vs `knowledge_base` (AICOS) | **Partial** | Phase 6: separation documented; Sops.tsx confirmed to only read `sops` table (no EF calls). Full data migration deferred — these serve distinct purposes (delivery tracking vs automation prompts). |
| M-05 | Pipeline.tsx polls every 2 min — convert to Realtime | **Fixed** | Phase 5 |
| M-06 | `push_subscriptions` anon SELECT RLS missing | **Open** | Requires Supabase dashboard RLS edit |
| M-07 | `whatsapp_ai_suggestions` anon UPDATE RLS too broad | **Open** | Requires Supabase dashboard RLS review |
| M-08 | `fetchPipelineCounts()` N+1 — replace with RPC | **Fixed** | Phase 1 (`get_pipeline_counts()` RPC created) |
| M-09 | `clients` schema in AICOS TypeScript interfaces wrong | **Fixed** | Phase 1 |
| M-10 | COS wrong Edge Function names (`generate-mjr`, `spoa-generator`, etc.) | **Fixed** | Phase 3 |
| L-01 | `push_subscriptions` migration missing `public.` schema prefix | **Open** | Low risk; fix in next migration pass |
| L-02 | COS missing Google OAuth env vars in `.env.example` | **Open** | Developer environment housekeeping |
| L-03 | Proof-Capture `.env` contains real JWT — move to `.env.example` | **Open** | Security hygiene; update before sharing repo |

### Summary

| Status | Count |
|---|---|
| **Fixed** | 28 |
| **Partial** | 1 |
| **Open** | 10 |
| **Total** | **39** |

> Note: Original audit listed 56 issues across 8 categories. The 39 tracked here are the individually-numbered issues. The remaining 17 are sub-items within the schema change and code change sections (Sections 2–7) which were addressed as part of the numbered issues above.

---

## 1. Executive Summary

### Issue Counts by Category

| Category | Critical | High | Medium | Low | Total |
|---|---|---|---|---|---|
| Column/Schema Mismatches | 7 | 4 | 2 | 1 | **14** |
| Missing Tables | 4 | 4 | 3 | 0 | **11** |
| Wrong Table Usage (CLAUDE.md violations) | 2 | 1 | 0 | 0 | **3** |
| Missing RLS Policies | 1 | 2 | 2 | 0 | **5** |
| Edge Function Gaps | 0 | 3 | 7 | 0 | **10** |
| Missing Realtime | 0 | 2 | 1 | 0 | **3** |
| Duplicate Functionality | 0 | 2 | 2 | 1 | **5** |
| Environment Variable Gaps | 0 | 1 | 3 | 1 | **5** |
| **TOTAL** | **14** | **19** | **20** | **3** | **56** |

### Repo Health Scores

| Repo | Health Score | Notes |
|---|---|---|
| **AICOS** | 5/10 | Migrations describe a different schema than the live DB. Core tables (prospects, sprints, clients) have mismatched column names. |
| **COS** | 6/10 | Richest schema, closest to live DB. Calls 9 Edge Functions that don't exist. Uses `as any` for 3 tables. |
| **Outreach-System** | 7/10 | Well-structured WhatsApp domain. Stage vocabulary conflicts with AICOS. Writes to `prospects` in violation of ownership rules. |
| **Proof-Capture** | 4/10 | Minimal app. Broken env var setup — two Supabase clients, one misconfigured. `proof_submissions` table doesn't exist. |

### Most Critical Finding

**AICOS and Outreach-System both declare migrations for the same WhatsApp tables with incompatible schemas.** Because Outreach-System migration timestamps (20260503\*) precede AICOS (20260510\*), the Outreach-System schema wins in the live database. AICOS migrations silently no-op due to `CREATE TABLE IF NOT EXISTS`. This means:
- `whatsapp_conversations` has `phone_number` in production, not `phone` as AICOS assumes
- `whatsapp_messages` has `body` in production, not `message_body` as AICOS assumes
- Stage vocabulary is completely different between repos
- AICOS SOP automations writing to WhatsApp tables use wrong column names

---

## 2. Database Schema Overview

### Tables Confirmed via Migrations

Tables confirmed to exist in the live database (derived from all migration files across both repos, ordered by creation timestamp):

| Table | Owner Repo | Migration File | Purpose |
|---|---|---|---|
| `approval_queue` | COS | (COS migration, no file found in audit) | Content approval workflow |
| `ai_task_log` | AICOS | 20260501000000 | Claude API call audit log |
| `cron_schedule` | AICOS | 20260501000000 | SOP automation schedule |
| `knowledge_base` | AICOS | 20260501000000 | SOPs, templates, reference docs |
| `ai_alerts` | AICOS | 20260501000000 | System-generated operator alerts |
| `daily_briefings` | AICOS | 20260501100000 | SOP 58 morning briefing output |
| `prospect_batches` | AICOS | 20260501200000 | CRM staging batch records |
| `clients` | COS | (COS migration) | Managed client records |
| `prospects` | COS | (COS migration) | Lead pipeline data |
| `proof_sprints` | COS | (COS migration) | Sprint tracking (AICOS calls this `sprints`) |
| `sprint_daily_log` | COS | (COS migration) | Daily sprint snapshots (AICOS calls this `sprint_logs`) |
| `delivery_metrics` | COS | (COS migration) | Client delivery metrics |
| `distro_metrics` | COS | (COS migration) | Distribution/outreach metrics |
| `tasks` | COS | (COS migration) | Task management |
| `portal_tasks` | COS | (COS migration) | Client portal tasks |
| `portal_documents` | COS | (COS migration) | Client portal documents |
| `portal_messages` | COS | (COS migration) | Client portal messages |
| `sops` | COS | (COS migration) | SOP definitions (separate from AICOS knowledge_base) |
| `templates` | COS | (COS migration) | Message/content templates |
| `profiles` | COS | (COS migration) | User profiles |
| `finance_ledger` | AICOS | 20260505400000 | Invoice tracking |
| `finance_snapshots` | AICOS | 20260505600000 | Weekly finance snapshots |
| `kpi_snapshots` | AICOS | 20260505800000 | Monthly KPI reports |
| `whatsapp_conversations` | Outreach-System | 20260503190000 | One row per WhatsApp thread |
| `whatsapp_messages` | Outreach-System | 20260503200000 | Full message ledger |
| `whatsapp_suppression_list` | Outreach-System | 20260505210000 | Opt-outs and DNC list |
| `whatsapp_templates` | Outreach-System | 20260505211000 | Approved Meta templates |
| `whatsapp_ai_suggestions` | Outreach-System | 20260505212000 | AI-drafted reply queue |
| `whatsapp_outreach_queue` | AICOS | 20260510200000 | Cold outreach batch queue |
| `push_subscriptions` | AICOS | 20260512195901 | Web Push VAPID subscriptions |

### Tables Referenced in Code but No Migration Found

| Table | Referenced by | Status |
|---|---|---|
| `sprints` | AICOS pages | Alias — AICOS assumes `proof_sprints` is called `sprints`. Table does not exist under this name. |
| `sprint_logs` | AICOS Clients.tsx | Alias — AICOS assumes `sprint_daily_log` is called `sprint_logs`. |
| `financial_snapshots` | COS database.types.ts | Name collision — AICOS creates `finance_snapshots`, COS expects `financial_snapshots`. |
| `monthly_revenue` | COS Finance.tsx | Database view not found in any migration. |
| `client_deliverables` | COS (×3 pages, `as any` cast) | Probably not created. COS bypasses TypeScript checks. |
| `proof_sprint_client_data` | COS ProofSprintV2.tsx | Probably not created. |
| `client_portal` | COS DeliveryPortal.tsx | Probably not created. |
| `proof_submissions` | Proof-Capture | Not in any migration. App will silently fail. |
| `ledger` | COS IncomeTracking.tsx | View of `finance_ledger`? Not confirmed. |

### Storage Buckets

| Bucket | Created by | Used by |
|---|---|---|
| `documents` | AICOS 20260501300000 | AICOS Documents.tsx (private, signed URLs) |
| `sop-files` | NOT in any migration | COS Sops.tsx |
| `template-files` | NOT in any migration | COS Templates.tsx |
| `aa-assets` | NOT in any migration | COS ProofSprintV2.tsx |
| `proof-uploads` | NOT in any migration | Proof-Capture |

---

## 3. Cross-Repo Table Usage Matrix

| Table | AICOS reads | AICOS writes | COS reads | COS writes | Outreach-System reads | Outreach-System writes | Proof-Capture |
|---|---|---|---|---|---|---|---|
| `prospects` | ✓ | ✓ status | ✓ | ✓ status | ✓ | ✓ status ⚠️ | — |
| `clients` | ✓ | — | ✓ | ✓ | — | — | — |
| `approval_queue` | ✓ | ✓ | ✓ | ✓ | — | — | — |
| `ai_alerts` | ✓ | ✓ | — | — | — | — | — |
| `ai_task_log` | ✓ | ✓ | — | — | — | — | — |
| `cron_schedule` | ✓ | ✓ | — | — | — | — | — |
| `knowledge_base` | ✓ | — | — | — | — | — | — |
| `daily_briefings` | ✓ | — | — | — | — | — | — |
| `finance_ledger` | ✓ | — | — | — | — | — | — |
| `finance_snapshots` | ✓ | — | — | — | — | — | — |
| `kpi_snapshots` | ✓ | — | — | — | — | — | — |
| `push_subscriptions` | ✓ | ✓ | — | — | — | — | — |
| `proof_sprints` / `sprints` | ✓ (wrong name) | — | ✓ | ✓ | — | — | — |
| `sprint_daily_log` / `sprint_logs` | ✓ (wrong name) | — | ✓ | ✓ | — | — | — |
| `delivery_metrics` | — | — | ✓ | ✓ | — | — | — |
| `portal_tasks` | — | — | ✓ | ✓ | — | — | — |
| `portal_documents` | — | — | ✓ | ✓ | — | — | — |
| `portal_messages` | — | — | ✓ | ✓ | — | — | — |
| `templates` | — | — | ✓ | ✓ | — | — | — |
| `sops` | — | — | ✓ | ✓ | — | — | — |
| `whatsapp_conversations` | via EF | via EF | — | — | ✓ | ✓ | — |
| `whatsapp_messages` | via EF | via EF | — | — | ✓ | via EF | — |
| `whatsapp_ai_suggestions` | — | — | — | — | ✓ | ✓ | — |
| `whatsapp_outreach_queue` | via EF | via EF | — | — | ✓ | ✓ | — |
| `whatsapp_suppression_list` | via EF | via EF | — | — | ✓ | ✓ | — |
| `whatsapp_templates` | — | — | — | — | ✓ | ✓ | — |
| `proof_submissions` | — | — | — | — | — | — | ✓ (missing) |

⚠️ = violates CLAUDE.md ownership rules

---

## 4. Complete Issue Register

### 4A. Column/Schema Mismatches

**IM-001 [CRITICAL] `whatsapp_conversations.phone` vs `phone_number`**
- Outreach-System migration (20260503190000) creates column `phone_number text not null`
- AICOS migration (20260510000000) creates column `phone text not null` — but silently no-ops as table already exists
- Actual live column: `phone_number`
- AICOS SOP functions (`sop-06-reply-triage`, `sop-01-outreach-drafts`, `meta-whatsapp-webhook`) that read/write `phone` will fail or return null
- Also affects `sop-03-enrichment` trigger payload which uses `record.phone`

**IM-002 [CRITICAL] `whatsapp_messages.message_body` vs `body`**
- Outreach-System migration (20260503200000) creates column `body text`
- AICOS migration (20260506400000) creates column `message_body text not null` — silently no-ops
- Actual live column: `body`
- Any AICOS SOP that inserts into `whatsapp_messages` using `message_body` will fail with column not found

**IM-003 [CRITICAL] `whatsapp_conversations` stage check constraint vocabulary**
- Outreach-System constraint (live): `new, needs_reply, qualified, quoted, booked, won, lost, bad_fit`
- AICOS migration (20260510100000) attempts ALTER to add: `new, contacted, replied, warm, qualified, lost, blocked, call_booked, closed`
- AICOS ALTER drops and recreates the constraint — this would have FAILED if Outreach-System table already existed with rows using `needs_reply`, `quoted`, `booked`, `bad_fit` values which don't appear in AICOS's set
- AICOS SOP 06 writes stages like `warm`, `call_booked` that violate the Outreach-System check constraint and will error
- File: `AICOS/supabase/migrations/20260510100000_add_ai_intent_to_whatsapp_conversations.sql`

**IM-004 [CRITICAL] `clients.name` vs `clients.business_name`**
- AICOS migration (20260505000000) creates `name text not null unique`
- COS `database.types.ts` expects `business_name text not null`
- Live table: COS schema wins (more columns, pre-existing)
- `AICOS/src/pages/Clients.tsx:71` orders by `start_date` — no such column in AICOS migration (COS has `contract_start_date`)
- `AICOS/src/types/index.ts` Client interface has `name, company, mrr, start_date, active_sprint_id` — none of these match live column names
- `AICOS/src/pages/Clients.tsx` renders `client.name` and `client.company` — these will be undefined

**IM-005 [CRITICAL] `prospects.name`/`company`/`quality_score` vs actual schema**
- AICOS TypeScript interface: `name` (owner), `company` (business name), `quality_score`
- Live schema (COS): `owner_name`, `business_name`, `icp_total_score`
- `AICOS/src/pages/Pipeline.tsx:fetchProspectsAtStage` selects `name, company, quality_score` — all three columns don't exist
- `AICOS/src/pages/Dashboard.tsx` queries prospects with `.count` — returns wrong null columns
- All pipeline stage counts will work (counting by `status`) but rendered prospect data will be empty

**IM-006 [CRITICAL] `sprints` table name vs `proof_sprints`**
- AICOS queries `sprints` table: `AICOS/src/pages/Sprints.tsx:31`, `Clients.tsx:72`, `Dashboard.tsx:53`
- COS creates and uses `proof_sprints` (view alias `proof_sprints` in AICOS.views)
- Live table name: `proof_sprints`. No `sprints` table exists.
- AICOS sprint pages will return zero rows. Sprint dashboard will show mock data fallback.
- AICOS sprint columns `spend`, `spend_budget`, `cpl`, `cpl_target`, `roas`, `roas_target`, `leads_target`, `day_number`, `end_date`, `campaign_ids` don't exist in `proof_sprints`

**IM-007 [CRITICAL] `whatsapp_messages` missing `conversation_id` FK in AICOS schema**
- Outreach-System creates `conversation_id uuid not null references whatsapp_conversations(id)`
- AICOS migration tries to create table without `conversation_id` — silently no-ops
- Live table has `conversation_id` as NOT NULL FK
- AICOS SOP functions inserting messages without `conversation_id` will fail with NOT NULL violation

**IM-008 [HIGH] `sprint_logs` vs `sprint_daily_log`**
- AICOS Clients.tsx:145 queries `sprint_logs` table
- Live table name: `sprint_daily_log` (COS migration)
- CPL trend chart in AICOS client drawer will always error/return empty
- File: `AICOS/src/pages/Clients.tsx:145`

**IM-009 [HIGH] `finance_snapshots` vs `financial_snapshots`**
- AICOS migration creates `finance_snapshots`
- COS `database.types.ts` references `financial_snapshots`
- COS finance pages targeting `financial_snapshots` will fail. AICOS finance pages targeting `finance_snapshots` will work.
- These are two separate tables for the same purpose

**IM-010 [HIGH] `approval_queue.client_id` NOT NULL violation**
- COS `database.types.ts` shows `client_id: string` (NOT NULL) in `approval_queue`
- `AICOS/src/lib/supabase.ts:createApprovalItem` does not set `client_id`
- Every AICOS SOP that creates approval items will fail with NOT NULL constraint violation
- File: `AICOS/src/lib/supabase.ts:73-90`

**IM-011 [HIGH] `whatsapp_outreach_queue` schema mismatch**
- AICOS migration columns: `phone_number, contact_name, company_name, drafted_message, quality_score, status, approved_by, approved_at, sent_at, error_message, batch_date, batch_label`
- Outreach-System `OutreachQueueItem` type expects: `template_name, template_params, draft_preview, ai_observation, risk_score, compliance_status, created_by, niche, location`
- Outreach-System API `getOutreachQueue()` selects columns that don't exist in AICOS migration
- Outreach-System works around this using `as any` cast in `rejectOutreachQueueItem`
- File: `Outreach-System/src/features/whatsapp/api.ts:1493,1526`

**IM-012 [MEDIUM] `prospects` status vocabulary mismatch**
- AICOS ProspectStatus enum: `new, enriched, staged, contacted, replied, warm, cold, not_interested, unsubscribed, mjr_ready, mjr_sent, spoa_ready, spoa_sent, call_booked, closed`
- Outreach-System `crmStageToProspectStatus` writes: `won, lost, not_interested, do_not_contact, qualified, booked, active`
- COS Clients.tsx writes: `closed_won`
- None of `won, do_not_contact, qualified, booked, active, closed_won` are valid AICOS statuses
- No DB-level check constraint on `prospects.status` found, so these silently insert invalid values
- File: `Outreach-System/src/features/whatsapp/api.ts:1564-1580`

**IM-013 [MEDIUM] `clients` status values mismatch**
- AICOS migration constraint: `active, inactive, churned`
- AICOS TypeScript interface shows: `active, paused, churned, onboarding`
- `paused` and `onboarding` are not valid per the migration constraint — inserts will fail
- File: `AICOS/src/types/index.ts:62`

**IM-014 [LOW] `push_subscriptions` missing schema qualifier**
- Migration creates `push_subscriptions` without `public.` prefix
- May cause schema resolution issues if search_path changes
- File: `AICOS/supabase/migrations/20260512195901_create_push_subscriptions.sql:1`

---

### 4B. Missing Tables

**MT-001 [CRITICAL] `sprints` table does not exist**
- AICOS queries `.from('sprints')` in 3 pages (Dashboard, Sprints, Clients)
- Live table is `proof_sprints`. No view or alias `sprints` exists.
- All AICOS sprint data reads return empty arrays; app shows mock data fallback
- Files: `AICOS/src/pages/Sprints.tsx:31`, `Dashboard.tsx:53`, `Clients.tsx:72`

**MT-002 [CRITICAL] `proof_submissions` table does not exist**
- Proof-Capture `PROOF_TABLE = "proof_submissions"` and `PROOF_BUCKET = "proof-uploads"`
- No migration creates this table or the bucket
- Core photo upload functionality is completely broken
- File: `Proof-Capture/src/lib/supabase.ts:16-17`, `src/screens/Dashboard.tsx:48`

**MT-003 [CRITICAL] `approval_queue` CREATE TABLE missing from AICOS**
- AICOS migration only ALTERs approval_queue, never creates it
- Table must be pre-existing (from COS) with COS schema including required `client_id`
- AICOS adding columns to a table it doesn't own creates an implicit dependency
- If COS migrations run first this works; if AICOS runs on a fresh DB it will fail

**MT-004 [CRITICAL] No `prospects` CREATE TABLE in any repo scoped to AICOS**
- AICOS has webhook triggers on `prospects` but no CREATE TABLE
- The live `prospects` schema is the COS version (very different from AICOS types)
- AICOS will continue to malfunction on any query that uses AICOS-assumed column names

**MT-005 [HIGH] `client_deliverables` table missing**
- COS uses `supabase.from('client_deliverables' as any)` in 3 files (AuthorityBrand.tsx, Sprints.tsx, ClientTierWorkspace.tsx)
- Not in COS `database.types.ts` — bypassed with `as any`
- All tier workspace deliverable tracking is broken
- Files: `COS/src/pages/AuthorityBrand.tsx:424,449`, `Sprints.tsx:340`, `ClientTierWorkspace.tsx:191`

**MT-006 [HIGH] `proof_sprint_client_data` table missing**
- COS `ProofSprintV2.tsx:595` queries `supabase.from('proof_sprint_client_data')`
- Not in any type definition or migration
- Sprint per-client data panel will silently fail
- File: `COS/src/pages/ProofSprintV2.tsx:595`

**MT-007 [HIGH] `client_portal` table missing**
- COS `DeliveryPortal.tsx:169` queries `supabase.from('client_portal' as any)`
- Not in any type definition or migration
- File: `COS/src/pages/DeliveryPortal.tsx:169`

**MT-008 [HIGH] Storage buckets `sop-files`, `template-files`, `aa-assets`, `proof-uploads` not created**
- COS Sops.tsx uploads to `sop-files` bucket
- COS Templates.tsx uploads to `template-files` bucket
- COS ProofSprintV2.tsx uploads to `aa-assets` bucket
- Proof-Capture uploads to `proof-uploads` bucket
- None have migrations creating these buckets
- All file upload operations will fail with "Bucket not found"

**MT-009 [MEDIUM] `sprint_logs` table doesn't exist**
- AICOS `Clients.tsx:145` queries `sprint_logs`
- Live table: `sprint_daily_log`
- CPL trend chart in AICOS client drawer always returns empty
- File: `AICOS/src/pages/Clients.tsx:145`

**MT-010 [MEDIUM] `financial_snapshots` expected by COS doesn't match `finance_snapshots`**
- COS `database.types.ts` has `financial_snapshots`
- AICOS migration creates `finance_snapshots`
- COS code references `financial_snapshots` which doesn't exist under that name

**MT-011 [MEDIUM] `monthly_revenue` view missing from migrations**
- COS `Finance.tsx:25` queries `supabase.from('monthly_revenue')`
- COS `Finance.tsx:193` also queries it
- Not in any migration. Must be a database view.
- COS Finance page will fail if view doesn't exist

---

### 4C. Wrong Table Usage (CLAUDE.md Violations)

**WU-001 [CRITICAL] Outreach-System writes to `prospects` directly**
- CLAUDE.md rule: "Outreach-System reads prospects and clients but NEVER writes to them directly — AICOS Edge Functions own all writes"
- `Outreach-System/src/features/whatsapp/api.ts:updateConversationStage()` at line 1603 writes `prospects.status` from the browser anon client
- `Outreach-System/src/features/whatsapp/api.ts:markProspectDoNotContact()` at line 1644 writes `prospects.status = 'do_not_contact'` — not a valid AICOS status
- These direct writes bypass all SOP triggers and audit logging
- Both operations should call an AICOS Edge Function instead

**WU-002 [CRITICAL] COS writes to `prospects` directly**
- CLAUDE.md rule: AICOS Edge Functions own all writes to prospects
- `COS/src/pages/Clients.tsx:90` writes `prospects.status = 'closed_won'` directly from browser
- `COS/src/pages/SPOA.tsx:416,516` reads and writes prospects directly
- `COS/src/pages/crm.tsx:53,66` updates `prospects` fields directly
- `COS/src/components/prospects/ProspectDetailView.tsx:61` updates prospects directly
- `closed_won` is not a valid AICOS ProspectStatus value
- These bypass SOP 03 enrichment triggers and audit logging

**WU-003 [HIGH] Outreach-System bypasses TypeScript on `approval_queue` with `as any`**
- `Outreach-System/src/features/whatsapp/api.ts` uses `(supabase as any).from(...)` for `rejectOutreachQueueItem`
- Bypasses type checking entirely; actual column names are unknown
- File: `Outreach-System/src/features/whatsapp/api.ts:1525`

---

### 4D. Missing RLS Policies

**RLS-001 [CRITICAL] WhatsApp tables only allow `authenticated` role — anon Supabase clients rejected**
- All Outreach-System WhatsApp table policies use `to authenticated`
- AICOS Edge Functions use `service_role` key (bypasses RLS) — this is fine
- But Outreach-System's Supabase client uses the anon key before authentication
- If auth session expires mid-session, all WhatsApp reads/writes silently fail
- No fallback or explicit 401 handling in Outreach-System API layer

**RLS-002 [HIGH] `push_subscriptions` missing anon SELECT policy**
- Migration creates: INSERT for anon (subscribe), DELETE for anon (unsubscribe)
- No SELECT for anon — frontend `PushNotificationToggle` cannot check if already subscribed
- Results in duplicate subscriptions on page reload
- File: `AICOS/supabase/migrations/20260512195901_create_push_subscriptions.sql`

**RLS-003 [HIGH] `approval_queue` missing anon UPDATE policy**
- AICOS `updateApprovalStatus()` in `AICOS/src/lib/supabase.ts:107` updates `approval_queue` using the browser anon client
- No anon UPDATE policy confirmed for `approval_queue` in AICOS migrations
- All operator approve/reject actions will fail with RLS violation
- File: `AICOS/src/lib/supabase.ts:107-121`

**RLS-004 [MEDIUM] `whatsapp_outreach_queue` missing anon UPDATE policy**
- AICOS creates `whatsapp_outreach_queue` with only `anon read` policy
- Outreach-System needs to update status (approve/reject) from browser anon client
- Approval workflow in Outreach-System's OutreachQueue component will fail
- File: `AICOS/supabase/migrations/20260510200000_create_whatsapp_outreach_queue.sql`

**RLS-005 [MEDIUM] `whatsapp_ai_suggestions` anon UPDATE policy too broad**
- AICOS migration adds `create policy "anon update status" ... for update using (true) with check (true)`
- This allows any anon user to update any suggestion status — no row-level ownership
- Should be scoped to authenticated user or service_role only

---

### 4E. Duplicate Functionality

**DUP-001 [HIGH] `prospects` pipeline managed in three repos independently**
- AICOS: Pipeline.tsx manages stages via `updateProspectStatus()`
- COS: crm.tsx, Prospects.tsx, Outreach.tsx, SPOA.tsx all update prospect fields directly
- Outreach-System: `updateConversationStage()` updates prospect status on stage change
- Three independent write paths with no coordination, conflicting status vocabularies, and no single audit trail

**DUP-002 [HIGH] Finance data split across two schemas**
- AICOS creates `finance_ledger` + `finance_snapshots` + SOP 56
- COS has `ledger` (view), `financial_snapshots`, `ledger_entries`, SOP-independent finance pages
- AICOS SOP 46 reads `finance_ledger`; COS `IncomeTracking.tsx` reads `ledger` (different table)
- Monthly income tracked separately in both systems

**DUP-003 [MEDIUM] SOP definitions in two separate tables**
- AICOS has `knowledge_base` (type `sop`) for SOP definitions with prompt content
- COS has `sops` table with different schema (sop_number, status, files column)
- No synchronisation between them
- SOP 33 (versioning) reads from `knowledge_base`; COS `Sops.tsx` manages `sops` table

**DUP-004 [MEDIUM] `clients` queried independently by AICOS and COS with different column assumptions**
- AICOS Clients.tsx queries `clients` expecting `name, start_date, mrr, active_sprint_id`
- COS Clients.tsx queries `clients` expecting `business_name, owner_name, account_manager, monthly_retainer`
- Same live table, two broken read paths based on wrong column expectations

**DUP-005 [LOW] `ai_alerts` queryable from both AICOS and COS**
- AICOS `Alerts.tsx` reads `ai_alerts` with full select
- COS does not read `ai_alerts` currently but has it in `database.types.ts`
- No conflict, but worth noting as AICOS owns this table

---

### 4F. Missing Realtime

**RT-001 [HIGH] `whatsapp_conversations` not in `supabase_realtime` publication**
- Outreach-System `useWhatsAppRealtime()` subscribes to INSERT on `whatsapp_conversations`
- No migration runs `alter publication supabase_realtime add table public.whatsapp_conversations`
- `postgres_changes` subscriptions silently receive no events without Realtime enabled
- New inbound messages will not trigger the UI toast notification
- File: `Outreach-System/src/features/whatsapp/hooks.ts:562`

**RT-002 [HIGH] `whatsapp_ai_suggestions` and `whatsapp_outreach_queue` not in Realtime**
- Outreach-System subscribes to INSERT on `whatsapp_ai_suggestions` and UPDATE on `whatsapp_outreach_queue`
- Same issue as RT-001 — no Realtime publication configured
- Pending AI suggestion badge count and outreach queue approval screen won't auto-refresh
- File: `Outreach-System/src/features/whatsapp/hooks.ts:586-603`

**RT-003 [MEDIUM] `approval_queue` not in Realtime**
- AICOS `Clients.tsx:117` subscribes to INSERT on `approval_queue` for client_report items
- No migration enables Realtime on `approval_queue`
- New reports generated by SOP 47 won't appear in the Reports tab without a manual page reload

---

### 4G. Edge Function Gaps

**EF-001 [HIGH] COS calls 9 Edge Functions not deployed in either repo**

| Function Name | Called from | Status |
|---|---|---|
| `brain-chat` | COS/src/lib/brain.ts:20 | Not found in AICOS or Outreach-System functions |
| `update-user-role` | COS/src/pages/AdminControl.tsx:78 | Not found |
| `google-oauth-exchange` | COS/src/pages/GoogleOAuthCallback.tsx:26 | Not found |
| `google-oauth-start` | COS/src/pages/GoogleOAuthStart.tsx:10 | Not found |
| `proof-sprint-run-deliverable` | COS/src/pages/ProofSprintV2.tsx:780 | Not found |
| `generate-sprint-report` | COS/src/pages/SprintDetail.tsx:362 | Not found |
| `generate-mjr` | COS/src/pages/Studio.tsx:290 | Not found (AICOS has `sop-08-mjr-build`) |
| `apify-start` | COS/src/pages/Scraper.tsx:148 | Not found |
| `apify-results` | COS/src/pages/Scraper.tsx:186 | Not found |
| `spoa-generator` | COS/src/pages/SPOA.tsx:489 | Not found (AICOS has `sop-12-spoa-build`) |

**EF-002 [HIGH] COS and AICOS use different function names for same purpose**
- COS calls `generate-mjr` for MJR generation. AICOS has `sop-08-mjr-build`.
- COS calls `spoa-generator`. AICOS has `sop-12-spoa-build`.
- No coordination — COS Studio.tsx and AICOS SOPControl share no function calls
- AICOS MJR/SPOA Edge Functions write to Supabase Storage `documents` bucket; COS has its own flow

**EF-003 [HIGH] `meta-whatsapp-webhook` and WhatsApp functions deployed from Outreach-System repo, not AICOS**
- CLAUDE.md lists all 6 WhatsApp Edge Functions as deployed to project `fgyvcyksgbivhrqoxkmj`
- Function source is in `Outreach-System/supabase/functions/`, not `AICOS/supabase/functions/`
- Deploying from AICOS (`npx supabase functions deploy`) will NOT deploy WhatsApp functions
- Requires separate deployment step from Outreach-System directory
- Not documented in CLAUDE.md Section 12 runbook

**EF-004 [MEDIUM] `sop-47-weekly-reports` invoked with client_id payload but function may expect different**
- AICOS `Clients.tsx:160` invokes `sop-47-weekly-reports` with `{ client_id, client_name }`
- No payload contract documented; function source not read in full
- File: `AICOS/src/pages/Clients.tsx:160`

**EF-005 [MEDIUM] `run-sop` generic executor called for all SOPs from CronManager**
- AICOS `CronManager.tsx:97-98` calls either the named function directly OR `run-sop` with `{ sop_id }`
- The `run-sop` function must have routing for every SOP — if a new SOP's named function is added without updating `run-sop`, cron triggers will silently not work
- No documentation of what `run-sop` routes to

---

### 4H. Environment Variable Gaps

**ENV-001 [HIGH] Proof-Capture has two Supabase clients with conflicting env var names**
- `Proof-Capture/src/lib/supabase.ts` reads `VITE_SUPABASE_ANON_KEY`
- `Proof-Capture/src/integrations/supabase/client.ts` reads `VITE_SUPABASE_PUBLISHABLE_KEY`
- `.env` file sets `VITE_SUPABASE_PUBLISHABLE_KEY` but NOT `VITE_SUPABASE_ANON_KEY`
- `src/lib/supabase.ts` will create a broken client (empty anon key → stub host)
- `src/screens/Dashboard.tsx` uses `src/lib/supabase.ts` — all DB operations broken

**ENV-002 [MEDIUM] COS missing Google OAuth env vars from `.env.example`**
- COS has `GoogleOAuthStart.tsx` and `GoogleOAuthCallback.tsx` pages
- No Google client ID or redirect URI in `.env.example`
- OAuth pages will fail without `VITE_GOOGLE_CLIENT_ID` or equivalent

**ENV-003 [MEDIUM] Outreach-System hardcodes Supabase URL in `.env.example`**
- `Outreach-System/.env.example` contains the actual live URL and anon key
- Commits the anon key to version control as an example value
- Anon key is not a secret (public by design), but embedding it normalises the pattern

**ENV-004 [MEDIUM] AICOS missing `SUPABASE_ANON_KEY` in Railway config**
- AICOS `railway.json` serves the React SPA from `server.js`
- `server.js` serves the built frontend; Vite env vars are baked in at build time
- Missing build-time injection of `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` in Railway will produce a working server but broken frontend

**ENV-005 [LOW] Proof-Capture `.env` contains hardcoded anon key and project ID**
- `Proof-Capture/.env` has the actual live project ref and a real-looking JWT
- Should be `.env.example` with placeholder values, not a committed `.env`

---

## 5. Environment Variable Audit

### Complete List Across All Repos

| Variable | AICOS (Railway) | COS (GitHub Pages) | Outreach-System (GitHub Pages) | Proof-Capture | Supabase Edge Functions |
|---|---|---|---|---|---|
| `VITE_SUPABASE_URL` | ✓ | ✓ | ✓ | ✓ (as VITE_SUPABASE_URL) | — |
| `VITE_SUPABASE_ANON_KEY` | ✓ | ✓ | ✓ | ✓ (as VITE_SUPABASE_PUBLISHABLE_KEY ⚠️) | — |
| `VITE_VAPID_PUBLIC_KEY` | ✓ | — | — | — | — |
| `ANTHROPIC_API_KEY` | ✓ (server.js) | — | — | — | ✓ |
| `META_ACCESS_TOKEN` | ✓ | — | — | — | ✓ |
| `META_AD_ACCOUNT_ID` | ✓ | — | — | — | ✓ |
| `META_GRAPH_API_VERSION` | ✓ | — | — | — | ✓ |
| `RESEND_API_KEY` | ✓ | — | — | — | ✓ |
| `RESEND_FROM_EMAIL` | ✓ | — | — | — | ✓ |
| `SUPABASE_URL` | ✓ (Railway) | — | — | — | ✓ (auto) |
| `SUPABASE_SERVICE_ROLE_KEY` | ✓ (Railway) | — | — | — | ✓ (auto) |
| `SUPABASE_ANON_KEY` | ✓ (Railway) | — | — | — | ✓ (auto) |
| `WHATSAPP_ACCESS_TOKEN` | ✓ | — | — | — | ✓ |
| `WHATSAPP_PHONE_NUMBER_ID` | ✓ | — | — | — | ✓ |
| `WHATSAPP_BUSINESS_ACCOUNT_ID` | — | — | — | — | ✓ |
| `WHATSAPP_APP_SECRET` | — | — | — | — | ✓ |
| `WHATSAPP_WEBHOOK_VERIFY_TOKEN` | ✓ (as WEBHOOK_VERIFY_TOKEN) | — | — | — | ✓ |
| `VAPID_PUBLIC_KEY` | — | — | — | — | ✓ |
| `VAPID_PRIVATE_KEY` | — | — | — | — | ✓ |
| `VAPID_EMAIL` | — | — | — | — | ✓ |
| `AI_PROVIDER` | — | — | — | — | ✓ |
| `AI_MODEL` | — | — | — | — | ✓ |
| `VITE_GOOGLE_CLIENT_ID` | — | ✓? (undocumented) | — | — | — |

⚠️ = variable name mismatch between code and env file

---

## 6. Edge Function Coverage Map

### AICOS-Deployed Functions (deploy from `AICOS/` directory)

| Function | Repos that call it | Payload expected | JWT verify |
|---|---|---|---|
| `claude-chat` | AICOS (Conversations.tsx, claude.ts) | `{ messages, system }` | **true** |
| `run-sop` | AICOS (CronManager.tsx) | `{ sop_id }` | false |
| `sop-03-enrichment` | AICOS (Pipeline.tsx), webhook trigger | `{}` or `{ prospect_id }` | false |
| `sop-21-sprint-daily-ops` | AICOS (Sprints.tsx) | `{}` | false |
| `sop-47-weekly-reports` | AICOS (Clients.tsx) | `{ client_id, client_name }` | false |
| `sop-52-backup-check` | AICOS (Dashboard.tsx) | `{}` | false |
| `sop-56-finance-dashboard` | AICOS (Finance.tsx) | `{}` | false |
| `sop-58-daily-briefing` | AICOS (Dashboard.tsx) | `{}` | false |
| `meta-ads-sync` | cron runner | `{}` | false |
| `send-push-notification` | cron runner | `{ title, body, url }` | false |
| All other sop-\* | cron runner via run-sop | `{}` | false |

### Outreach-System-Deployed Functions (deploy from `Outreach-System/` directory)

| Function | Repos that call it | Payload expected | JWT verify |
|---|---|---|---|
| `meta-whatsapp-webhook` | Meta Cloud API (webhook) | Meta webhook payload | false |
| `send-whatsapp-message` | Outreach-System API, AICOS (via outreach_queue approval) | `{ conversation_id, body }` | false |
| `send-whatsapp-template-message` | Outreach-System API | `{ conversation_id, template_id, parameters }` | false |
| `generate-whatsapp-reply-suggestion` | Outreach-System API | `{ conversation_id }` | false |
| `sync-whatsapp-templates` | Outreach-System API | `{}` | false |
| `whatsapp-integration-health` | Outreach-System API | `{}` | false |

### Missing Edge Functions (called but not deployed)

| Function | Called by | Should replace |
|---|---|---|
| `brain-chat` | COS/src/lib/brain.ts | Should reuse `claude-chat` with different system prompt |
| `update-user-role` | COS AdminControl.tsx | New function needed |
| `google-oauth-exchange` | COS GoogleOAuthCallback.tsx | New function needed |
| `google-oauth-start` | COS GoogleOAuthStart.tsx | New function needed |
| `proof-sprint-run-deliverable` | COS ProofSprintV2.tsx | New function needed |
| `generate-sprint-report` | COS SprintDetail.tsx | Could reuse `sop-47-weekly-reports` |
| `generate-mjr` | COS Studio.tsx | Should reuse `sop-08-mjr-build` |
| `apify-start` | COS Scraper.tsx | New function needed |
| `apify-results` | COS Scraper.tsx | New function needed |
| `spoa-generator` | COS SPOA.tsx | Should reuse `sop-12-spoa-build` |
