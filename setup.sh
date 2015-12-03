#! /bin/bash
psql -h db -U fms fms < /var/www/fixmystreet/fixmystreet/db/schema.sql
psql -h db -U fms fms < /var/www/fixmystreet/fixmystreet/db/generate_secret.sql
psql -h db -U fms fms < /var/www/fixmystreet/fixmystreet/db/alert_types.sql

# reports
/var/www/fixmystreet/fixmystreet/bin/update-all-reports

# Languages
sed -i '/ar__AR/d' /var/lib/locales/supported.d/local
locale-gen --purge 
locale-gen ar fr_FR.UTF-8 es.UTF-8 ru.UTF-8