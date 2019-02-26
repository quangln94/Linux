# Installing WordPress on CentOS 7
## 1: Install Wget and Vim
```sh
yum install wget
yum install vim
```
## 2. Download and install WordPress
This step uses the previously installed Wget to install WordPress.
To download the WordPress installation package:
```sh
cd /var/www/html/
wget http://wordpress.org/latest.tar.gz
```
Unpack and install the package:
```sh
tar xzvf latest.tar.gz
```
## 4 Configure WordPress
```sh
cd /var/www/html
```
Create a copy of the default wp_config.php file in that directory:
```sh
cp wordpress/* /var/www/html/
cp wp-config-sample.php wp-config.php
```
Open the file in a text editor:
```sh
vim wp-config.php
```
Locate the section MySQL settings, then replace the variables for DB_NAME, DB_USER, and DB_PASSWORD with the <database>, <username>, and <password> variables you created in Section 2.</br>
Attention: Do not include the angled brackets (<>), which signify placeholder information.
```sh
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', '<database>');

/** MySQL database username */
define('DB_USER', '<username>');

/** MySQL database password */
   define('DB_PASSWORD', '<password>);
```  
  # Reference
  https://www.thermo.io/how-to/applications/installing-wordpress-on-centos-7
  
