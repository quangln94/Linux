# 1. Add SQL Server 2017 Repository and Install it.
```sh
[root@server1]# curl https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo -o /etc/yum.repos.d/mssql-server-2017.repo 
[root@server1]# curl https://packages.microsoft.com/config/rhel/7/prod.repo -o /etc/yum.repos.d/msprod.repo
[root@server1]# yum -y install mssql-server mssql-tools unixODBC-devel
```
# 2.	Run initial Setup.
```sh
[root@dlp ~]# /opt/mssql/bin/mssql-conf setup 
Choose an edition of SQL Server:
  1) Evaluation (free, no production use rights, 180-day limit)
  2) Developer (free, no production use rights)
  3) Express (free)
  4) Web (PAID)
  5) Standard (PAID)
  6) Enterprise (PAID)
  7) Enterprise Core (PAID)
  8) I bought a license through a retail sales channel and have a product key to enter.

Details about editions can be found at
https://go.microsoft.com/fwlink/?LinkId=852748&clcid=0x409

Use of PAID editions of this software requires separate licensing through a
Microsoft Volume Licensing program.
By choosing a PAID edition, you are verifying that you have the appropriate
number of licenses in place to install and run this software.

# select an edition you'd like to use
Enter your edition(1-8): 2
The license terms for this product can be found in
/usr/share/doc/mssql-server or downloaded from:
https://go.microsoft.com/fwlink/?LinkId=855862&clcid=0x409

The privacy statement can be viewed at:
https://go.microsoft.com/fwlink/?LinkId=853010&clcid=0x409

# agree to the license
Do you accept the license terms? [Yes/No]:y

# set admin password
Enter the SQL Server system administrator password:
Confirm the SQL Server system administrator password:
Configuring SQL Server...

Created symlink from /etc/systemd/system/multi-user.target.wants/mssql-server.service to 
  /usr/lib/systemd/system/mssql-server.service.
Setup has completed successfully. SQL Server is now starting.

[root@dlp ~]# systemctl status mssql-server 
*  mssql-server.service - Microsoft SQL Server Database Engine
   Loaded: loaded (/usr/lib/systemd/system/mssql-server.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2017-10-05 19:24:33 JST; 50min ago
     Docs: https://docs.microsoft.com/en-us/sql/linux
 Main PID: 1472 (sqlservr)
   CGroup: /system.slice/mssql-server.service
           +--1472 /opt/mssql/bin/sqlservr
           +--1493 /opt/mssql/bin/sqlservr

Oct 05 19:24:38 dlp.srv.world sqlservr[1472]: 2017-10-05 19:24:38.50 spid11s....
Hint: Some lines were ellipsized, use -l to show in full.

[root@dlp ~]# echo 'export PATH=$PATH:/opt/mssql-tools/bin' > /etc/profile.d/mssql.sh 
[root@dlp ~]# source /etc/profile.d/mssql.sh 
```
# 3.	If Firewalld is running and also SQL Server is used from remote Hosts, allow service port like follows.
```sh
[root@dlp ~]# firewall-cmd --add-port=1433/tcp --permanent 
success
[root@dlp ~]# firewall-cmd --reload 
success
```
# 4.	Connect to the SQL Server and verify working.
```sh
[root@dlp ~]# sqlcmd -S localhost -U SA 
Password:   # admin password you set

# show system databases
1> select name,database_id from sys.databases; 
2> go 
name          database_id
------------- -----------
master                  1
tempdb                  2
model                   3
msdb                    4

(4 rows affected)

# show system users
1> select name from sysusers; 
2> go 
name
-----------------------------------------
##MS_AgentSigningCertificate##           
##MS_PolicyEventProcessingLogin##        
db_accessadmin                           
db_backupoperator                        
db_datareader                            
db_datawriter                            
db_ddladmin                              
db_denydatareader                        
db_denydatawriter                        
db_owner                                 
db_securityadmin                         
dbo                                      
guest                                    
INFORMATION_SCHEMA                       
public                                   
sys                                      

(16 rows affected)

# show current user
1> select current_user; 
2> go 

-------------------------------
dbo                            

(1 rows affected)

# quit
1> exit 
```
