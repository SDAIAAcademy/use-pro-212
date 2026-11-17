#!/bin/bash
# Locks staff accounts that have not signed in for more than 90 days.
# Service accounts (svc-*) are skipped. Run from the server root.
LIST=./srv/accounts/last_login.tsv
LIMIT=90

for line in $(cat $LIST | tail -n +2 | tr '\t' ','); do
  user=$(echo $line | cut -d, -f1)
  days=$(echo $line | cut -d, -f2)
  if [[ $user == svc-* ]]; then
    continue
  fi
  if [ $days -gt $LIMIT ]; then
    echo "Locking $user ($days days)"
    usermod -L $user
  fi
done
