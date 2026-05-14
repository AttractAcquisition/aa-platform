# Attract Acquisition Platform — Optimisation & Fix Plan

**Generated:** 2026-05-14  
**Companion to:** `docs/PLATFORM_AUDIT.md`  
**Purpose:** Ordered execution plan for all 56 identified issues. Fixes are grouped into phases with dependencies noted. Each item is self-contained — no re-analysis required.

---

## 1. Priority Fix List

### CRITICAL (must fix before any production use)

| # | Category | Description | Repos affected | Effort |
|---|---|---|---|---|
| C-01 | Schema | `whatsapp_conversations` phone column: live is `phone_number`, AICOS assumes `phone` | AICOS SOPs | Small |
| C-02 | Schema | `whatsapp_messages` body column: live is `body`, AICOS assumes `message_body` | AICOS SOPs | Small |
| C-03 | Schema | `whatsapp_conversations` stage constraint conflict — AICOS and Outreach-System use different vocabularies | AICOS, Outreach-System | Medium |
| C-04 | Schema | `clients` column name — AICOS assumes `name`, live is `business_name` | AICOS | Small |
| C-05 | Schema | `prospects` column names — AICOS assumes `name`/`company`/`quality_score`, live is `owner_name`/`business_name`/`icp_total_score` | AICOS | Small |
| C-06 | Schema | `sprints` table doesn't exist — AICOS must query `proof_sprints` | AICOS | Small |
| C-07 | Schema | `whatsapp_messages` missing `conversation_id` FK in AICOS migrations — AICOS SOP inserts will fail | AICOS SOPs | Small |
| C-08 | Missing table | `proof_submissions` table and `proof-uploads` bucket don't exist — Proof-Capture entirely broken | Proof-Capture | Small |
| C-09 | Schema | `approval_queue.client_id` is NOT NULL — AICOS `createApprovalItem` never sets it, all SOP approvals fail | AICOS | Small |
| C-10 | Wrong usage | Outreach-System writes to `prospects` directly via browser client — violates ownership rules | Outreach-System | Medium |
| C-11 | Wrong usage | COS writes to `prospects` directly — violates ownership rules | COS | Medium |
| C-12 | RLS | `approval_queue` missing anon UPDATE policy — operator approve/reject actions fail | AICOS | Small |
| C-13 | Edge Function | COS calls 9 Edge Functions that don't exist — AI-driven features in COS are all broken | COS | Large |
| C-14 | Env vars | Proof-Capture: `VITE_SUPABASE_ANON_KEY` not set in `.env`, code reads from wrong variable | Proof-Capture | Small |

### HIGH (fix before next feature sprint)

| # | Category | Description | Repos affected | Effort |
|---|---|---|---|---|
| H-01 | Missing table | `client_deliverables` table missing — tier workspace deliverable tracking broken | COS | Medium |
| H-02 | Missing table | Storage buckets `sop-files`, `template-files`, `aa-assets`, `proof-uploads` not created | COS, Proof-Capture | Small |
| H-03 | Schema | `sprint_logs` doesn't exist — use `sprint_daily_log` | AICOS | Small |
| H-04 | Schema | `finance_snapshots` vs `financial_snapshots` name mismatch | COS | Small |
| H-05 | RLS | WhatsApp tables: `whatsapp_conversations`, `whatsapp_messages`, `whatsapp_ai_suggestions` need `service_role` policy for AICOS Edge Functions | Outreach-System | Small |
| H-06 | Realtime | Enable Realtime on `whatsapp_conversations`, `whatsapp_ai_suggestions`, `whatsapp_outreach_queue` | Outreach-System | Small |
| H-07 | Realtime | Enable Realtime on `approval_queue` | AICOS | Small |
| H-08 | Schema | `whatsapp_outreach_queue` columns mismatch with Outreach-System expectations | AICOS, Outreach-System | Medium |
| H-09 | EF | Document and update CLAUDE.md: WhatsApp functions deploy from Outreach-System, not AICOS | All | Small |
| H-10 | Schema | `clients` status constraint: add `paused` and `onboarding` to the check | AICOS | Small |

### MEDIUM (fix within 2 weeks)

| # | Category | Description | Repos affected | Effort |
|---|---|---|---|---|
| M-01 | Missing table | `proof_sprint_client_data` and `client_portal` tables needed by COS | COS | Medium |
| M-02 | Missing table | `monthly_revenue` view missing | COS | Small |
| M-03 | Schema | `prospects.status` values inconsistent across repos — define canonical set | All | Medium |
| M-04 | Duplicate | Consolidate `sops` table (COS) vs `knowledge_base` (AICOS) | All | Large |
| M-05 | Realtime | AICOS Pipeline.tsx polls every 2 min — convert to Realtime subscription | AICOS | Small |
| M-06 | RLS | `push_subscriptions` anon SELECT missing | AICOS | Small |
| M-07 | RLS | `whatsapp_ai_suggestions` anon UPDATE policy too broad | AICOS | Small |
| M-08 | N+1 | `fetchPipelineCounts()` runs N separate COUNT queries — replace with single RPC | AICOS | Small |
| M-09 | Schema | `clients` schema in AICOS types completely wrong — update TypeScript interfaces | AICOS | Small |
| M-10 | EF | COS `generate-mjr` should call `sop-08-mjr-build`; `spoa-generator` should call `sop-12-spoa-build` | COS | Small |

### LOW (backlog)

| # | Category | Description | Repos affected | Effort |
|---|---|---|---|---|
| L-01 | Schema | `push_subscriptions` migration missing `public.` schema prefix | AICOS | Small |
| L-02 | Env | COS missing Google OAuth env vars in `.env.example` | COS | Small |
| L-03 | Security | Proof-Capture `.env` contains real JWT — move to `.env.example` with placeholders | Proof-Capture | Small |

---

## 2. Schema Changes Required

### 2A. Migrate AICOS to use live column names

These are code changes in AICOS only — do NOT change the database schema (it's already correct from COS/Outreach-System).

**`prospects` column renames in AICOS code:**
```sql
-- No SQL needed. AICOS code must be updated:
-- name       → owner_name
-- company    → business_name  
-- quality_score → icp_total_score
-- enrichment_data (jsonb) → individual columns already exist in live schema
-- reply_classification → not in live schema; add as migration below
```

If `reply_classification` is genuinely needed in AICOS SOP 06, add it:
```sql
-- Run from AICOS migrations
alter table public.prospects
  add column if not exists reply_classification text,
  add column if not exists last_reply_at timestamptz;
```

**`clients` additions required for AICOS to function:**
```sql
-- Columns AICOS code expects that aren't in live COS schema
-- mrr → use monthly_retainer (already exists in COS)
-- start_date → use contract_start_date (already exists in COS)
-- active_sprint_id → this needs a new column or FK
alter table public.clients
  add column if not exists active_sprint_id uuid references public.proof_sprints(id) on delete set null;

-- Update clients status check to include all AICOS values
alter table public.clients drop constraint if exists clients_status_check;
alter table public.clients 
  add constraint clients_status_check 
  check (status in ('active', 'inactive', 'churned', 'paused', 'onboarding'));
```

### 2B. Resolve `whatsapp_conversations` stage conflict

The live table uses Outreach-System stage values. AICOS SOPs must be updated to use them:

```sql
-- The live constraint is: new, needs_reply, qualified, quoted, booked, won, lost, bad_fit
-- AICOS's attempted ALTER (20260510100000) conflicts with this and must NOT be applied
-- If it was already applied, run this to reconcile:
alter table public.whatsapp_conversations 
  drop constraint if exists whatsapp_conversations_stage_check;

alter table public.whatsapp_conversations
  add constraint whatsapp_conversations_stage_check
  check (stage in ('new', 'needs_reply', 'qualified', 'quoted', 'booked', 'won', 'lost', 'bad_fit'));

-- AICOS SOP code must map its stage values to these:
-- contacted  → new (or needs_reply if replied)
-- replied    → needs_reply
-- warm       → qualified  
-- call_booked → booked
-- closed     → won or lost
```

### 2C. Create missing tables

**`proof_submissions` (Proof-Capture):**
```sql
create table if not exists public.proof_submissions (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users(id) on delete cascade,
  proof_type   text not null check (proof_type in ('before', 'during', 'after')),
  public_url   text not null,
  storage_path text not null,
  notes        text,
  created_at   timestamptz not null default now()
);

alter table public.proof_submissions enable row level security;

create policy "users can read own submissions" on public.proof_submissions
  for select using (auth.uid() = user_id);

create policy "users can insert own submissions" on public.proof_submissions
  for insert with check (auth.uid() = user_id);

create index if not exists proof_submissions_user_id_idx 
  on public.proof_submissions (user_id, created_at desc);
```

**`client_deliverables` (COS):**
```sql
create table if not exists public.client_deliverables (
  id          uuid primary key default gen_random_uuid(),
  client_id   uuid not null references public.clients(id) on delete cascade,
  title       text not null,
  type        text not null,
  status      text not null default 'pending' 
              check (status in ('pending', 'in_progress', 'complete', 'cancelled')),
  due_date    date,
  notes       text,
  tier        text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

alter table public.client_deliverables enable row level security;

create policy "authenticated read" on public.client_deliverables
  for select to authenticated using (true);

create policy "authenticated write" on public.client_deliverables
  for all to authenticated using (true) with check (true);

create index if not exists client_deliverables_client_id_idx 
  on public.client_deliverables (client_id);
```

**`proof_sprint_client_data` (COS):**
```sql
create table if not exists public.proof_sprint_client_data (
  id         uuid primary key default gen_random_uuid(),
  client_id  uuid not null references public.clients(id) on delete cascade,
  sprint_id  uuid references public.proof_sprints(id) on delete set null,
  data       jsonb not null default '{}',
  updated_at timestamptz not null default now(),
  unique (client_id)
);

alter table public.proof_sprint_client_data enable row level security;

create policy "authenticated read" on public.proof_sprint_client_data
  for select to authenticated using (true);

create policy "authenticated write" on public.proof_sprint_client_data
  for all to authenticated using (true) with check (true);
```

**`monthly_revenue` view (COS):**
```sql
-- Aggregate view of finance_ledger by month
create or replace view public.monthly_revenue as
select
  date_trunc('month', invoice_date)::date as month,
  sum(case when entry_type = 'income' then amount else 0 end)  as income,
  sum(case when entry_type = 'expense' then amount else 0 end) as expense,
  sum(case when entry_type = 'income' then amount else 0 end)
    - sum(case when entry_type = 'expense' then amount else 0 end) as net
from public.finance_ledger
where status != 'cancelled'
group by 1
order by 1 desc;
```

### 2D. Storage buckets

```sql
-- sop-files bucket for COS SOP attachments
insert into storage.buckets (id, name, public, file_size_limit)
values ('sop-files', 'sop-files', false, 52428800)
on conflict (id) do nothing;

-- template-files bucket
insert into storage.buckets (id, name, public, file_size_limit)
values ('template-files', 'template-files', false, 52428800)
on conflict (id) do nothing;

-- aa-assets bucket
insert into storage.buckets (id, name, public, file_size_limit)
values ('aa-assets', 'aa-assets', true, 52428800)
on conflict (id) do nothing;

-- proof-uploads bucket
insert into storage.buckets (id, name, public, file_size_limit)
values ('proof-uploads', 'proof-uploads', false, 52428800)
on conflict (id) do nothing;

-- Policies for sop-files, template-files (authenticated read/write)
create policy "authenticated access sop-files"
  on storage.objects for all
  using (bucket_id = 'sop-files' and auth.role() = 'authenticated');

create policy "authenticated access template-files"
  on storage.objects for all
  using (bucket_id = 'template-files' and auth.role() = 'authenticated');

-- aa-assets: public read, authenticated write
create policy "public read aa-assets"
  on storage.objects for select
  using (bucket_id = 'aa-assets');

create policy "authenticated write aa-assets"
  on storage.objects for insert
  using (bucket_id = 'aa-assets' and auth.role() = 'authenticated');

-- proof-uploads: owner-only
create policy "owner access proof-uploads"
  on storage.objects for all
  using (bucket_id = 'proof-uploads' and auth.uid()::text = (storage.foldername(name))[1]);
```

### 2E. Add missing indexes

```sql
-- prospects: high-frequency filter columns
create index if not exists prospects_status_idx        on public.prospects (status);
create index if not exists prospects_pipeline_stage_idx on public.prospects (pipeline_stage);
create index if not exists prospects_assigned_to_idx   on public.prospects (assigned_to);
create index if not exists prospects_vertical_idx      on public.prospects (vertical);
create index if not exists prospects_icp_total_score_idx on public.prospects (icp_total_score desc);

-- approval_queue: JSONB path filter used by AICOS Clients.tsx
create index if not exists approval_queue_content_client_id_idx
  on public.approval_queue ((content->'metadata'->>'client_id'));

-- clients: common filters
create index if not exists clients_account_manager_idx on public.clients (account_manager);
create index if not exists clients_tier_idx            on public.clients (tier);
create index if not exists clients_status_idx          on public.clients (status);

-- whatsapp_conversations: analytics filters
create index if not exists whatsapp_conversations_client_id_idx
  on public.whatsapp_conversations (client_id);
```

---

## 3. Code Changes Required

### 3A. AICOS — Fix column names throughout

**File: `AICOS/src/types/index.ts`**
Update the `Prospect` interface to match live schema:
```typescript
// Replace
export interface Prospect {
  id: string
  name: string           // → remove
  company: string        // → remove
  phone: string
  status: ProspectStatus
  quality_score: number  // → remove
  // ...
  enrichment_data?: { ... }  // → remove (individual columns exist)
}

// With
export interface Prospect {
  id: string
  business_name: string
  owner_name: string | null
  phone: string | null
  whatsapp: string | null
  status: string | null
  pipeline_stage: string | null
  icp_total_score: number | null
  icp_tier: string | null
  vertical: string | null
  city: string | null
  suburb: string | null
  source_list: string | null
  reply_classification: string | null
  last_reply_at: string | null
  created_at: string
  is_archived: boolean | null
}
```

Update the `Client` interface:
```typescript
export interface Client {
  id: string
  business_name: string
  owner_name: string
  tier: 'Proof Sprint' | 'Proof Brand' | 'Authority Brand' | null
  status: 'active' | 'inactive' | 'churned' | 'paused' | 'onboarding' | null
  monthly_retainer: number | null
  contract_start_date: string | null
  account_manager: string | null
  niche: string | null
  active_sprint_id: string | null
  notes: string | null
  email: string | null
  phone: string | null
  whatsapp: string | null
}
```

Update the `Sprint` interface to match `proof_sprints`:
```typescript
export interface Sprint {
  id: string
  client_id: string | null
  client_name: string | null
  sprint_number: number | null
  status: string | null
  start_date: string
  leads_generated: number | null
  actual_ad_spend: number | null
  client_ad_budget: number | null
  revenue_attributed: number | null
  bookings_from_sprint: number | null
  results_meeting_outcome: string | null
  vertical: string | null
}
```

**File: `AICOS/src/pages/Pipeline.tsx`**
```typescript
// Line ~200: replace select clause
.select('id, owner_name, business_name, phone, status, pipeline_stage, icp_total_score, created_at, last_reply_at, reply_classification, source_list')

// Replace all references:
prospect.name    → prospect.owner_name ?? prospect.business_name
prospect.company → prospect.business_name
prospect.quality_score → prospect.icp_total_score
```

**File: `AICOS/src/pages/Clients.tsx`**
```typescript
// Line 71: fix ordering
supabase.from('clients').select('*').order('contract_start_date', { ascending: false })

// Line 72: fix table name
supabase.from('proof_sprints').select('*').eq('status', 'active')

// Line 145: fix table name
supabase.from('sprint_daily_log')
  .select('log_date, spend, leads, id')  // adjust columns to sprint_daily_log schema
  .eq('sprint_id', sprint.id)
  .order('log_date', { ascending: true })
  .limit(14)

// Client display: replace name/company references
client.name    → client.business_name
client.company → client.owner_name
client.mrr     → client.monthly_retainer
client.start_date → client.contract_start_date
```

**File: `AICOS/src/pages/Dashboard.tsx`**
```typescript
// Fix prospects queries (lines 45-50) — counts are fine (counting by status)
// Fix sprints table name (line 53)
supabase.from('proof_sprints').select('*', { count: 'exact', head: true }).eq('status', 'active')
```

**File: `AICOS/src/pages/Sprints.tsx`**
```typescript
// Line 31: fix table name  
supabase.from('proof_sprints').select('*').eq('status', 'active').order('start_date', { ascending: false })
// Map sprint_number as day_number where needed
```

**File: `AICOS/src/lib/supabase.ts` — Fix `createApprovalItem`**
```typescript
// Line 73-90: add client_id to insert
// The approval_queue requires client_id NOT NULL
// Options:
// 1. Make client_id optional in the function and default to a system client UUID
// 2. Add client_id to CreateApprovalItemInput and pass from callers

export interface CreateApprovalItemInput {
  sop_id: string
  sop_name: string
  type: ApprovalType
  priority: 'high' | 'medium' | 'low'
  client_id: string  // ADD THIS
  content: { ... }
}

// In the insert:
const { data, error } = await supabase
  .from('approval_queue')
  .insert({
    sop_id: input.sop_id,
    sop_name: input.sop_name,
    client_id: input.client_id,  // ADD THIS
    status: 'pending',
    priority: input.priority,
    content: input.content,
    content_type: input.type,
    content_id: crypto.randomUUID(),
  })
```

### 3B. AICOS — Fix `updateProspectStatus` to use correct status values

**File: `AICOS/src/lib/supabase.ts`**
The `ProspectStatus` type and the statuses written to the DB are inconsistent. Align them with the canonical set and add a status → pipeline_stage sync:
```typescript
// updateProspectStatus should also update pipeline_stage to keep COS in sync
export async function updateProspectStatus(
  id: string,
  status: ProspectStatus,
  replyClassification?: string,
): Promise<Prospect> {
  const patch: Record<string, unknown> = { 
    status,
    pipeline_stage: status  // keep pipeline_stage in sync
  }
  if (replyClassification !== undefined) patch.reply_classification = replyClassification
  // ... rest unchanged
}
```

### 3C. Outreach-System — Remove direct prospect writes

**File: `Outreach-System/src/features/whatsapp/api.ts`**

`updateConversationStage` (lines 1586-1614): Remove direct prospect write. Call an Edge Function instead:
```typescript
export async function updateConversationStage(conversationId: string, stage: CrmStage) {
  const dbStage = fromCrmStage(stage);

  // Update conversation stage only
  const { error } = await supabase
    .from("whatsapp_conversations")
    .update({ stage: dbStage })
    .eq("id", conversationId);

  if (error) throw new Error(error.message);

  // Delegate prospect status update to AICOS Edge Function via sop-06-reply-triage
  // or create a dedicated 'update-prospect-status' Edge Function in AICOS
  await supabase.functions.invoke('update-prospect-from-conversation', {
    body: { conversation_id: conversationId, stage: dbStage }
  });
}
```

`markProspectDoNotContact` (lines 1616-1659): Remove direct prospect write:
```typescript
// Remove these lines (1644-1650):
// const { error: prospectError } = await supabase
//   .from("prospects")
//   .update({ status: "do_not_contact" })
//   .eq("id", prospectId);

// Replace with Edge Function call or trigger from suppression list insert
// (add a trigger on whatsapp_suppression_list to update prospect status via service role)
```

### 3D. COS — Remove direct prospect writes

**File: `COS/src/pages/Clients.tsx:90`**
```typescript
// Remove:
await supabase.from('prospects').update({ status: 'closed_won' }).eq('id', prospectId)

// Replace with Edge Function call that handles both the status and any downstream SOPs:
await supabase.functions.invoke('mark-prospect-won', { body: { prospect_id: prospectId, client_id: data.id } })
```

**File: `COS/src/pages/crm.tsx:53,66`**
```typescript
// These updates should go through an Edge Function or be restricted to authenticated 
// staff with service_role-equivalent access
// Short term: ensure the authenticated user has the correct Supabase auth role
// Long term: create an Edge Function `update-prospect-pipeline`
```

### 3E. Proof-Capture — Fix env var inconsistency

**File: `Proof-Capture/.env`** (or better: delete and create `.env.example`):
```bash
VITE_SUPABASE_URL=https://fgyvcyksgbivhrqoxkmj.supabase.co
VITE_SUPABASE_ANON_KEY=your_anon_key_here
VITE_SUPABASE_PUBLISHABLE_KEY=your_anon_key_here
```
Both variable names are needed until the duplicate client is resolved.

**File: `Proof-Capture/src/lib/supabase.ts`**
The `src/lib/supabase.ts` and `src/integrations/supabase/client.ts` are two different clients. Remove one:
```typescript
// Remove src/lib/supabase.ts and update all imports to use:
// import { supabase } from "@/integrations/supabase/client"
// Update PROOF_BUCKET and PROOF_TABLE constants to live in a config file
```

### 3F. COS — Fix wrong Edge Function names

**File: `COS/src/pages/Studio.tsx:290`**
```typescript
// Replace:
supabase.functions.invoke('generate-mjr', { ... })
// With:
supabase.functions.invoke('sop-08-mjr-build', { body: { prospect_id: selected.id } })
```

**File: `COS/src/pages/SPOA.tsx:489`**
```typescript
// Replace:
supabase.functions.invoke('spoa-generator', { ... })
// With:
supabase.functions.invoke('sop-12-spoa-build', { body: { prospect_id: selected.id } })
```

**File: `COS/src/pages/SprintDetail.tsx:362`**
```typescript
// Replace:
supabase.functions.invoke('generate-sprint-report', { ... })
// With:
supabase.functions.invoke('sop-47-weekly-reports', { body: { client_id: sprint.client_id } })
```

### 3G. AICOS Pipeline — Replace N+1 count queries with single RPC

**File: `AICOS/src/pages/Pipeline.tsx:fetchPipelineCounts`**

First create the DB function (see Section 2E below), then:
```typescript
async function fetchPipelineCounts(): Promise<PipelineCounts> {
  const { data, error } = await supabase.rpc('get_pipeline_counts')
  if (error) throw new Error(error.message)
  // data is [{status: 'new', count: 42}, ...]
  return Object.fromEntries(
    COUNT_STATUSES.map(s => [s, data.find((r: any) => r.status === s)?.count ?? 0])
  ) as PipelineCounts
}
```

---

## 4. Edge Functions to Create

### 4A. `update-prospect-from-conversation` (AICOS)
Handles stage-change updates from Outreach-System without direct DB writes:
```typescript
// AICOS/supabase/functions/update-prospect-from-conversation/index.ts
// Receives: { conversation_id, stage }
// Maps conversation stage → prospect status
// Writes to prospects using service_role key
// Logs to ai_task_log
```

### 4B. `mark-prospect-won` (AICOS)
Handles COS client creation flow:
```typescript
// AICOS/supabase/functions/mark-prospect-won/index.ts
// Receives: { prospect_id, client_id }
// Updates prospects.status = 'closed'
// Links prospect to client
// Logs to ai_task_log
```

### 4C. `brain-chat` (COS) — Reuse claude-chat
Instead of creating a new function, update `COS/src/lib/brain.ts` to call the existing `claude-chat` function with a different system prompt passed in the body.

### 4D. `update-user-role` (COS)
For admin role management. Requires service role to update auth.users metadata.

### 4E. `apify-start` / `apify-results` (COS)
For the prospect scraper workflow. These are COS-specific and should live in COS's supabase functions if COS gets its own function directory, or in AICOS as shared infrastructure.

---

## 5. RLS Policy Changes

Run these in the Supabase SQL Editor or as migration files:

```sql
-- ─── FIX: approval_queue anon UPDATE (AICOS operator actions) ─────────────
-- AICOS approve/reject actions use the browser anon client
create policy if not exists "anon update approval_queue"
  on public.approval_queue
  for update
  to anon
  using (true)
  with check (true);

-- ─── FIX: push_subscriptions anon SELECT ─────────────────────────────────
create policy "anon can read own subscription"
  on public.push_subscriptions
  for select
  to anon
  using (true);

-- ─── FIX: whatsapp_ai_suggestions - restrict anon UPDATE to own records ──
-- Replace the overly-broad "anon update status" policy
drop policy if exists "anon update status" on public.whatsapp_ai_suggestions;

create policy "authenticated update own suggestions"
  on public.whatsapp_ai_suggestions
  for update
  to authenticated
  using (true)
  with check (true);

-- ─── FIX: whatsapp_outreach_queue anon UPDATE for approvals ──────────────
create policy "anon update outreach queue status"
  on public.whatsapp_outreach_queue
  for update
  to anon
  using (true)
  with check (true);

-- ─── FIX: Add service_role policies to Outreach-System WhatsApp tables ───
-- (for AICOS Edge Functions to write stage/intent data)
-- These should already exist via service_role bypass, but explicit policies are safer:
-- For whatsapp_conversations, whatsapp_messages, whatsapp_ai_suggestions:
-- (service_role bypasses RLS by default in Supabase — verify in project settings)
```

---

## 6. Realtime Configuration

Run in Supabase SQL Editor to enable Realtime on required tables:

```sql
-- Enable Realtime for Outreach-System subscriptions
alter publication supabase_realtime add table public.whatsapp_conversations;
alter publication supabase_realtime add table public.whatsapp_ai_suggestions;
alter publication supabase_realtime add table public.whatsapp_outreach_queue;

-- Enable Realtime for AICOS approval queue subscription
alter publication supabase_realtime add table public.approval_queue;

-- Enable Realtime for AICOS pipeline (replaces polling)
alter publication supabase_realtime add table public.prospects;

-- Verify after running:
select tablename from pg_publication_tables where pubname = 'supabase_realtime' order by tablename;
```

After enabling Realtime, update AICOS Pipeline.tsx:
```typescript
// Replace refetchInterval: 1000 * 60 * 2 with Realtime subscription
// Replace refetchInterval: 1000 * 30 in Dashboard ai_task_log query
```

---

## 7. Integration Improvements

### 7A. Canonical prospect status vocabulary
Define one set of valid statuses shared by all repos. Create a migration that enforces this:

```sql
-- Canonical status set (merge of all repos):
alter table public.prospects drop constraint if exists prospects_status_check;
alter table public.prospects 
  add constraint prospects_status_check
  check (status in (
    -- AICOS acquisition funnel
    'new', 'enriched', 'staged', 'contacted', 'replied', 'warm', 'cold',
    'not_interested', 'unsubscribed',
    -- AICOS delivery funnel
    'mjr_ready', 'mjr_sent', 'spoa_ready', 'spoa_sent', 'call_booked',
    -- Outreach-System outcomes
    'qualified', 'booked', 'won', 'lost', 'do_not_contact',
    -- COS
    'closed', 'closed_won'
  ));
```

### 7B. Shared pipeline status view
Create a view that all repos can use for consistent prospect pipeline display:

```sql
create or replace view public.pipeline_summary as
select
  status,
  count(*)           as count,
  avg(icp_total_score) as avg_score,
  max(updated_at)    as last_updated
from public.prospects
where is_archived = false or is_archived is null
group by status;
```

### 7C. Replace `fetchPipelineCounts` N+1 with DB function

```sql
create or replace function public.get_pipeline_counts()
returns table (status text, count bigint)
language sql
security definer
as $$
  select status::text, count(*)::bigint
  from public.prospects
  where is_archived = false or is_archived is null
  group by status;
$$;
```

### 7D. Add prospect write Edge Function for cross-repo use

A single `AICOS/supabase/functions/update-prospect/index.ts` should handle all prospect writes from all repos:
- Validates the new status is in the canonical set
- Writes using service_role
- Logs to `ai_task_log`
- Can be called by COS and Outreach-System browsers using the anon JWT (with JWT verify enabled)

---

## 8. Phased Execution Plan

### Phase 0 — Immediate hotfixes (do today, no code review needed)
These are database-level fixes that unblock broken functionality:

1. **Enable Realtime** on `whatsapp_conversations`, `whatsapp_ai_suggestions`, `whatsapp_outreach_queue`, `approval_queue` (SQL Editor)
2. **Create missing storage buckets**: `sop-files`, `template-files`, `aa-assets`, `proof-uploads` (SQL Editor)
3. **Add `push_subscriptions` anon SELECT policy** (SQL Editor)
4. **Fix `approval_queue` anon UPDATE policy** (SQL Editor)
5. **Fix Proof-Capture `.env`**: add `VITE_SUPABASE_ANON_KEY` with same value as `VITE_SUPABASE_PUBLISHABLE_KEY`

**Estimated time:** 30 minutes. Zero code deploys required.

---

### Phase 1 — Critical schema fixes (Week 1)
These fix the most severe broken functionality:

**Step 1.1 — Create missing tables** (SQL Editor)
- Create `proof_submissions` table (Section 2C)
- Create `client_deliverables` table (Section 2C)
- Create `proof_sprint_client_data` table (Section 2C)
- Create `monthly_revenue` view (Section 2C)

**Step 1.2 — Add missing columns** (SQL Editor)
- Add `reply_classification`, `last_reply_at` to `prospects`
- Add `active_sprint_id` to `clients`
- Fix `clients` status constraint to include `paused`, `onboarding`

**Step 1.3 — Add missing indexes** (SQL Editor)
- Run all indexes from Section 2E

**Step 1.4 — AICOS TypeScript interface updates** (AICOS repo)
- Update `Prospect`, `Client`, `Sprint` interfaces (Section 3A)
- Update all `.from('prospects')` selects to use correct column names
- Update all `.from('sprints')` to `.from('proof_sprints')`
- Update all `.from('sprint_logs')` to `.from('sprint_daily_log')`
- Fix `createApprovalItem` to include `client_id`
- **Deploy AICOS to Railway**

**Step 1.5 — Proof-Capture env fix** (Proof-Capture repo)
- Remove duplicate Supabase client (Section 3E)
- Update `.env` file
- **Deploy Proof-Capture to GitHub Pages**

---

### Phase 2 — Prospect ownership fix (Week 2)
These restore CLAUDE.md data ownership rules:

**Dependency:** Phase 1 must be complete (canonical status values in DB)

**Step 2.1 — Create `update-prospect-from-conversation` Edge Function** (AICOS repo)
- Write and test the function (Section 4A)
- `npx supabase functions deploy update-prospect-from-conversation --no-verify-jwt`

**Step 2.2 — Create `mark-prospect-won` Edge Function** (AICOS repo)
- Write and test the function (Section 4B)
- `npx supabase functions deploy mark-prospect-won --no-verify-jwt`

**Step 2.3 — Update Outreach-System** to remove direct prospect writes (Section 3C)
- `updateConversationStage`: call `update-prospect-from-conversation` Edge Function instead
- `markProspectDoNotContact`: remove direct prospect.status write
- **Deploy Outreach-System to GitHub Pages**

**Step 2.4 — Update COS** to remove direct prospect writes (Section 3D)
- Clients.tsx: replace direct write with `mark-prospect-won` call
- crm.tsx, ProspectDetailView: route through Edge Function
- **Deploy COS to GitHub Pages**

---

### Phase 3 — WhatsApp schema reconciliation (Week 2-3)

**Dependency:** Phase 1 must be complete

**Step 3.1 — Decide on canonical stage vocabulary**
- The live DB uses Outreach-System stages (`new, needs_reply, qualified, quoted, booked, won, lost, bad_fit`)
- Either update AICOS SOPs to use these stages OR create a mapping layer
- Recommended: AICOS SOPs adopt Outreach-System vocabulary (Outreach-System is the domain owner)

**Step 3.2 — Update AICOS SOP 06 stage writes** (AICOS repo)
- `sop-06-reply-triage` must write `needs_reply` not `warm`, `qualified` not `call_booked`, etc.
- Update the stage mapping constants in the edge function

**Step 3.3 — Update AICOS WhatsApp migration files** (AICOS repo)
- Remove or mark as superseded: `20260510000000_create_whatsapp_conversations.sql` (no-ops in prod but confusing)
- Remove: `20260506400000_create_whatsapp_messages.sql` (same issue)
- Remove: `20260510100000_add_ai_intent_to_whatsapp_conversations.sql` (conflicts with live schema)
- The columns `ai_intent`, `needs_human` already exist from the Outreach-System migration

**Step 3.4 — Update `whatsapp_outreach_queue` schema** (AICOS repo)
- Decide whether Outreach-System's `OutreachQueueItem` type is the canonical definition
- If yes, add missing columns via migration: `niche, location, template_name, template_params, draft_preview, ai_observation, risk_score, compliance_status, created_by`
- Update Outreach-System's `getOutreachQueue()` to use typed access instead of `as any`

**Step 3.5 — Deploy SOP functions** (AICOS repo)
- Redeploy `sop-06-reply-triage` and `sop-01-outreach-drafts` with corrected column names
- `npx supabase functions deploy sop-06-reply-triage --no-verify-jwt`
- `npx supabase functions deploy sop-01-outreach-drafts --no-verify-jwt`

---

### Phase 4 — COS Edge Function gaps (Week 3-4)

**Step 4.1 — Wire COS to existing AICOS functions** (COS repo)
- `Studio.tsx`: `generate-mjr` → `sop-08-mjr-build` (Section 3F)
- `SPOA.tsx`: `spoa-generator` → `sop-12-spoa-build`
- `SprintDetail.tsx`: `generate-sprint-report` → `sop-47-weekly-reports`
- `brain.ts`: `brain-chat` → `claude-chat` with brain system prompt
- **Deploy COS**

**Step 4.2 — Create remaining missing Edge Functions** (AICOS repo or new shared-functions)
- `update-user-role` for admin role management
- `apify-start` / `apify-results` for prospect scraping
- Deploy each and update COS imports

---

### Phase 5 — Realtime and performance (Week 4)

**Step 5.1 — AICOS Pipeline Realtime** (AICOS repo)
- Replace `refetchInterval` polling with `supabase.channel().on('postgres_changes')` subscription on `prospects`
- This requires Realtime enabled (done in Phase 0)
- Remove `refetchInterval: 1000 * 60 * 2` from `countsQuery`

**Step 5.2 — Replace N+1 pipeline counts with RPC** (AICOS repo)
- Create `get_pipeline_counts()` DB function (Section 7C)
- Update `fetchPipelineCounts` (Section 3G)

**Step 5.3 — Document deployment order in CLAUDE.md** (aa-platform repo)
- Add note that WhatsApp functions deploy from Outreach-System directory
- Add separate deployment command blocks for each repo's functions

---

### Phase 6 — Consolidation (Week 5+)

**Step 6.1 — Merge `sops` table and `knowledge_base`**
- Decide canonical location for SOP definitions
- Migrate COS `sops` content into AICOS `knowledge_base` or vice versa
- Deprecate the unused table

**Step 6.2 — Merge finance schemas**
- AICOS `finance_ledger` and `finance_snapshots` should be the canonical tables
- Create `ledger` and `financial_snapshots` as views aliasing AICOS tables
- COS finance pages can continue to work via views with no code changes

**Step 6.3 — Unify client schema**
- The live `clients` table is the COS version — make AICOS TypeScript types fully match it
- Remove AICOS's shadow `clients` migration (it conflicts and no-ops in prod)
- Ensure all AICOS queries use COS column names

---

## Appendix — Quick Reference: What Breaks Today

| Broken Feature | Root Cause | Phase to Fix |
|---|---|---|
| Proof-Capture photo upload | `proof_submissions` table missing + wrong env var | Phase 0 + 1 |
| AICOS Sprint dashboard | Queries `sprints` not `proof_sprints` | Phase 1 |
| AICOS Pipeline (prospect names blank) | `name`/`company` columns don't exist | Phase 1 |
| AICOS Approval Queue actions | Missing anon UPDATE RLS policy | Phase 0 |
| AICOS Client drawer CPL chart | Queries `sprint_logs` not `sprint_daily_log` | Phase 1 |
| AICOS Client report generation | `createApprovalItem` missing `client_id` | Phase 1 |
| COS MJR generation (Studio) | Calls `generate-mjr` which doesn't exist | Phase 4 |
| COS SPOA generation | Calls `spoa-generator` which doesn't exist | Phase 4 |
| COS Scraper page | Calls `apify-start`/`apify-results` which don't exist | Phase 4 |
| COS Brain chat | Calls `brain-chat` which doesn't exist | Phase 4 |
| COS Tier workspace deliverables | `client_deliverables` table missing | Phase 1 |
| COS Proof Sprint V2 client data | `proof_sprint_client_data` table missing | Phase 1 |
| COS Finance page | `monthly_revenue` view missing | Phase 1 |
| Outreach-System Realtime toasts | Realtime not enabled on WhatsApp tables | Phase 0 |
| Outreach-System outreach approval | `whatsapp_outreach_queue` anon UPDATE missing | Phase 0 |
| All SOP outbound WhatsApp | Write `message_body` but live column is `body` | Phase 3 |
| SOP 06 stage updates | Stage vocabulary conflict | Phase 3 |
| File uploads in COS | Buckets don't exist | Phase 0 |
