# Backup

## Add the following cronjobs

~~~~
50	3	*	*	*	/bin/bash /home/backup/backup.sh
00	5	*	*	1	/bin/bash /home/backup/organizer.sh
~~~~
