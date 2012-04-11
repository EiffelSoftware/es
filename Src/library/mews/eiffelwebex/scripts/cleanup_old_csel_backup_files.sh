#!/bin/tcsh
# cleanup csel data-file backup files older than 'holding_days'

set backup_folder=/home/wwwse/www/informatics_events/data/backup
set holding_days=7

find $backup_folder -type f -mtime +$holding_days -exec rm {} \; >> $backup_folder/cleanup.log 2>> $backup_folder/cleanup.err

# or, place the rm statement outside of find, supposed to be even more faster
#find $backup_folder -type f -mtime +$holding_days -print 2>> $backup_folder/cleanup.err | xargs rm -f
