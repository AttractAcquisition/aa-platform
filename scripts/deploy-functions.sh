#!/bin/bash
echo 'Deploying all Supabase Edge Functions...'
export SUPABASE_ACCESS_TOKEN=${SUPABASE_ACCESS_TOKEN}
functions=(
  run-sop claude-chat
  sop-58-daily-briefing sop-06-reply-triage sop-01-outreach-drafts
  sop-02-prospect-scraper sop-03-enrichment sop-04-crm-staging sop-05-lead-sourcing
  sop-07-call-brief sop-08-mjr-build sop-10-delivery-sequence sop-12-spoa-build
  sop-15-offer-prep sop-17-onboarding-brief sop-21-sprint-daily-ops sop-23-ads-monitoring
  sop-26-sprint-closeout sop-31-proof-brand-ops sop-33-sop-versioning sop-35-upsell-detection
  sop-41-weekly-review sop-43-authority-brand-ops sop-46-billing sop-47-weekly-reports
  sop-49-content sop-51-admin-check sop-52-backup-check sop-53-kpi-review sop-56-finance-dashboard
  meta-whatsapp-webhook send-whatsapp-message send-whatsapp-template-message
  generate-whatsapp-reply-suggestion sync-whatsapp-templates whatsapp-integration-health
  meta-ads-sync send-push-notification
)
cd AICOS
for fn in ${functions[@]}; do
  echo 'Deploying' $fn
  npx supabase functions deploy $fn --no-verify-jwt 2>&1 | tail -2
done
cd ..
echo 'All functions deployed.'
