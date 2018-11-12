# Linux note
## I. Config Network
**vi /etc/sysconfig/network-scrips/ifcfg**-***ens33*** `ens33 - tên card mạng cần config`
```BOOTPROTO=static
ONBOOT=yes
IPADDR=172.16.0.2
PREFIX=24
GATEWAY=172.16.0.1
DNS1=172.16.0.2
DNS2=8.8.8.8
```

**systemctl restart network**

## II. Config DHCP
**yum instal dhcpd -y**
**vi /etc/dhcp/dhcpd.conf**
```
option domain-name "domain.com";
option domain-name-servers server3.domain.com;
subnet 172.16.0.0 netmask 255.255.255.0 {
        range dynamic-bootp 172.16.0.100 172.16.0.200;
        option routers 172.16.0.1;
}
```
**systemctl restart dhcpd**

**systemctl enable dhcpd**

## III. Config DNS
**yum -y install bind**
**vi /etc/named.conf**

```options {
        listen-on port 53 { 172.16.0.2; };
        listen-on-v6 { none; };
        directory           "/var/named";
        dump-file           "/var/named/data/cache_dump.db";
        statistics-file     "/var/named/data/named_stats.txt";
        memstatistics-file  "/var/named/data/named_mem_stats.txt";
        allow-query         { localhost; 10.0.0.0/24; 172.16.0.0/24 };
        allow-transfer      { localhost; 10.0.0.0/24; };

        recursion yes;

        dnssec-enable yes;
        dnssec-validation yes;
        dnssec-lookaside auto;

        bindkeys-file "/etc/named.iscdlv.key";

        managed-keys-directory "/var/named/dynamic";

        pid-file "/run/named/named.pid";
        session-keyfile "/run/named/session.key";
};
logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};
```
**vi /etc/named.rfc1912.zones**
```
zone "domain.com" IN {
        type master;
        file "f.zone";
        allow-update { none; };
        };
zone "0.16.172.in-addr.arpa" IN {
        type master;
        file "r.zone";
        allow-update { none; };
        };
```
**vi /var/named/f.zone**
```
$TTL 86400
@   IN  SOA     server2.domain.com. root.server2.domain.com. (
        2014071001  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL )

                IN  NS      server2.domain.com.
                IN  A       172.16.0.2
                IN  MX 10   server3.enter.com.
server3         IN  A       172.16.0.3
```
**vi /var/named/r.zone**
```
$TTL 86400
@   IN  SOA     server2.domain.com. root.server2.domain.com. (
        2014071001  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL )
        IN      NS      server2.domain.com.
2       IN      PTR     server2.domain.com.     
3       IN      PTR     server3.domain.com.
```
