# This shows Transact-SQL (T-SQL) Basic Operation.
```sh
[root@server1 ~]# sqlcmd -S localhost -U SA
Password:
1> create database SampleDB2
2> on primary (
3> name = 'SampleDB2',
4> filename = '/var/opt/mssql/data/SampleDB2.mdf',
5> size = 5GB,
6> mazsize = unlimited,
7> filegrowth = 10MB
8> )
9> log on (
10> name = 'SampleDB2_log',
11> filename = '/var/opt/mssql/data/SampleDB2_log.ldf',
12> size = 1GB,
13> maxsize = 2GB,
14> filegrowth = 5%
15> )
16> go
Msg 153, Level 15, State 1, Server server1, Line 6
Invalid usage of the option mazsize in the CREATE/ALTER DATABASE statement.
1> create database SampleDB2
2> on primary (
3> name = 'SampleDB2',
4> filename = '/var/opt/mssql/data/SampleDB2.mdf',
5> size = 5GB,
6> maxsize = unlimited,
7> filegrowth = 10MB
8> )
9> log on (
10> name = 'SampleDB2_log',
11> filename = '/var/opt/mssql/data/SampleDB2_log.ldf',
12> size = 1GB,
13> maxsize = 2GB,
14> filegrowth = 5%
15> )
16> go
1> select name, create_data from sys.databases;
2> go
Msg 207, Level 16, State 1, Server server1, Line 1
Invalid column name 'create_data'.
1> select name, create_date from sys.databases;
2> go
name                                                                                                                             create_date
-------------------------------------------------------------------------------------------------------------------------------- -----------------------
master                                                                                                                           2003-04-08 09:13:36.390
tempdb                                                                                                                           2019-01-29 11:07:56.303
model                                                                                                                            2003-04-08 09:13:36.390
msdb                                                                                                                             2018-11-30 15:04:03.013
SampleDB2                                                                                                                        2019-01-29 11:32:40.490

(5 rows affected)

# delete [SampleDB2] database
1> drop database SampleDB2;
2> go
```
