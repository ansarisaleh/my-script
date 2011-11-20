#!/bin/bash

# -----------
# Description
# -----------
# simple rsync script to backups from remote to local with ssh-keygen
# Author  : Fanani M. Ihsan
# Blog    : http://fanani.net
# Version : 1.1

# --------
# HOWTO
# --------
# 1. Create ssh-keygen
# 2. Register public key to remote server
# 3. Setting Configuration bellow

# -----------------
# Create SSH-Keygen
# -----------------
# Running this action in local terminal
# $ ssh-keygen
# $ ls ~/.ssh
# id_rsa  id_rsa.pub
# copy id_rsa.pub to remote with scp or other
# Running this action in remote terminal
# $ cat /path/to/id_rsa.pub >> ~/.ssh/authorized_keys
# Test logon to remote with ssh, if  you can login without password , so it works !

# Configuration
# Edit configuration bellow
# directory setup must be end with "/"
SRC_BACKUPS=/path/to/remote/backups/
DEST_BACKUPS=/path/to/local/backups/
IP=<value IP or HOSTNAME>
USERNAME=<your_username>

# Global Variable
# Don't edit this configuration
DIR=`dirname $0`
PATH_LOG=$DIR/logs/`basename $0`
TMP_BACKUPS=$DIR/tmp/`basename $0`
LOG_NAME=$(date +"%m-%d-%Y")
BACKUPS_NAME=$(date +"%m-%d-%Y")
NOW=$(date +"%m/%d/%Y %T")
CMD=`which rsync`
OPTION="-ahr -pog --delete --log-file="$PATH_LOG/$LOG_NAME.log

# mkdir temporary files, log path , and destination backups
mkdir -p $TMP_BACKUPS
mkdir -p $PATH_LOG
mkdir -p $DEST_BACKUPS

# Starting rsync
echo "" >> $PATH_LOG/$LOG_NAME.log
echo "----------- Starting of rsync -----------" >> $PATH_LOG/$LOG_NAME.log
$CMD $OPTION -e "ssh -p 22" $USERNAME@$IP:$SRC_BACKUPS $TMP_BACKUPS
echo $NOW "Starting create archive file . . ." >> $PATH_LOG/$LOG_NAME.log
echo $NOW "Creating " $DEST_BACKUPS$BACKUPS_NAME.tar.bz2 >> $PATH_LOG/$LOG_NAME.log
cd $TMP_BACKUPS
echo $NOW "PWD to tmp directory -- " `pwd` >> $PATH_LOG/$LOG_NAME.log
tar -cjf $DEST_BACKUPS$BACKUPS_NAME.tar.bz2 *
echo $NOW "Create archive file done !" >> $PATH_LOG/$LOG_NAME.log
echo "----------- Ending of rsync  -----------" >> $PATH_LOG/$LOG_NAME.log
echo "" >> $PATH_LOG/$LOG_NAME.log
