# Install Etcd
## 1. Giới thiệu

`etcd` là cơ sở sử liệu phân tán. Dùng để lưu trữ các giá trị key-value quan trọng trong hệ thống phân tán. Nó được viết bằng Go và sử dụng thuật toán [Raft](http://thesecretlivesofdata.com/raft/) để quản lý highly-available replicated log.

`etcd` được thiết kế để: 
- Simple: well-defined, user-facing API (gRPC)
- Secure: automatic TLS with optional client cert authentication
- Fast: benchmarked 10,000 writes/sec
- Reliable: properly distributed using Raft

## 2. Setup Etcd Cluster trên CentOS 7/8, Ubuntu 18.04/16.04, Debian 10/9

Mô hình cluster:
||server01|server02|server03|
|-----|--------|--------|---|
|IP

## Tài liệu tham khảo
- https://computingforgeeks.com/setup-etcd-cluster-on-centos-debian-ubuntu/
