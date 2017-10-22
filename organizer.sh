#!/bin/bash
timestamp=$(date +%d-%m-%Y_%H-%M-%S)
backup_storage_dir="/home/backup/storage"

#     Copy the latest backup directory from daily to weekly storage dir
latest=$(ls -t $backup_storage_dir/daily | head -1)
cp "$backup_storage_dir/daily/$latest" $backup_storage_dir/weekly

#     Delete directories older than 30 days
find "$backup_storage_dir/weekly" -mtime +30 -type d -delete
