## couchbase_scripts
some scripts for couchbase

## backup
backup_dir: /opt/couchbase_backup  
backup_log: /opt/couchbase_backup/log.txt  
backup_num: 15  
backup_mode: full backup daily + accu backup hourly

## restore
##### 1. stop sync-gateway && midway
+ docker stop sync-gateway midway
##### 2. prepare a new bucket or del && create the bucket if exists
##### 3. run restore.sh
##### 4. create index by create_index.sql: Index must be built manually(https://docs.couchbase.com/server/6.0/cli/cbrestore-tool.html)
##### 5. reset XDCR(why: https://docs.couchbase.com/server/6.0/learn/clusters-and-availability/xdcr-conflict-resolution.html):
+ del slave bucket
+ create slave bucket
+ add XDCR Replication: XDCR Checkpoint Interval=60s
##### 6. check role permission(config path: ~/deploy/local_config.json,~/deploy/sync_gateway.json): 
+ sync_gateway   Full Admin
+ midway         XDCR Inbound[robot], Application Access[robot], Bucket Admin[robot], Read-Only Admin 
##### 7. start sync-gateway && midway
+ docker start sync-gateway midway

## use index robot id in sql
eg: SELECT robot.*, meta().id AS meta_id FROM robot WHERE ANY robot_id IN robot.robot_ids SATISFIES robot_id = 'robot_dog_sr_66040' END and ...
