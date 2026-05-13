#!/bin/bash
echo 'AA Platform System Check'
echo '========================'
export SUPABASE_ACCESS_TOKEN=${SUPABASE_ACCESS_TOKEN}
cd AICOS
echo ''
echo '--- Recent AI task log (last 10) ---'
npx supabase db query 'select sop_id, sop_name, status, created_at from ai_task_log order by created_at desc limit 10' --linked
echo ''
echo '--- Cron schedule status ---'
npx supabase db query 'select sop_id, is_active, last_status, last_run, last_error from cron_schedule order by sop_id' --linked
echo ''
echo '--- Open alerts ---'
npx supabase db query 'select severity, category, message, created_at from ai_alerts where resolved = false order by created_at desc' --linked
cd ..
