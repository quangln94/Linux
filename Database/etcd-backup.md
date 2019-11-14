# Backup and Restore `etcd`
## 1. APIv2
### 1.1 Backup
Backup thư mục `original data` và `wal` như sau:
```sh
etcdctl backup \
  --data-dir /var/lib/etcd \
  [--wal-dir /var/lib/etcd/member] \
  --backup-dir backup_data_dir
  [--backup-wal-dir backup_wal_dir]
```
Command này sẽ viết lại metadata (node ID vàcluster ID), để tạo cluster mới. Nó sẽ ngăn việc joined vào cluster cũ.

### 1.2 Restoring 
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

## 2. APIv3
### 2.1 Backup
Thực hiện `Snapshotting` từ 1 `etcd` member bằng lệnh `etcdctl snapshot save` như sau:
```sh
$ ETCDCTL_API=3 etcdctl --endpoints 10.10.10.221:2379 snapshot save snapshot.db
```
Hoặc copy file `member/snap/db` từ thư mục `etcd data`
### 2.2 Restore

Tất cả member nên sử dụng cùng 1 file `snapshot`. 

Nếu snapshot được lấy từ `etcdctl snapshot save` nó sẽ được hash và được check bởi `etcdctl snapshot restore`. Nếu `snapshot` là bản copy từ data directory sẽ không đươc hash và chỉ có thể restore bằng cách sử dụng `--skip-hash-check`.

Tạo mới etcd data directories (m1.etcd, m2.etcd, m3.etcd) cho cluster:
```sh
$ ETCDCTL_API=3 etcdctl snapshot restore snapshot.db \
  --name m1 \
  --initial-cluster m1=http://host1:2380,m2=http://host2:2380,m3=http://host3:2380 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-advertise-peer-urls http://host1:2380
$ ETCDCTL_API=3 etcdctl snapshot restore snapshot.db \
  --name m2 \
  --initial-cluster m1=http://host1:2380,m2=http://host2:2380,m3=http://host3:2380 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-advertise-peer-urls http://host2:2380
$ ETCDCTL_API=3 etcdctl snapshot restore snapshot.db \
  --name m3 \
  --initial-cluster m1=http://host1:2380,m2=http://host2:2380,m3=http://host3:2380 \
  --initial-cluster-token etcd-cluster-1 \
  --initial-advertise-peer-urls http://host3:2380
```
Start `etcd` với data directories mới:
```sh
$ etcd \
  --name m1 \
  --listen-client-urls http://host1:2379 \
  --advertise-client-urls http://host1:2379 \
  --listen-peer-urls http://host1:2380 &
$ etcd \
  --name m2 \
  --listen-client-urls http://host2:2379 \
  --advertise-client-urls http://host2:2379 \
  --listen-peer-urls http://host2:2380 &
$ etcd \
  --name m3 \
  --listen-client-urls http://host3:2379 \
  --advertise-client-urls http://host3:2379 \
  --listen-peer-urls http://host3:2380 &
```
## Tài liệu tham khảo
- https://github.com/etcd-io/etcd/blob/master/Documentation/v2/admin_guide.md#disaster-recovery
- https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/recovery.md
