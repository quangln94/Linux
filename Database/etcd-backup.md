# Backup and Restore `etcd`
## Backup
Backup thư mục `original data` và `wal` như sau:
```sh
etcdctl backup \
  --data-dir /var/lib/etcd \
  [--wal-dir /var/lib/etcd/member] \
  --backup-dir backup_data_dir
  [--backup-wal-dir backup_wal_dir]
```
Command này sẽ viết lại metadata (node ID vàcluster ID), để tạo cluster mới.  Nó sẽ ngăn việc joined vào cluster cũ

## Restoring 
Sử dụng option `--force-new-cluster` để tạo ra 1 Node mới với `advertised peer URLs` mặc định.
```sh
etcd \
  -data-dir=backup_data_dir \
  [-wal-dir=backup_wal_dir] \
  --force-new-cluster \
```
Now etcd should be available on this node and serving the original datastore.

Once you have verified that etcd has started successfully, shut it down and move the data and wal, if stored separately, back to the previous location (you may wish to make another copy as well to be safe):

    pkill etcd
    rm -fr %data_dir%
    rm -fr %wal_dir%
    mv %backup_data_dir% %data_dir%
    mv %backup_wal_dir% %wal_dir%
    etcd \
      -data-dir=%data_dir% \
      [-wal-dir=%wal_dir%] \
      ...
Restoring the cluster
Now that the node is running successfully, change its advertised peer URLs, as the --force-new-cluster option has set the peer URL to the default listening on localhost.

You can then add more nodes to the cluster and restore resiliency. See the add a new member guide for more details.

Note: If you are trying to restore your cluster using old failed etcd nodes, please make sure you have stopped old etcd instances and removed their old data directories specified by the data-dir configuration parameter.



## Tài liệu tham khảo
- https://github.com/etcd-io/etcd/blob/master/Documentation/v2/admin_guide.md#disaster-recovery
- https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/recovery.md
