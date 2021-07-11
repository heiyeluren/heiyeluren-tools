lnmp install
=============


最后更新: 2012/3/4 v0.0.3<br />
下载地址: <a href="http://heiyeluren.googlecode.com/files/lnmp-install-0.0.3.tar.bz2">Download</a>


<b>基本描述</b>
  * LNMP自动安装Shell脚本
  * 能够自动在需要的Linux系统上 MySQL/PHP/Nginx/Memcached ，完全不用人工干预


<b>主要特点</b>
  * 能够自动下载所有需要安装软件包和库文件
  * 可以自定义需要安装的路径和库路径


<b>安装要求</b>
  * 服务器必须联网，因为需要下载相应安装包
  * 需要系统支持bash和 gcc/make 等基本编译工具
  * 目前只能支持root账户进行软件安装
  * 缺省软件都会安装在 /usr/local/
  * 暂时只支持Linux系统，在一些开启了SELinux 的系统上需要关闭 selinux 才能正常安装


<b>命令帮助</b>

<pre>
==============================================
 LNMP Soft Install Shell Script  Help Usage
==============================================
Option              Help
----------------------------------------------
help            - Print Help
dl              - Download LNMP soft
mysql           - Install MySQL Server
rm_mysql        - Remove MySQL Server
php             - Install PHP & PHP-FPM
php_ext         - Remove PHP Extensions
rm_php          - Remove PHP All File
nginx           - Install Nginx
rm_nginx        - Remove Nginx
memcached       - Install Memcached
rm_memcached    - Remove Memcached
all             - Install all server
rm_all          - Remove all server

===============================================
Usage Example: 

lnmp_install.sh dl
lnmp_install.sh all
lnmp_install.sh mysql
lnmp_install.sh php
lnmp_install.sh php_ext
lnmp_install.sh nginx   
===============================================

</pre>

