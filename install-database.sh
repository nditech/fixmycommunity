#! /bin/bash
psql -h db -U fms fms < /var/www/fixmystreet/fixmystreet/db/schema.sql
psql -h db -U fms fms < /var/www/fixmystreet/fixmystreet/db/generate_secret.sql
psql -h db -U fms fms < /var/www/fixmystreet/fixmystreet/db/alert_types.sql

# reports
/var/www/fixmystreet/fixmystreet/bin/update-all-reports