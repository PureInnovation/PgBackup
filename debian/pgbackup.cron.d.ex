#
# Regular cron jobs for the pgbackup package
#
0 4	* * *	root	[ -x /usr/bin/pgbackup_maintenance ] && /usr/bin/pgbackup_maintenance
