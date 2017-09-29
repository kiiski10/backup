#!/bin/bash
previous_work_dir=$(pwd)
timestamp=$(date +%d-%m-%Y_%H-%M-%S)
backup_storage_dir="/home/backup/"$timestamp
mail_dir="/var/vmail"
www_root_dir="/var/www/html"

echo -e "----------\nBackup started: $timestamp"
mkdir "$backup_storage_dir"
echo "$timestamp		BEGIN" > $backup_storage_dir/log.txt


# Logging function that executes given jobs and logs the action
check_for_errors () {
	timestamp=$(date +%d-%m-%Y_%H-%M-%S)
	command="$@"
	echo "$timestamp 	--	$command" >> "$backup_storage_dir/log.txt"
	tail -n1 "$backup_storage_dir/log.txt"
	
	# Execute the job
	/bin/bash -c "$command"
	
	# Evaluate success
	timestamp=$(date +%d-%m-%Y_%H-%M-%S)
	if [ "$?" -ne "0" ]
		# Error
		then
			echo "$timestamp		ERR ^^" >> "$backup_storage_dir/log.txt"
			tail -n1 "$backup_storage_dir/log.txt"
		# Success
		else
			echo "$timestamp		OK ^^" >> "$backup_storage_dir/log.txt"
			tail -n1 "$backup_storage_dir/log.txt"
	fi
}


# List of jobs to execute to make backups
declare -a jobs=(
				"service postfix stop"
				"service dovecot stop"
				"cd $mail_dir"
				"tar -czf $backup_storage_dir/mail.tar.gz -C $mail_dir ."
				"service postfix start"
				"service dovecot start"
				"service apache2 graceful-stop"
				"cd $www_root_dir"
				"tar -czf $backup_storage_dir/html.tar.gz -C $www_root_dir/ ."
				"mysqldump --databases word_press > $backup_storage_dir/wpdb.sql"
				"mysqldump --databases dev_forum > $backup_storage_dir/forumdb.sql"
				"service apache2 start"
				"cd $previous_work_dir"
				)

# Iterate through the jobs
for i in "${jobs[@]}"
do
	check_for_errors "$i"
done

# Print ready-message after done
timestamp=$(date +%d-%m-%Y_%H-%M-%S)
echo -e "\nBackup completed: $timestamp"
