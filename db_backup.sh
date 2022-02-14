#!/bin/bash
host=`hostname`
SECONDS=0
echo "Starting database enumeration and backup"
#echo
date
#echo
/usr/bin/mysql -s -r -e "show databases;" -N | while read dbname; do \
#echo "Backup for database: $dbname"; \
/usr/bin/mysqldump --complete-insert --single-transaction "$dbname" > \
/var/backups/sql/"$dbname"_`date +%a`_`hostname`.sql; done
#echo
echo "Database backup to /var/backups/sql complete."
#/usr/local/bin/telegram-send -g "msg db_backup completed on $host"
#echo
#date
duration=$SECONDS
if [ $(($duration / 60)) = 0 ]
  then
    echo "$(($duration % 60)) seconds to complete."
  else
    echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds to complete."
fi
exit 0
#/usr/bin/mysql --defaults-file=~/.my_cnf -s -r -e "show databases;" -N | while read dbname; do \
#/usr/bin/mysqldump --defaults-file=~/.my_cnf --complete-insert --single-transaction "$dbname" > \
