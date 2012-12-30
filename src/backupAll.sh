#!/bin/sh

# Configuration
PSQL=/usr/bin/psql
PGDUMP=/usr/bin/pg_dump
FILE_PREFIX=`date +%F`
RETAIN_DAYS=1
TARGET_DIR=/var/lib/postgresql/backup/data

# Force creation of backup directory
mkdir -p $TARGET_DIR

# Get a list of databases to back up
echo "Retrieving list of databases to back up."
DBLIST=`$PSQL -tq -c "SELECT datname FROM pg_database WHERE datname !~ 'template\d'"`

# Back up each database
for CURDB in `echo $DBLIST`
do
	echo "Backing up $CURDB..."
	$PGDUMP -Fc -Z9 $CURDB > $TARGET_DIR/$CURDB.$FILE_PREFIX.backup
done
echo "Backup complete, tidying old backup files."

# Delete backup files that are no longer required
OLD_FILES=`find $TARGET_DIR -type f -mtime +$RETAIN_DAYS -name "*.backup"`

for CURFILE in `echo $OLD_FILES`
do
	echo "Deleting $CURFILE."
	rm -f $CURFILE
done

# Our work here is done!
echo "Done."
echo " "
