#!/usr/bin/env bash
# Deletes booking-system backups that are older than 30 days.
# Run from the server root. Usage: purge_backups.sh
set -eu

echo "Purging backups older than 30 days in ./srv/backup"
find ./srv/backup -delete -name '*.tar.gz' -mtime +30
echo "Done"
