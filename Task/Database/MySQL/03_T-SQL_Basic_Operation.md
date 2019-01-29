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
