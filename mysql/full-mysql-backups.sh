#!/bin/bash

# -----------
# Description
# -----------
# This Is script for full backups mysql database
# Author  : Fanani M. Ihsan
# Blog    : http://fanani.net
# Version : 1.0

# Edit configuration bellow
MYSQL_USER=root
MYSQL_PASS=kediri123
MYSQL_HOST=127.0.0.1
BACKUPS_DEST=/tmp/ok/

# Binary file path
MYSQL=`which mysql`
MYSQLDUMP=`which mysqldump`
CHOWN=`which chown`
CHMOD=`which chmod`

# File name
BACKUPS_NAME=$(date +"%%Y-m-%d")

# Command option
DBS=`$MYSQL -h $MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS -Bse 'SHOW DATABASES'`

# Ignore information_schema
IGNORE="information_schema"

# Script location
DIR=`dirname $0`

# Temporary file
TMP_BACKUPS=$DIR/tmp/`basename $0`

# Log
PATH_LOG=$DIR/logs/`basename $0`
LOG_NAME=$(date +"%Y-%m-%d")
NOW=$(date +"%Y/%m/%d %T")

# mkdir temporary files, log path , and destination backups
mkdir -p $TMP_BACKUPS
mkdir -p $PATH_LOG
mkdir -p $BACKUPS_DEST

echo "" >> $PATH_LOG/$LOG_NAME.log
echo "----------- Starting backups -----------" >> $PATH_LOG/$LOG_NAME.log

for DB in $DBS
do
	skipdb=0
	if [ $DB = $IGNORE ]; then
		continue
	fi
	echo $NOW "Backup database =>" $DB  >> $PATH_LOG/$LOG_NAME.log
	#$MYSQLDUMP -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_PASS $DB > $TMP_BACKUPS/$DB.sql
	echo $DB
done

cd $TMP_BACKUPS
echo $NOW "PWD to tmp directory -- " `pwd` >> $PATH_LOG/$LOG_NAME.log
echo $NOW "Create archive ..." >> $PATH_LOG/$LOG_NAME.log
#tar -cjf $BACKUPS_DEST$BACKUPS_NAME.tar.bz2 *
#echo $NOW "Create archive file done !" >> $PATH_LOG/$LOG_NAME.log
#echo $NOW "Remove temporary file ..." >> $PATH_LOG/$LOG_NAME.log
#rm -rf *.sql
#echo $NOW "Remove temporary file done" >> $PATH_LOG/$LOG_NAME.log
echo "----------- Finish backups -----------" >> $PATH_LOG/$LOG_NAME.log
echo "" >> $PATH_LOG/$LOG_NAME.log
