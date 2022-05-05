#!/bin/bash

backup_dir=/opt/couchbase_backup
log_file=$backup_dir/log.txt
dd=`date +%Y-%m-%d-%H-%M-%S`
tool=/opt/couchbase/bin/cbrestore

echo "$dd ---- start restore" |tee -a $log_file

echo "Service url:"
echo "eg: http://127.0.0.1:8091"
read service_url
echo "Couchbase user name:"
read user_name
echo "Couchbase password:"
read password

ls $backup_dir|grep -v 'log.txt'|awk '{print $NF}'
echo "Please type the backup date you want to restore:"
echo "(eg: 2022-01-01)"
read restore_date

tmp_dir=`ls $backup_dir/$restore_date`
ls $backup_dir/$restore_date/$tmp_dir|awk '{print $NF}'
echo "Please type a backup you want to restore:"
echo "(eg: 2022-01-25T010001Z-accu)"
read backup

echo "Source Bucket:"
read source_bucket

echo "Existing destination Bucket which will be overrides:"
echo "Important: if destination not equal to source_bucket, index will not be restore and raise error"
read destination

if [ -d $backup_dir/$restore_date/$tmp_dir/$backup ];
then
  echo "$dd ---- backup: $backup, source_bucket: $source_bucket, destination: $destination" |tee -a $log_file
  $tool -b $source_bucket -B $destination $backup_dir/$restore_date/$tmp_dir/$backup -x conflict_resolve=0 $service_url -u $user_name -p $password
  echo "$dd ---- restore success" |tee -a $log_file
else
  echo "Invalid input" |tee -a $log_file
fi
echo "$dd ---- finish restore" |tee -a $log_file
