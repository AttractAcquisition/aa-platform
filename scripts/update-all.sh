#!/bin/bash
echo 'Updating all AA Platform submodules...'
for repo in AICOS Outreach-System COS Proof-Capture Website; do
  echo ''
  echo '--- Updating' $repo '---'
  cd $repo
  git pull origin main && echo $repo 'updated' || echo $repo 'had conflicts or errors'
  cd ..
done
echo ''
echo 'All repos updated.'
