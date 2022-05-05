#!/bin/bash

# full backup number
number=15
backup_dir=/opt/couchbase_backup
dd=`date +%Y-%m-%d-%H-%M-%S`
today=`date +%Y-%m-%d`
today_dir=$backup_dir/$today
tool=/opt/couchbase/bin/cbbackup
server_url=http://127.0.0.1:8091
username=$1
password=$2

echo "$dd ---- start backup" |tee -a $backup_dir/log.txt

if [ ! -d $backup_dir/$today ];
then
    #create today
    mkdir -p $today_dir;
    echo "$dd ---- create $today_dir" |tee -a $backup_dir/log.txt
    #backup
    $tool -m full --single-node -t 3 $server_url $today_dir -u $username -p $password |tee -a $backup_dir/log.txt
    #backup log
    echo "$dd ---- create full back up at $today_dir" |tee -a $backup_dir/log.txt
else
    #backup
    $tool -m accu --single-node -t 3 $server_url $today_dir -u $username -p $password |tee -a $backup_dir/log.txt
    #backup log
    echo "$dd ---- create incremental back up at $today_dir" |tee -a $backup_dir/log.txt
fi
#clear
delfile=`ls -ltr  $backup_dir | grep -v log.txt | grep -v '^total' | awk '{print $9 }' | head -n 1`
count=`ls -ltr  $backup_dir | grep -v log.txt | grep -v '^total' | awk '{print $9 }' | wc -l`
if [ $count -gt $number ]
then
  sudo rm -rf $backup_dir/$delfile
  #del log
  echo "delete $backup_dir/$delfile" |tee -a $backup_dir/log.txt
fi
echo "$dd ---- finish backup" |tee -a $backup_dir/log.txt
