#!/bin/sh

## cron_rclone.sh
# Greg Stengel <gregstengel@gmail.com>

# locking for rclone cron

### Changelog

## 2016.12.05 Greg Stengel <gregstengel@gmail.com>
# - Initial release

### Configuration

# rclone status log
status_log="/var/log/rclone_status.log"

# rclone verbose log
verbose_log="/var/log/rclone.log"

# lock file
lock="/var/tmp/cron_rclone.lock"

# time date stamp
stamp=$(date +"%Y/%m/%d %H:%M:%S")

### Checks

if [ -f $lock ]; then
  echo "$stamp $lock exists, rclone is currently running." >> $status_log
  exit 1
fi

### Functions

create_lock() {
  touch $lock
}

start_sync() {
  echo "$stamp rclone sync starting" >> $status_log
  /usr/sbin/rclone sync -v --max-size 50G /media/Documents "Amazon Cloud Drive":lampoon/Documents >$verbose_log 2>&1
  /usr/sbin/rclone sync -v --max-size 50G /media/Pictures "Amazon Cloud Drive":lampoon/Pictures >$verbose_log 2>&1
  stamp=$(date +"%Y/%m/%d %H:%M:%S")
  echo "$stamp rclone sync completed" >> $status_log
}

remove_lock() {
  rm $lock
}

### Process
create_lock
start_sync
remove_lock
