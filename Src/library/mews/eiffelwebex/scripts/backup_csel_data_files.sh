#!/bin/tcsh
# backup csel data files into backup folder

set data_folder=/home/wwwse/www/informatics_events/data

tar -cpzf $data_folder/backup/csel_backup_`date +%Y_%m_%d_%H%M`.tgz $data_folder/event* $data_folder/users
