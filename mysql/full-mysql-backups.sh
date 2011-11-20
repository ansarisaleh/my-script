#!/bin/bash

# -----------
# Description
# -----------
# this Is script for full backups mysql database
# Author  : Fanani M. Ihsan
# Blog    : http://fanani.net
# Version : 1.0

# Edit configuration bellow
MYSQL_USER=mysql_username
MYSQL_PASS=mysql_password
MYSQL_HOST=mysql_host
DEST=/path/to/backups/

# Binary file path
MYSQL=`which mysql`
MYSQLDUMP=`which mysqldump`
CHOWN=`which chown`
CHMOD=`which chmod`

# File name
BACKUPS_NAME=$(date +"%m-%d-%Y")

# Command option
DBS=`$MYSQL -u$MYSQL_USER -h $MYSQL_HOST -p$MYSQL_PASS -Bse 'show databases'`

# Ignore information_schema
IGNORE="information_schema"

# Temporary file
DIR=`dirname $0`
TMP_BACKUPS=$DIR/tmp/`basename $0`

# Log
PATH_LOG=$DIR/logs/`basename $0`
LOG_NAME=$(date +"%m-%d-%Y")
NOW=$(date +"%m/%d/%Y %T")

# mkdir temporary files, log path , and destination backups
mkdir -p $TMP_BACKUPS
mkdir -p $PATH_LOG
mkdir -p $DEST

echo "" >> $PATH_LOG/$LOG_NAME.log
echo "----------- Starting backups -----------" >> $PATH_LOG/$LOG_NAME.log

for DB in $DBS
do
	skipdb=0
	if [ $DB = $IGNORE ]; then
		continue
	fi
	echo $NOW "Backup database =>" $DB  >> $PATH_LOG/$LOG_NAME.log
	$MYSQLDUMP -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS $DB > $TMP_BACKUPS/$DB.sql
done

cd $TMP_BACKUPS
echo $NOW "PWD to tmp directory -- " `pwd` >> $PATH_LOG/$LOG_NAME.log
echo $NOW "Create archive ..." >> $PATH_LOG/$LOG_NAME.log
tar -cjf $DEST$BACKUPS_NAME.tar.bz2 *
echo $NOW "Create archive file done !" >> $PATH_LOG/$LOG_NAME.log
echo $NOW "Remove temporary file ..." >> $PATH_LOG/$LOG_NAME.log
rm -rf *.sql
echo $NOW "Remove temporary file done" >> $PATH_LOG/$LOG_NAME.log
echo "----------- Finish backups -----------" >> $PATH_LOG/$LOG_NAME.log
echo "" >> $PATH_LOG/$LOG_NAME.log
