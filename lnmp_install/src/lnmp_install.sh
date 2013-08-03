#!/bin/bash

####################################################
# LNMP Environment Install Shell Script
# 
# @author H&M (heiyeluren & miky)
# @date 2012/2/26
# @version v0.0.2
# @history 
#   2012/2/26 v0.0.1  
#   2012/3/02 v0.0.2
#   2012/3/04 v0.0.3
#
# @link
#   blog: http://blog.csdn.net/heiyeshuwu
#   more: http://heiyeluren.googlecode.com
#
#####################################################



#=============================================
# 
#      ----- Const variable Define ------
#
#=============================================


#########################
# Install Path Setting
#########################

##setting
#local_lib_dir="/usr/local"
local_lib_dir="/usr/local"
nginx_dir="/usr/local/nginx"
php_dir="/usr/local/php"
php_ini="${php_dir}/etc/php.ini"
mysql_dir="/usr/local/mysql"
mysql_cnf='/usr/local/mysql/my.cnf'
memcached_dir="/usr/local/memcached"

#install server is auto start, yes:1, no:0
auto_start_server=1


#########################
# Install Const Setting
#########################

## !!Don't modified!! ###
#=============================================
lnmp_url="http://heiyeluren.googlecode.com/files/lnmp_soft_20120303.tar.bz2"
packages=`pwd`"/down_soft"

## server inst file ##
srv_mysql_file="mysql-5.1.61.tar.gz"
srv_php_file="php-5.2.13.tar.gz"
srv_php_fpm_file="php-5.2.13-fpm-0.5.13.diff.gz"
srv_nginx_file="nginx-0.8.55.tar.gz"
srv_memcached_file="memcached-1.4.13.tar.gz"

## lib inst file ##
lib_pcre_file="pcre-8.30.tar.gz"
lib_libevent_file="libevent-2.0.16-stable.tar.gz"
lib_curl_file="curl-7.24.0.tar.gz"
lib_iconv_file="libiconv-1.13.1.tar.gz"
lib_xml_file="libxml2-2.7.8.tar.gz"
lib_xslt_file="libxslt-1.1.19.tar.gz"
lib_zlib_file="zlib-1.2.6.tar.gz"
lib_libmcrypt_file="libmcrypt-2.5.8.tar.gz"
lib_mcrypt_file="mcrypt-2.6.8.tar.gz"
lib_mhash_file="mhash-0.9.9.9.tar.gz"
lib_jpeg_file="jpegsrc.v8d.tar.gz"
lib_freetype_file="freetype-2.3.12.tar.gz"
lib_png_file="libpng-1.2.44.tar.gz"
lib_libmemcached_file="libmemcached-1.0.4.tar.gz"
lib_imagemagick_file="ImageMagick-6.7.5-8.tar.gz"

## php ext inst file ##
ext_memcache_file="memcache-3.0.6.tgz"
ext_libmemcached_file="memcached-2.0.0.tgz"
ext_pdo_mysql_file="PDO_MYSQL-1.0.2.tgz"
ext_eacc_file="eaccelerator-0.9.6.tar.bz2"
ext_imagick_file="imagick-3.1.0RC1.tgz"
#=============================================

## global variable ##
g_dir=""
g_curr_dir=""
g_file=""



#=============================================
# 
#      ----- Run Function Define ------
#
#=============================================


###############################
#
# Install lib file 
# (common private function)
#
###############################
function _install_lib
{
    local _lib_file
    local _lib_dir
    local _lib_inst_path
    local _lib_file_suffix
    
   _lib_inst_path=$local_lib_dir #$local_lib_dir
   _lib_file=$1
   _lib_dir=`echo $_lib_file|awk -F.tar '{print $1}'`
   _lib_file_suffix=`echo $_lib_file|awk -F. '{print $NF}'`

    ## jpeg
    if [ "$_lib_file" =  "$lib_jpeg_file" ]; then
        _lib_dir="jpeg-8d"
    fi

    cd $packages
    if [ $_lib_file_suffix = "gz" ]; then
        tar zxvf $_lib_file
    elif [ $_lib_file_suffix = "bz2" ]; then
        tar jxvf $_lib_file
    elif [ $_lib_file_suffix = "tgz" ]; then
        _lib_dir=`echo $_lib_file|awk -F.tgz '{print $1}'`
        tar zxvf $_lib_file
    else
        echo "Func[_install_lib]: Install lib error, ${_lib_file} file unkown compress file."
        return 1 
    fi
    if [ ! -d $_lib_dir ]; then
        echo "Func[_install_lib]: Install lib error,  decompress ${_lib_file} file, can't create dir: ${_lib_dir}."
        return 1
    fi
    
    echo "Func[_install_lib]: Install lib: ${_lib_file} ..."
    cd $_lib_dir
    ./configure --prefix=${_lib_inst_path}
    make && make install && cd $packages
    #$g_dir=$_dir
    g_dir="${packages}/${_lib_dir}"
    g_curr_dir=${_lib_dir}
    
    return 0
}

###############################
#
#  Decompress compress file 
# (common private function)
#
###############################
function _decompress_file
{
    local _file
    local _file_suffix
    local _dir
    
    _file=$1
    #_file_suffix=`echo $_file|awk -F.tar '{print $2}'`
    _file_suffix=`echo $_file|awk -F. '{print $NF}'`
    _dir=`echo $_file|awk -F.tar '{print $1}'`
    
    if [ $_file_suffix = "gz" ]; then
        tar zxvf $_file
    elif [ $_file_suffix = "bz2" ]; then
        tar jxvf $_file
    elif [ $_file_suffix = "tgz" ]; then
        _dir=`echo $_file|awk -F.tgz '{print $1}'`
        tar zxvf $_file
    else
        echo "Func[_decompress_file] error: ${_file} file unkown compress file."
        return 1
    fi
    if [ ! -d $_dir ]; then
        echo "Func[_decompress_file] error: decompress ${_file} file, can't create dir: ${_dir}."
        return 1
    fi
    
    #set global dir variable
    #$g_dir=$_dir
    g_dir="${packages}/${_dir}"
    g_curr_dir=${_dir}

    return 0
}



#########################
#
# Download LNMP Soft
#
#########################
function download_soft
{
lnmp_file=`echo $lnmp_url|awk -F\/ '{print $5}'`
if [ ! -e "$lnmp_file" ];then
    wget $lnmp_url
fi
if [ ! -d "$packages" ];then
    tar jxvf $lnmp_file
fi
echo "Download LNMP soft done, LNMP soft path: $packages."
}


#########################
#
# Install MySQL Server
#
#########################
function install_mysql
{
cd $packages
USER=`grep mysql /etc/passwd |wc -l`
if [ $USER = 0 ];then
    groupadd mysql
    useradd -g mysql mysql
fi

#install mysql
if [ ! -d "${mysql_dir}" ];then
    _decompress_file $srv_mysql_file
    cd $g_dir
    ./configure --prefix=${mysql_dir} 
                --with-extra-charsets=all \
                --enable-thread-safe-client \
                --enable-assembler \
                --with-charset=utf8 \
                --enable-thread-safe-client \
                --with-extra-charsets=all \
                --with-big-tables \
                --with-readline \
                --with-ssl \
                --with-embedded-server \
                --enable-local-infile \
                --without-debug
    make && make install
else
    echo "MySQL source dir aleady install"
fi

if [ ! -f "$mysql_cnf" ]; then
    #configure file
    #cp ${mysql_dir}/share/mysql/my-medium.cnf /etc/my.cnf
    cp ${mysql_dir}/share/mysql/my-medium.cnf $mysql_cnf
    ${mysql_dir}/bin/mysql_install_db --user=mysql
    chown -R mysql ${mysql_dir}/var
    chgrp -R mysql ${mysql_dir}/.

    ##this setting use in Redhat/Fedora
    #cp ${mysql_dir}/share/mysql/mysql.server /etc/init.d/mysql
    #chmod 755 /etc/init.d/mysql
    #chkconfig --level 345 mysql on
    cp ${mysql_dir}/share/mysql/mysql.server ${mysql_dir}/bin/  

    ld_so_conf=`cat /etc/ld.so.conf | grep mysql | wc -l`
    profile_mysql_bin=`cat /etc/profile | grep mysql |wc -l`
    if [ $ld_so_conf = 0 ];then
        echo "export PATH=\$PATH:${mysql_dir}/bin" >> /etc/profile
        source /etc/profile
    fi

    if [ $profile_mysql_bin = 0 ];then
        echo "${mysql_dir}/lib/mysql" >> /etc/ld.so.conf
        echo "${local_lib_dir}/lib" >> /etc/ld.so.conf
        ldconfig
    fi
    ln -s ${mysql_dir}/lib/mysql /usr/lib/mysql
    ln -s ${mysql_dir}/include/mysql /usr/include/mysql

    ln -s ${mysql_dir}/lib/mysql ${local_lib_dir}/lib/mysql
    ln -s ${mysql_dir}/include/mysql ${local_lib_dir}/include/mysql
    
    if test $auto_start_server -eq 1; then
        #Starting MySQL Server
        echo "String MySQL Server..."
        ${mysql_dir}/bin/mysql.server start
        ps auxx | grep mysql
    fi
        
    ##This run mode in Redhat/Fedora
    #service mysql start
    
    echo "Start MySQL Server use commond: ${mysql_dir}/bin/mysql.server start"
    echo "Install MySQL Server OK."
else
    echo "MySQL Server already installed!"
fi
}


##########################
#
# Uninstall MySQL Server
#
##########################
function remove_mysql
{
if [ -d ${mysql_dir} ]; then
    echo "Stop mysql demon"
    ${mysql_dir}/bin/mysql.server stop
    #pkill mysql > /dev/null 2>&1

    echo "clean mysql from PATH"
    sed -i '/export PATH=\/usr\/local\/mysql\/bin:$PATH/d' /etc/profile 

    echo "close service"
    ${mysql_dir}/share/mysql/mysql.server stop
    #chkconfig mysql off 
    #rm -f /etc/init.d/mysql

    echo "remove mysql source dir"
    rm -rf ${mysql_dir}

    echo "remove mysql user"
    sed -i '/^mysql/d' /etc/group
    sed -i '/^mysql/d' /etc/passwd
    userdel mysql
    groupdel mysql

    echo "Remove MySQL Server OK"
fi
}


##########################
#
# Install PHP & php-fpm
#
##########################
function install_php
{

#install mcrypt ##
cd $packages
_decompress_file $lib_libmcrypt_file
cd $g_dir
./configure --prefix=${local_lib_dir}
make && make install
/sbin/ldconfig
cd libltdl
./configure --enable-ltdl-install --prefix=${local_lib_dir}
make && make install
##install mhash ##
cd $packages
_decompress_file $lib_mhash_file
cd $g_dir
./configure --prefix=${local_lib_dir}
make && make install && cd $packages

##make symbol link ##
ln -s ${local_lib_dir}/lib/libmcrypt.la /usr/lib/libmcrypt.la
ln -s ${local_lib_dir}/lib/libmcrypt.so /usr/lib/libmcrypt.so
ln -s ${local_lib_dir}/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
ln -s ${local_lib_dir}/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
ln -s ${local_lib_dir}/lib/libmhash.a /usr/lib/libmhash.a
ln -s ${local_lib_dir}/lib/libmhash.la /usr/lib/libmhash.la
ln -s ${local_lib_dir}/lib/libmhash.so /usr/lib/libmhash.so
ln -s ${local_lib_dir}/lib/libmhash.so.2 /usr/lib/libmhash.so.2
ln -s ${local_lib_dir}/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
ln -s ${local_lib_dir}/bin/libmcrypt-config /usr/bin/libmcrypt-config
ln -s /usr/lib/libltdl.so.7 /usr/lib/libltdl.so.3



### install libevent lib ##
##cd $packages
##_install_lib $lib_libevent_file
#
### install libmemcached lib ##
#if [ -d $memcached_dir ]; then
#    cd $packages 
#    _decompress_file $lib_libmemcached_file
#    cd $g_dir
#    ./configure --prefix=${local_lib_dir}  \
#    --with-memcached=${memcached_dir}  --with-libevent-prefix=${local_lib_dir}
#    make && make install && cd $packages
#fi
#
### common install lib ###
#_lib_array=(
#   $lib_mcrypt_file
#   $lib_curl_file
#   $lib_iconv_file
#   $lib_zlib_file
#   $lib_xml_file
#   $lib_xslt_file
#   $lib_freetype_file
#   $lib_jpeg_file
#   $lib_png_file   
#   $lib_imagemagick_file   
#)
#len=${#_lib_array[*]}
#i=0
#while [ $i -lt $len ]
#do
#   _libf=${_lib_array[i]}  
#   _install_lib $_libf 
#   i=$(($i+1))
#done

_install_lib $lib_mcrypt_file
_install_lib $lib_curl_file
_install_lib $lib_iconv_file
_install_lib $lib_zlib_file
_install_lib $lib_xml_file
_install_lib $lib_xslt_file
_install_lib $lib_freetype_file
_install_lib $lib_jpeg_file
_install_lib $lib_png_file
#_install_lib $lib_imagemagick_file


### link ImageMagick so
#ln -s ${local_lib_dir}/lib/libMagick++.a /usr/lib/libMagick++.a
#ln -s ${local_lib_dir}/lib/libMagickCore.a /usr/lib/libMagickCore.a
#ln -s ${local_lib_dir}/lib/libMagickCore.la /usr/lib/libMagickCore.la
#ln -s ${local_lib_dir}/lib/libMagickCore.so /usr/lib/libMagickCore.so
#ln -s ${local_lib_dir}/lib/libMagickCore.so.5 /usr/lib/libMagickCore.so.5
#ln -s ${local_lib_dir}/lib/libMagickCore.so.5.0.0 /usr/lib/libMagickCore.so.5.0.0
#ln -s ${local_lib_dir}/lib/libMagick++.la /usr/lib/libMagick++.la
#ln -s ${local_lib_dir}/lib/libMagick++.so /usr/lib/libMagick++.so
#ln -s ${local_lib_dir}/lib/libMagick++.so.5 /usr/lib/libMagick++.so.5
#ln -s ${local_lib_dir}/lib/libMagick++.so.5.0.0 /usr/lib/libMagick++.so.5.0.0
#ln -s ${local_lib_dir}/lib/libMagickWand.a /usr/lib/libMagickWand.a
#ln -s ${local_lib_dir}/lib/libMagickWand.la /usr/lib/libMagickWand.la
#ln -s ${local_lib_dir}/lib/libMagickWand.so /usr/lib/libMagickWand.so
#ln -s ${local_lib_dir}/lib/libMagickWand.so.5 /usr/lib/libMagickWand.so.5
#ln -s ${local_lib_dir}/lib/libMagickWand.so.5.0.0 /usr/lib/libMagickWand.so.5.0.0
#
### link ImageMagick header file
#ln -s ${local_lib_dir}/include/ImageMagick/magick /usr/include/magick
#ln -s ${local_lib_dir}/include/ImageMagick/Magick++ /usr/include/Magick++
#ln -s ${local_lib_dir}/include/ImageMagick/Magick++.h /usr/include/Magick++.h
#ln -s ${local_lib_dir}/include/ImageMagick/wand /usr/include/wand


#------------------------
#  install PHP core
#------------------------
cd $packages
_decompress_file $srv_php_file
gzip -cd ${srv_php_fpm_file} | patch -d $g_curr_dir -p1
cd $g_dir
#./buildconf --force
./configure --prefix=${php_dir}  \
            --with-config-file-path=${php_dir}/etc  \
            --with-mysql=${mysql_dir}   \
            --with-mysqli=${mysql_dir}/bin/mysql_config   \
            --with-iconv-dir=${local_lib_dir}  \
            --with-freetype-dir=${local_lib_dir}  \
            --with-jpeg-dir=${local_lib_dir}   \
            --with-png-dir=${local_lib_dir}  \
            --with-zlib=${local_lib_dir}  \
            --with-libxml-dir==${local_lib_dir}  \
            --with-curl=${local_lib_dir}  \
            --with-curlwrappers \
            --with-mcrypt=${local_lib_dir}  \
            --with-mhash=${local_lib_dir}  \
            --with-gd  \
            --with-xmlrpc  \
            --enable-gd-native-ttf  \
            --enable-xml   \
            --enable-mbstring  \
            --enable-mbregex  \
            --enable-fastcgi   \
            --enable-fpm  \
            --enable-force-cgi-redirect  \
            --enable-pcntl   \
            --enable-sockets  \
            --enable-zip  \
            --enable-ftp \
            --enable-discard-path  \
            --enable-safe-mode  \
            --enable-bcmath   \
            --enable-shmop  \
            --enable-sysvsem  \
            --enable-inline-optimization  \
            --disable-rpath 
            
make ZEND_EXTRA_LIBS='-liconv'
make install
cp php.ini-dist ${php_ini}
cd ..
cp php-fpm.conf ${php_dir}/etc/

if test $auto_start_server -eq 1; then
    echo "Starting PHP-FPM..."
    ulimit -SHn 65535
    ${php_dir}/sbin/php-fpm restart
    ps auxx | grep php
fi
echo "!!Notice: Don't use root user start php-fpm!!"
echo "PHP-FPM start command: ${php_dir}/sbin/php-fpm start"
echo "PHP core Installed OK."
}


##########################
#
# Install PHP Extensions
#
##########################
function install_php_ext
{
if [ ! -d ${php_dir} ]; then
    echo "Func[install_php_ext] error: ${php_dir} dir not exist."
    exit
    #return -1
fi

##copy php.ini to target ##
cd $packages
cp php.ini  ${php_ini}

## intall memcache ext ##
cd $packages
_decompress_file $ext_memcache_file
cd $g_curr_dir
${php_dir}/bin/phpize
./configure --with-php-config=${php_dir}/bin/php-config
make && make install
sed -i 's/^;extension = "memcache.so"/extension = "memcache.so"/' ${php_ini}

## intall libmemcached ext ##
if [ -d $memcached_dir ]; then
    cd $packages
    _decompress_file $ext_libmemcached_file
    cd $g_curr_dir
    ${php_dir}/bin/phpize
    ./configure --with-php-config=${php_dir}/bin/php-config \
                --with-memcached=$memcached_dir \
                --with-libmemcached-dir=${local_lib_dir} \
                --enable-memcached
    
    make && make install
    sed -i 's/^;extension = "memcached.so"/extension = "memcached.so"/' ${php_ini}
fi

#-------------------------------
## install pdo_mysql (current cancel) ##
#tar zxvf PDO_MYSQL-1.0.2.tgz
#cd PDO_MYSQL-1.0.2
#${php_dir}/bin/phpize
#./configure --with-php-config=${php_dir}/bin/php-config  --with-pdo-mysql=${mysql_dir}
#make && make install && cd $packages

#cd $packages
#tar zxvf ImageMagick-6.7.5-8.tar.gz
#cd ImageMagick-6.7.5-8
#./configure --prefix=/usr/local/ImageMagick
#make && make install && cd $packages
##_install_lib $lib_imagemagick_file
#-------------------------------

### install imagick ext ##
#cd $packages
#_decompress_file $ext_imagick_file
#cd $g_dir
#${php_dir}/bin/phpize
#./configure --with-imagick=${local_lib_dir} --with-php-config=${php_dir}/bin/php-config
##./configure --with-imagick=/usr/local/ImageMagick --with-php-config=${php_dir}/bin/php-config
#make && make install
#sed -i 's/^;extension = "imagick.so"/extension = "imagick.so"/' ${php_ini}


## install eacc ext ##
cd $packages
_decompress_file $ext_eacc_file
cd $g_dir
${php_dir}/bin/phpize
./configure --enable-eaccelerator=shared  --with-php-config=${php_dir}/bin/php-config
make && make install

mkdir -p /tmp/eaccelerator_cache
eacc=`grep 'eaccelerator' ${php_ini} |wc -l`
if [ $eacc = 0 ];then
cat >> ${php_ini} <<EOF
[eaccelerator]
zend_extension="${php_dir}/lib/php/extensions/no-debug-non-zts-20060613/eaccelerator.so"
eaccelerator.shm_size="16"
eaccelerator.cache_dir="/tmp/eaccelerator_cache"
eaccelerator.enable="1"
eaccelerator.optimizer="1"
eaccelerator.check_mtime="1"
eaccelerator.debug="0"
eaccelerator.filter=""
eaccelerator.shm_max="0"
eaccelerator.shm_ttl="3600"
eaccelerator.shm_prune_period="3600"
eaccelerator.shm_only="0"
eaccelerator.compress="1"
eaccelerator.compress_level="9"
EOF
fi

## create user and dir ##
groupadd www
useradd -g www www
mkdir -p /home/www
chmod +w /home/www
mkdir -p /home/www/logs
chmod 777 /home/www/logs
chown -R www:www /home/www
chmod 777 ${php_dir}/logs/php-fpm.log

## start php-fpm ##
if test $auto_start_server -eq 1; then
    echo "Starting PHP-FPM..."
    ulimit -SHn 65535
    ${php_dir}/sbin/php-fpm restart
    ps auxx | grep php
fi

echo "!!Notice: Don't use root user start php-fpm!!"
echo "PHP-FPM start command: ${php_dir}/sbin/php-fpm start"
echo "PHP Extensions Installed ok"
}


##########################
#
# Remove PHP all
#
##########################
function remove_php
{
if [ -d ${php_dir} ];then
    echo "Stop php-fpm..."
    ${php_dir}/sbin/php-fpm stop

    echo "Remove php source..."
    rm -rf ${php_dir}
fi
echo "Remove PHP all ok."
}


##########################
#
# Install Nginx
#
##########################
function install_nginx
{
##add user
groupadd www
useradd -g www www
mkdir -p /home/www
chmod +w /home/www
mkdir -p /home/www/logs
chmod 777 /home/www/logs
chown -R www:www /home/www

##install pcre lib
cd $packages
_decompress_file $lib_pcre_file
_tmp_pcre_dir=$g_dir
#cd pcre-8.30
#./configure --prefix=${local_lib_dir}
#make && make install

cd $packages
_decompress_file $srv_nginx_file
cd $g_dir
./configure --user=www \
            --group=www \
            --prefix=${nginx_dir}  \
            --with-pcre=$_tmp_pcre_dir \
            --with-http_stub_status_module \
            --with-http_ssl_module  \
            --with-http_gzip_static_module 
            
make && make install
cd ../

mv ${nginx_dir}/conf/nginx.conf ${nginx_dir}/conf/nginx.conf.old
cp -f nginx.conf ${nginx_dir}/conf/nginx.conf

if test $auto_start_server -eq 1; then
echo "Starting Nginx..."
ulimit -SHn 65535
${nginx_dir}/sbin/nginx
ps auxx | grep nginx
fi

echo "Nginx start command: ${nginx_dir}/sbin/nginx"
echo "Install Nginx OK."
}



##########################
#
# Remove Nginx all
#
##########################
function remove_nginx
{
if [ -d ${nginx_dir} ];then
    echo "Stop Nginx..."
    ${nginx_dir}/sbin/nginx -s stop

    echo "Remove Nginx source..."
    rm -rf ${nginx_dir}
fi
echo "Remove Nginx ok."
}



##########################
#
# Install Memcached
#
##########################
function install_memcached
{
## install libevent lib ##
cd $packages
_install_lib $lib_libevent_file 

## install memcached srv ##
cd $packages
_decompress_file $srv_memcached_file
cd $g_dir
./configure --prefix=${memcached_dir}  --with-libevent=${local_lib_dir}
make && make install

## start memcached ##
if test $auto_start_server -eq 1; then
    echo "Starting Memcached..."
    ulimit -SHn 65535
    ${memcached_dir}/bin/memcached -d
    ps auxx | grep memcached
fi
echo "Memcached start command: ${memcached_dir}/bin/memcached -d -p 11211 -m 32"
echo "Memcached install OK"
}

##########################
#
# Remove Memcached 
#
##########################
function remove_memcached
{
if [ -d ${memcached_dir} ];then
    echo "Stop Memcached..."
    killall memcached

    echo "Remove Memcached source..."
    rm -rf ${memcached_dir}
fi
echo "Remove Memcached ok."
}


##########################
#
#  Install All server
#
##########################
function install_all
{
echo -n "Are you confirm install all server [y|n]: "
read confirm
if [ "$confirm" = "y" ]; then
    download_soft
    install_memcached
    install_mysql
    install_php
    install_php_ext
    install_nginx
else
    echo "Cancel install all server."
fi 

}

##########################
#
#  Remove All server
#
##########################
function remove_all
{
echo -n "Are you confirm remove all server[y|n]: "
read confirm
if [ "$confirm" = "y" ]; then
    remove_mysql
    remove_php
    remove_nginx
    remove_memcached
else
    echo "Cancel remove all server."
fi
}



##########################
#
#  Help Menu
#
##########################
function help
{
echo -e '
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
Usage Example: \n
lnmp_install.sh dl
lnmp_install.sh all
lnmp_install.sh mysql
lnmp_install.sh php
lnmp_install.sh php_ext
lnmp_install.sh nginx   
===============================================
'
}




##########################
#
#  Main runtime
#
##########################

## export lib path
echo 'export LD_LIBRARY_PATH="${local_lib_dir}"/lib' >> ~/.bash_profile
source ~/.bash_profile

## option
case $1 in
#### long option ####
download_soft) download_soft;;
install_mysql) install_mysql;;
remove_mysql) remove_mysql;; 
install_php) install_php;;
install_php_ext) install_php_ext;;
remove_php) remove_php;;
install_nginx) install_nginx;;
remove_nginx) remove_nginx;;
install_memcached) install_memcached;;
remove_memcached) remove_memcached;;
install_all) install_all;;
remove_all) remove_all;;

##### short option ####
dl) download_soft;;
mysql) install_mysql;;
rm_mysql) remove_mysql;; 
php) install_php;;
php_ext) install_php_ext;;
rm_php) remove_php;;
nginx) install_nginx;;
rm_nginx) remove_nginx;;
memcached) install_memcached;;
rm_memcached) remove_memcached;;
all) install_all;;
rm_all) remove_all;;

h) help;;
help) help;;
*) help;;
    
esac


