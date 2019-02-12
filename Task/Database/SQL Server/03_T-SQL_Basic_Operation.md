# This shows Transact-SQL (T-SQL) Basic Operation.
## 1.	Create/Delete Databases.
```sh
[root@server1 ~]# sqlcmd -S localhost -U SA
Password:

# create [SampleDB] database
1> create database SampleDB; 
2> go 

# create a database with parameters
1> create database SampleDB2
2> on primary (
3>  name = 'SampleDB2',
4>  filename = '/var/opt/mssql/data/SampleDB2.mdf',
5>  size = 5GB,
6>  maxsize = unlimited,
7>  filegrowth = 10MB
8> )
9> log on (
10>  name = 'SampleDB2_log',
11>  filename = '/var/opt/mssql/data/SampleDB2_log.ldf',
12>  size = 1GB,
13>  maxsize = 2GB,
14>  filegrowth = 5%
15> )
16> go

# list databases
1> select name, create_data from sys.databases;
2> go
Msg 207, Level 16, State 1, Server server1, Line 1
Invalid column name 'create_data'.
1> select name, create_date from sys.databases;
2> go
name                                         create_date
-------------------------------------------- -----------------------
master                                       2003-04-08 09:13:36.390
tempdb                                       2019-01-29 11:07:56.303
model                                        2003-04-08 09:13:36.390
msdb                                         2018-11-30 15:04:03.013
SampleDB2                                    2019-01-29 11:32:40.490

(5 rows affected)

# delete [SampleDB2] database
1> drop database SampleDB2;
2> go
```
## 2.	Create/Delete Tables.
```sh
# connect to SQL Server with a database
[root@server1 ~]# sqlcmd -S localhost -U SA -d SampleDB
Password:
# create [Sample_Table] table
1> create table dbo.Sample_Table ( 
2> Number nvarchar(10) not null, 
3> First_Name nvarchar(50) not null, 
4> Last_Name nvarchar(50) null, 
5> Last_Update date not null 
6> ) 
7> go 

# list tables
1> select name from sysobjects 
2> where xtype='u' 
3> go 
name                     
-------------------------
Sample_Table             

(1 rows affected)

# delete [Sample_Table] table
1> drop table dbo.Sample_Table; 
2> go
```
## 3.	Insert/Update/Delete Datas.
```sh
[root@server1]# sqlcmd -S localhost -U SA -d SampleDB 
Password:

# insert data
1> insert into dbo.Sample_Table ( 
2> Number, First_Name, Last_Name, Last_Update 
3> ) 
4> values ( 
5> '00001', 'CentOS', 'Linux', '2017-10-05' 
6> ) 
7> go 

(1 rows affected)

1> select * from dbo.Sample_Table; 
2> go 
Number     First_Name    Last_Name     Last_Update
---------- ------------- ------------- ----------------
00001      CentOS        Linux               2017-10-05
00002      RedHat        Linux               2017-10-05
00003      Fedora        Linux               2017-10-05
00004      Ubuntu        Linux               2017-10-05
00005      Debian        Linux               2017-10-05

(1 rows affected)

# show tables with specifying columns
1> select Number, First_Name from dbo.Sample_Table 
2> go 
Number     First_Name
---------- --------------------------------------------------
00001      CentOS
00002      RedHat
00003      Fedora
00004      Ubuntu
00005      Debian

(5 rows affected)

# show top 3 datas
1> select top 3 * from dbo.Sample_Table 
2> go 
Number     First_Name    Last_Name     Last_Update
---------- ------------- ------------- ----------------
00001      CentOS        Linux               2017-10-05
00002      RedHat        Linux               2017-10-05
00003      Fedora        Linux               2017-10-05

(3 rows affected)

# update data
1> update dbo.Sample_Table 
2> set Last_Update = '2017-10-06' 
3> where First_Name = 'Debian' 
4> go 

(1 rows affected)

1> select * from dbo.Sample_Table where First_Name ='Debian' 
2> go 
Number     First_Name    Last_Name     Last_Update
---------- ------------- ------------- ----------------
00005      Debian        Linux               2017-10-06

(1 rows affected)

# delete data
1> delete dbo.Sample_Table where First_Name ='Debian' 
2> go 

(1 rows affected)
1> select * from dbo.Sample_Table where First_Name ='Debian' 
2> go 
Number     First_Name    Last_Name     Last_Update
---------- ------------- ------------- ----------------

(0 rows affected)
```
## 4.	It's also possible to run T-SQL directly like follows.
```sh
[root@server1 ~]# sqlcmd -S localhost -U SA -Q 'select name,create_date from sys.databases' 
Password:

name                                         create_date
-------------------------------------------- -----------------------
master                                       2003-04-08 09:13:36.390
tempdb                                       2019-01-29 11:07:56.303
model                                        2003-04-08 09:13:36.390
msdb                                         2018-11-30 15:04:03.013
SampleDB2                                    2019-01-29 11:32:40.490

(5 rows affected)
```
