
## ========================================= ##
# 
#  heiyeluren Nginx&PHP 环境搭建脚本文档
#
#  @author:     heiyeluren
#  @version:    v1.1.0
#  @created:    2017/7/21
#  @lastmodify: 2018/01/24
#				2021/7/10
# 
## ========================================= ##


##
# 安装说明:
# 本安装必须依赖于基准环境的基础之上来进行, 所有相关账户权限目录等体系都是基于基准环境来进行的.
# 
# 系统要求: CentOS7.x 64bit/2核/4G内存/100G硬盘  (最低配置)
# 目录权限: 主目录 /home/work, 账户: work/work, 所有权限都是依赖该用户和权限进行，切记
# 包依赖: 基准环境的各类基础包依赖
##

##
# 基本高性能Linux环境安装脚本参考：https://github.com/heiyeluren/heiyeluren-tools/tree/master/linux-env-init
#
#
##



## 一、构建基本环境 

## 说明: (如果基本用户系统没有构建必须完成，如果是基于基准环境，这些操作可以不用)

# 1. 创建基本用户 (如果初始化环境操作了可以跳过)
# if [ $USER != "root" ]; then  su root; fi
# useradd -d /home/work -p YhsbjCfcys work
# groupadd  work -g 500 ; useradd work -u 500 -g 500 -d /home/work -p YhsbjCfcys
# groupadd  rd   -g 501 ; useradd rd   -u 501 -g 501 -d /home/rd -p YhsbjCfcys


# 2. 创建基本目录 (如果初始化进行了可以跳过本操作)
if [ $USER != "work" ]; then  su work; fi
mkdir -p /home/work/lib
mkdir -p /home/work/soft
mkdir -p /home/work/logs
mkdir -p /home/work/data
mkdir -p /home/work/tmp
mkdir -p /home/work/opbin
mkdir -p /home/work/www
mkdir -p /home/work/www/code
mkdir -p /home/work/www/run


# 3. 设置环境使用指定lib目录（非必须，参考设置）
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/work/lib
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/work/lib" >> ~/.bash_profile
echo "export LD_LIBRARY_PATH" >> ~/.bash_profile
source ~/.bash_profile




## 二、下载相关软件

if [ $USER != "work" ]; then  su work; fi
cd /home/work/soft


## 注意1：以下步骤如果该服务器不可用，可以直接按照上面软件列表的指令一个个下载 ##
## 注意2：这个版本可能不够新，建议稳妥起见最好是直接按照提供的下载命令一个个下载 ##
## 资源站1： http://pkgs.fedoraproject.org/repo/pkgs
## 资源站2：http://www.mirrorservice.org/sites/
## 资源站3：http://download.openpkg.org/components/cache/
## 资源站4：http://www.mirrorservice.org/sites/distfiles.macports.org/
## 资源站5：https://jaist.dl.sourceforge.net/project

# 统计下总共软件总数
#cd /home/work/soft && ls -l | wc -l

#说明：如果最终统计出来是30+个则是都下载完整了 #

######## 一个个单独下载软件指令（路径可能失效，自行升级新路径） #########

if [ $USER != "work" ]; then  su work; fi
cd /home/work/soft

# 基础软件 #
if [ ! -f openresty-1.13.6.1.tar.gz ]; then  wget https://openresty.org/download/openresty-1.13.6.1.tar.gz ; fi
if [ ! -f php-5.6.33.tar.gz ]; then rm -f mirror; wget http://mirrors.sohu.com/php/php-5.6.33.tar.gz; fi
if [ ! -f php-7.1.13.tar.gz ]; then rm -f mirror; wget http://mirrors.sohu.com/php/php-7.1.13.tar.gz; fi
if [ ! -f mysql-5.6.36.tar.gz ]; then  wget http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.36.tar.gz; fi 
if [ ! -f postgresql-9.6.6.tar.gz ]; then wget https://ftp.postgresql.org/pub/source/v9.6.6/postgresql-9.6.6.tar.gz; fi 
 
# Lib库 #
if [ ! -f pcre-8.40.tar.gz ]; then  wget https://ftp.pcre.org/pub/pcre/pcre-8.40.tar.gz; fi 
if [ ! -f libmcrypt-2.5.7.tar.gz ]; then  wget ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz; fi 
if [ ! -f mhash-0.9.9.9.tar.gz ]; then  wget  https://jaist.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz; fi 
if [ ! -f jpegsrc.v9a.tar.gz ]; then  wget http://www.ijg.org/files/jpegsrc.v9a.tar.gz; fi 
if [ ! -f libjpeg-turbo-1.4.2.tar.gz ]; then  wget https://jaist.dl.sourceforge.net/project/libjpeg-turbo/1.4.2/libjpeg-turbo-1.4.2.tar.gz; fi 
if [ ! -f libpng-1.6.34.tar.gz ]; then  wget https://jaist.dl.sourceforge.net/project/libpng/libpng16/1.6.34/libpng-1.6.34.tar.gz; fi 
if [ ! -f giflib-5.1.3.tar.gz ]; then  wget https://jaist.dl.sourceforge.net/project/giflib/giflib-5.1.3.tar.gz; fi 
if [ ! -f tiff-4.0.4.tar.gz ]; then  wget http://download.osgeo.org/libtiff/tiff-4.0.4.tar.gz; fi 
if [ ! -f libwebp-0.5.0.tar.gz ]; then  wget http://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-0.5.0.tar.gz; fi 
if [ ! -f ImageMagick-6.9.7-10.tar.xz ]; then  wget https://www.imagemagick.org/download/releases/ImageMagick-6.9.7-10.tar.xz; fi 
if [ ! -f GraphicsMagick-1.3.24.tar.gz ]; then  wget  http://ftp.icm.edu.pl/pub/unix/graphics/GraphicsMagick/1.3/GraphicsMagick-1.3.24.tar.xz; fi 
if [ ! -f libmemcached-1.0.18.tar.gz ]; then  wget https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz; fi 
if [ ! -f gearmand-1.1.12.tar.gz ]; then  wget https://github.com/ButoVideo/gearmand-latest/archive/master.zip && unzip master.zip && mv gearmand-latest-master/*.gz . && rm -rf gearmand-latest-master && rm -f master.zip ;  fi 
if [ ! -f libdatrie-r_0_2_9.zip ]; then  wget https://github.com/Timandes/libdatrie/archive/r_0_2_9.zip && mv r_0_2_9.zip libdatrie-r_0_2_9.zip; fi 
if [ ! -f librdkafka-0.11.0.zip ]; then   wget https://github.com/edenhill/librdkafka/archive/v0.11.0.zip && mv v0.11.0.zip librdkafka-0.11.0.zip; fi 
if [ ! -f rabbitmq-c-0.8.0.zip ]; then  wget https://github.com/alanxz/rabbitmq-c/archive/v0.8.0.zip && mv v0.8.0.zip rabbitmq-c-0.8.0.zip; fi 
if [ ! -f fastdfs-5.08.zip ]; then  wget https://github.com/happyfish100/fastdfs/archive/V5.08.zip && mv V5.08.zip fastdfs-5.08.zip; fi
if [ ! -f libfastcommon-1.0.35.zip ]; then wget https://github.com/happyfish100/libfastcommon/archive/V1.0.35.zip && mv V1.0.35.zip libfastcommon-1.0.35.zip; fi
if [ ! -f opencc-1.0.5.zip ]; then  wget https://github.com/BYVoid/OpenCC/archive/ver.1.0.5.zip && mv ver.1.0.5.zip opencc-1.0.5.zip; fi



# PHP 5/7公用扩展 #
if [ ! -f memcached-2.2.0.tgz ]; then  wget http://pecl.php.net/get/memcached-2.2.0.tgz; fi 
if [ ! -f imagick-3.4.3.tgz ]; then  wget http://pecl.php.net/get/imagick-3.4.3.tgz; fi 
if [ ! -f gmagick-1.1.7RC3.tgz ]; then  wget http://pecl.php.net/get/gmagick-1.1.7RC3.tgz; fi 
if [ ! -f redis-2.2.8.tgz ]; then  wget http://pecl.php.net/get/redis-2.2.8.tgz; fi 
if [ ! -f redis-3.1.3.tgz ]; then  wget http://pecl.php.net/get/redis-3.1.3.tgz; fi 
if [ ! -f mongo-1.6.14.tgz ]; then  wget http://pecl.php.net/get/mongo-1.6.14.tgz; fi 
if [ ! -f mongodb-1.2.9.tgz ]; then  wget http://pecl.php.net/get/mongodb-1.2.9.tgz; fi 
if [ ! -f gearman-1.1.2.tgz ]; then   wget http://pecl.php.net/get/gearman-1.1.2.tgz; fi 
if [ ! -f memcache-3.0.8.tgz ]; then  wget http://pecl.php.net/get/memcache-3.0.8.tgz; fi 
if [ ! -f SeasLog-1.6.9.tgz ]; then  wget http://pecl.php.net/get/SeasLog-1.6.9.tgz; fi 
if [ ! -f yaf-2.3.5.tgz ]; then  wget http://pecl.php.net/get/yaf-2.3.5.tgz; fi 
if [ ! -f msgpack-0.5.7.tgz ]; then  wget http://pecl.php.net/get/msgpack-0.5.7.tgz; fi 
if [ ! -f protobuf-3.3.2.tgz ]; then  wget http://pecl.php.net/get/protobuf-3.3.2.tgz; fi 
if [ ! -f swoole-1.8.13.tgz ]; then  wget http://pecl.php.net/get/swoole-1.8.13.tgz; fi 
if [ ! -f swoole-1.9.23.tgz ]; then  wget http://pecl.php.net/get/swoole-1.9.23.tgz; fi 
if [ ! -f swoole-2.0.12.tgz ]; then  wget http://pecl.php.net/get/swoole-2.0.12.tgz; fi 
if [ ! -f grpc-1.1.0.tgz ]; then  wget http://pecl.php.net/get/grpc-1.1.0.tgz; fi
if [ ! -f geoip-1.1.1.tgz ]; then  wget http://pecl.php.net/get/geoip-1.1.1.tgz; fi
if [ ! -f apcu-4.0.11.tgz ]; then  wget http://pecl.php.net/get/apcu-4.0.11.tgz; fi
if [ ! -f rdkafka-3.0.4.tgz ]; then  wget http://pecl.php.net/get/rdkafka-3.0.4.tgz; fi
if [ ! -f amqp-1.9.1.tgz ]; then  wget http://pecl.php.net/get/amqp-1.9.1.tgz; fi
if [ ! -f stomp-1.0.9.tgz ]; then  wget http://pecl.php.net/get/stomp-1.0.9.tgz; fi
if [ ! -f igbinary-2.0.1.tgz ]; then  wget http://pecl.php.net/get/igbinary-2.0.1.tgz; fi
if [ ! -f xdebug-2.5.5.tgz ]; then  wget http://pecl.php.net/get/xdebug-2.5.5.tgz; fi
if [ ! -f xhprof-0.9.4.tgz ]; then  wget http://pecl.php.net/get/xhprof-0.9.4.tgz; fi
if [ ! -f php-ext-trie-filter-master.zip ]; then  wget https://github.com/wulijun/php-ext-trie-filter/archive/master.zip && mv master.zip php-ext-trie-filter-master.zip; fi
if [ ! -f opencc4php.zip ]; then  wget https://github.com/NauxLiu/opencc4php/archive/master.zip && mv master.zip opencc4php.zip; fi
if [ ! -f trace-1.0.1beta.tgz ]; then  wget http://pecl.php.net/get/trace-1.0.1beta.tgz; fi

# PHP5独有扩展 #
if [ ! -f yar-1.2.5.tgz ]; then  wget http://pecl.php.net/get/yar-1.2.5.tgz; fi 
if [ ! -f php-zbarcode-master.zip ]; then wget https://github.com/mkoppanen/php-zbarcode/archive/master.zip && mv master.zip php-zbarcode-master.zip; fi


# PHP7 独有扩展 #
if [ ! -f phpredis-php7.zip ]; then  wget https://github.com/phpredis/phpredis/archive/php7.zip; mv php7.zip phpredis-php7.zip; fi
if [ ! -f gmagick-2.0.4RC1.tgz ]; then  wget http://pecl.php.net/get/gmagick-2.0.4RC1.tgz; fi 
if [ ! -f php-memcached-3.0.3.zip ]; then  wget https://github.com/php-memcached-dev/php-memcached/archive/v3.0.3.zip && mv v3.0.3.zip php-memcached-3.0.3.zip; fi 
if [ ! -f pecl-gearman-php7-master.zip ]; then   wget https://github.com/bymaximus/pecl-gearman-php7/archive/master.zip && mv master.zip pecl-gearman-php7-master.zip; fi 
if [ ! -f yaf-3.0.5.tgz ]; then  wget http://pecl.php.net/get/yaf-3.0.5.tgz; fi 
if [ ! -f yar-2.0.3.tgz ]; then  wget http://pecl.php.net/get/yar-2.0.3.tgz; fi 
if [ ! -f msgpack-2.0.2.tgz ]; then  wget http://pecl.php.net/get/msgpack-2.0.2.tgz; fi 
if [ ! -f php-protobuf-php7.zip ]; then  wget https://github.com/serggp/php-protobuf/archive/php7.zip &&  mv php7.zip php-protobuf-php7.zip; fi 
if [ ! -f stomp-2.0.1.tgz ]; then  wget http://pecl.php.net/get/stomp-2.0.1.tgz; fi
if [ ! -f grpc-1.4.1.tgz ]; then  wget http://pecl.php.net/get/grpc-1.4.1.tgz; fi
if [ ! -f apcu-5.1.8.tgz ]; then  wget http://pecl.php.net/get/apcu-5.1.8.tgz; fi
if [ ! -f xhprof-php7.zip ]; then  wget https://github.com/RustJason/xhprof/archive/php7.zip && mv php7.zip xhprof-php7.zip; fi
if [ ! -f yaconf-1.0.6.tgz ]; then  wget http://pecl.php.net/get/yaconf-1.0.6.tgz; fi 


# ngx_lua扩展
if [ ! -f ngx_lua_waf-master.zip ]; then  wget https://github.com/loveshell/ngx_lua_waf/archive/master.zip && mv master.zip ngx_lua_waf-master.zip ; fi;
if [ ! -f ngx_cache_purge-2.3.zip ]; then  wget https://github.com/FRiCKLE/ngx_cache_purge/archive/2.3.zip &&  mv 2.3.zip ngx_cache_purge-2.3.zip; fi;

# 默认配置文件 （配置文件下载存储在 /home/work/soft/conf 目录）
mkdir -p /home/work/soft/conf && cd /home/work/soft/conf && rm *.conf* && rm *.ini && rm *conf.example
if [ ! -f nginx.conf ]; then  wget https://raw.githubusercontent.com/heiyeluren/heiyeluren-tools/master/lnmp-install-2.0/conf/heiyeluren-nginx.conf; fi
if [ ! -f heiyeluren-vhost-laravel.conf.example ]; then  wget https://raw.githubusercontent.com/heiyeluren/heiyeluren-tools/master/lnmp-install-2.0/conf/heiyeluren-vhost-laravel.conf.example; fi
if [ ! -f heiyeluren-vhost-yaf.conf.example ]; then  wget https://raw.githubusercontent.com/heiyeluren/heiyeluren-tools/master/lnmp-install-2.0/conf/heiyeluren-vhost-yaf.conf.example; fi
if [ ! -f heiyeluren-http-proxy.conf.example ]; then  wget https://raw.githubusercontent.com/heiyeluren/heiyeluren-tools/master/lnmp-install-2.0/conf/heiyeluren-http-proxy.conf.example; fi
if [ ! -f heiyeluren-stream.conf.example ]; then  wget https://raw.githubusercontent.com/heiyeluren/heiyeluren-tools/master/lnmp-install-2.0/conf/heiyeluren-stream.conf.example; fi
if [ ! -f heiyeluren-php5.6.ini ]; then  wget https://raw.githubusercontent.com/heiyeluren/heiyeluren-tools/master/lnmp-install-2.0/conf/heiyeluren-php5.6.ini; fi
if [ ! -f heiyeluren-php5.6-fpm.conf ]; then  wget https://raw.githubusercontent.com/heiyeluren/heiyeluren-tools/master/lnmp-install-2.0/conf/heiyeluren-php5.6-fpm.conf; fi
if [ ! -f heiyeluren-php5.6-fpm.www.conf ]; then  wget https://raw.githubusercontent.com/heiyeluren/heiyeluren-tools/master/lnmp-install-2.0/conf/heiyeluren-php5.6-fpm.www.conf; fi
if [ ! -f heiyeluren-php7.1.ini ]; then  wget https://raw.githubusercontent.com/heiyeluren/heiyeluren-tools/master/lnmp-install-2.0/conf/heiyeluren-php7.1.ini; fi
if [ ! -f heiyeluren-php7.1-fpm.conf ]; then  wget https://raw.githubusercontent.com/heiyeluren/heiyeluren-tools/master/lnmp-install-2.0/conf/heiyeluren-php7.1-fpm.conf; fi
if [ ! -f heiyeluren-php7.1-fpm.www.conf ]; then  wget https://raw.githubusercontent.com/heiyeluren/heiyeluren-tools/master/lnmp-install-2.0/conf/heiyeluren-php7.1-fpm.www.conf; fi



## 三. Nginx 安装

if [ $USER != "work" ]; then  su work; fi

#创建相应目录
mkdir -p /home/work/logs/nginx
mkdir -p /home/work/nginx && cd /home/work/nginx
for i in conf conf/ssl conf/vhost lua var var/client_temp var/proxy_temp var/fastcgi_temp var/uwsgi_temp var/scgi_temp var/fastcgi_cache ; do
    mkdir -p $i
done


# 解压OpenResty
cd /home/work/soft
tar zxvf openresty-1.13.6.1.tar.gz

# 解压扩展
cd /home/work/soft
unzip -o ngx_cache_purge-2.3.zip


# 配置编译安装
##说明：pcre 需要nginx支持utf8的一些选项，需要单独增加这两个，但是目前版本编译会报错，先记录： --enable-utf8  --enable-unicode-properties",使用默认yum安装pcre忽略本问题
cd /home/work/soft && cd openresty-1.13.6.1

#修改openresty/nginx的服务器标识，更安全
cd bundle/nginx-1.11.2/src && sed -i "s/openresty/heiyeluren-server/" http/ngx_http_header_filter_module.c &&  sed -i "s/openresty/heiyeluren-server/" core/nginx.h

#配置编译
cd /home/work/soft && cd openresty-1.13.6.1
./configure  --prefix=/home/work/nginx  --sbin-path=/home/work/nginx/sbin/nginx  --conf-path=/home/work/nginx/conf/nginx.conf  --pid-path=/home/work/nginx/var/nginx.pid  --lock-path=/home/work/nginx/var/nginx.lock  --error-log-path=/home/work/logs/nginx/error.log  --http-log-path=/home/work/logs/nginx/access.log  --http-client-body-temp-path=/home/work/nginx/var/client_temp  --http-proxy-temp-path=/home/work/nginx/var/proxy_temp  --http-fastcgi-temp-path=/home/work/nginx/var/fastcgi_temp  --http-uwsgi-temp-path=/home/work/nginx/var/uwsgi_temp  --http-scgi-temp-path=/home/work/nginx/var/scgi_temp  --user=work  --group=work  --with-file-aio  --with-threads  --with-ipv6  --with-http_realip_module  --with-http_auth_request_module  --with-http_dav_module  --with-http_flv_module  --with-http_gunzip_module  --with-http_gzip_static_module  --with-http_mp4_module  --with-http_random_index_module  --with-http_realip_module  --with-http_secure_link_module  --with-http_slice_module  --with-http_ssl_module  --with-http_stub_status_module  --with-http_sub_module  --with-http_v2_module  --with-mail  --with-mail_ssl_module  --with-stream  --with-stream_ssl_module  --with-cc-opt='-g  -O2  -fstack-protector  --param=ssp-buffer-size=4  -Wformat  -Werror=format-security  -Wp,-D_FORTIFY_SOURCE=2  -fPIC'  --with-ld-opt='-Wl,-Bsymbolic-functions  -Wl,-z,relro  -Wl,-z,now  -Wl,--as-needed  -pie'  --with-http_image_filter_module  --add-module=/home/work/soft/ngx_cache_purge-2.3  

make && make install 
cd /home/work/nginx && ls -lh

#
# 安装ngx_lua_waf扩展
#
mkdir -p /home/work/nginx/lua/waf && cd /home/work/soft
unzip -o ngx_lua_waf-master.zip && cd ngx_lua_waf-master && cp -rf ./* /home/work/nginx/lua/waf/
cd /home/work/nginx/lua/waf/ && cp -f config.lua config.lua.bak

# 修改 waf 默认配置
sed -i "s/\/usr\/local\/nginx\/conf\/waf\/wafconf\//\/home\/work\/nginx\/lua\/waf\/wafconf\//" /home/work/nginx/lua/waf/config.lua
sed -i "s/\/usr\/local\/nginx\/logs\/hack\//\/home\/work\/logs\/nginx\//" /home/work/nginx/lua/waf/config.lua
touch /home/work/nginx/conf/htpasswd


#
# 生成nginx和各个vhost示例配置
# 
#说明：每个配置都是精心配置的，可以参考使用，适当调整，总体来说不需要调整都可以直接使用
#
mkdir -p /home/work/nginx/conf/vhost && mkdir -p /home/work/nginx/conf/stream
cd /home/work/nginx/conf && cp nginx.conf nginx.conf.default
cd /home/work/soft/conf && cp -f heiyeluren-nginx.conf /home/work/nginx/conf/nginx.conf && cp -f heiyeluren-vhost* /home/work/nginx/conf/vhost/ && cp -f heiyeluren-http*  /home/work/nginx/conf/vhost/ && cp heiyeluren-stream*  /home/work/nginx/conf/stream
cd /home/work/nginx/conf && ls -lh && ls -lh vhost/ && ls -lh stream/


# 测试启动 (Nginx必须root账户启动, 不过最终会在work账户运行）
#root下增加s权限,这样可以直接在work账户里面启动nginx
#if [ -d /home/work/nginx/sbin ]; then
#    cd /home/work/nginx/sbin
#    chown root nginx && chmod 754 nginx && chmod +s nginx
#fi
## 说明:完成，记得修改 /home/work/nginx/conf/nginx.conf 和 /home/work/nginx/conf/vhost/下的配置文件，按照自己需要来部署虚拟机等，线上环境可以采用最后我们指定的配置 ##




## 四. 安装必备Lib库


####----------------------------
# 安装 fastdfs库的支持 (必须root账户安装, 本步骤会在基准环境里操作, 这里可以忽略)
#
# 注意:本库因为自身结构代码原因，必须采用ｒｏｏｔ账户安装，这里特别关注一下
###-----------------------------
#if [ $USER != "root" ]; then  su root; fi
#cd /home/work/soft
#unzip -o libfastcommon-1.0.35.zip && cd libfastcommon-1.0.35
#sudo ./make.sh && sudo ./make.sh install
#cd .. && rm -rf libfastcommon-1.0.35

#cd /home/work/soft
#unzip -o fastdfs-5.08.zip && cd fastdfs-5.08
#sudo ./make.sh && sudo ./make.sh install
#cd .. && rm -rf fastdfs-5.08



####----------------------------
# 以下库使用ｗｏｒｋ账户安装
###-----------------------------

if [ $USER != "work" ]; then  su work; fi

#
# 安装 pcre 正则库（Nginx/PHP需要使用）
#
cd /home/work/soft && tar zxvf pcre-8.40.tar.gz && cd pcre-8.40
./configure --prefix=/home/work/lib/  --enable-shared --enable-static  --enable-jit --enable-utf8  --enable-unicode-properties
make && make install


# 
# 安装 libmysqlclient.so 支持 （php5.6版本最好用mysql5.6版本）  ----说明: 因为后续使用mysqlnd,所以本so不需要安装,如果偶尔需要使用,默认我们系统安装了marriadb的库可以使用
#
## 注意：（如果当前服务器没有安装 MySQL Server，则需要进行如下步骤，否则可以跳过）
## 注意2：如果服务器内存低于2G，在安装到40%~50%左右的时候会报一个错误：make[2]: *** [sql/CMakeFiles/sql.dir/item_geofunc.cc.o] Error 4 
## 核心原因是因为内存不足，可以建立一个交换分区来解决问题，解决如下：
## 创建2G的交换分区
# dd if=/dev/zero of=/var/swapfile bs=1k count=2048000   #-- 获取要增加的2G的SWAP文件块
# mkswap /var/swapfile     #-- 创建SWAP文件
# swapon /var/swapfile     #-- 激活SWAP文件
# swapon -s            #-- 查看SWAP信息是否正确
#
## 出错后重新运行配置，需要删除CMakeCache.txt文件
# rm -f CMakeCache.txt
#
## 完成后重新运行下面的cmake过程
## 编译完后, 如果不想要交换分区了, 可以删除:
# swapoff /var/swapfile
# rm -fr /var/swapfile

## 判断当前机器是否安装了PHP所需要的MySQL客户端库文件
#if [ ! -f /home/work/lib/mysql/lib/libmysqlclient.so ]; then  
#cd /home/work/soft
#tar zxvf mysql-5.6.36.tar.gz && cd mysql-5.6.36
#cmake . -DCMAKE_INSTALL_PREFIX=/home/work/lib/mysql
# 或者使用cmake的方式 : cmake . && ./configure --prefix=/home/work/lib/mysql
#make && make install
#fi;


#
# 安装PostgreSQL库的依赖
#
if [ ! -f /home/work/lib/pgsql/lib/libpq.so ]; then  
cd /home/work/soft
tar zxvf postgresql-9.6.6.tar.gz && cd postgresql-9.6.6
./configure --prefix=/home/work/lib/pgsql --without-readline
make && make install
fi;


#
# 安装 libmcrypt 和 mhash 库
#
cd /home/work/soft && tar zxvf libmcrypt-2.5.7.tar.gz && cd libmcrypt-2.5.7
./configure --prefix=/home/work/lib/  --enable-shared --enable-static
make && make install

cd /home/work/soft && tar zxvf mhash-0.9.9.9.tar.gz && cd mhash-0.9.9.9
./configure --prefix=/home/work/lib/  --enable-shared --enable-static
make && make install

#
# 安装jpeg/gif/png/webp/ImageMagick/GraphicsMagick等图片处理支持
#
cd /home/work/soft
tar zxvf jpegsrc.v9a.tar.gz && cd jpeg-9a
./configure --prefix=/home/work/lib/  --enable-shared --enable-static
make && make install

cd /home/work/soft 
tar zxvf libjpeg-turbo-1.4.2.tar.gz && cd libjpeg-turbo-1.4.2
./configure  --prefix=/home/work/lib/ --enable-shared --enable-static 
make && make install

cd /home/work/soft 
tar zxvf libpng-1.6.34.tar.gz && cd libpng-1.6.34
./configure  --prefix=/home/work/lib/ --enable-shared --enable-static 
make && make install

cd /home/work/soft
tar zxvf giflib-5.1.3.tar.gz && cd giflib-5.1.3
./configure  --prefix=/home/work/lib/ --enable-shared --enable-static 
make && make install

cd /home/work/soft
tar zxvf libwebp-0.5.0.tar.gz && cd libwebp-0.5.0
./configure  --prefix=/home/work/lib/ --enable-shared --enable-static 
make && make install

cd /home/work/soft
xz -d ImageMagick-6.9.7-10.tar.xz 
tar xf ImageMagick-6.9.7-10.tar && cd ImageMagick-6.9.7-10
./configure  --prefix=/home/work/lib/ --enable-shared --enable-static 
make && make install

cd /home/work/soft
tar zxvf GraphicsMagick-1.3.24.tar.gz && cd GraphicsMagick-1.3.24
./configure  --prefix=/home/work/lib/ --enable-shared --enable-static 
make && make install

#
# 安装libmemcached支持
#
cd /home/work/soft
tar zxvf libmemcached-1.0.18.tar.gz && cd libmemcached-1.0.18
./configure --prefix=/home/work/lib/  --enable-shared --enable-static
make && make install

#
# 安装libgearmanclient支持
#
cd /home/work/soft
tar zxvf gearmand-1.1.12.tar.gz && cd gearmand-1.1.12
./configure --prefix=/home/work/lib/gearman --enable-jobserver=no --enable-shared --enable-static
make && make install

#
# 安装libdatrie支持（Double Array Trie Tree）
#
if [ $USER != "work" ]; then su work; fi
cd /home/work/soft
unzip -o libdatrie-r_0_2_9.zip && cd libdatrie-r_0_2_9
sh ./autogen.sh
./configure --prefix=/home/work/lib
make && make install

#
# 安装librabbitmq支持
#
if [ $USER != "work" ]; then su work; fi
cd /home/work/soft
unzip -o rabbitmq-c-0.8.0.zip && cd rabbitmq-c-0.8.0
cmake -DCMAKE_INSTALL_PREFIX=/home/work/lib
make && make install

#
# 安装librdkafka支持
#
cd /home/work/soft
unzip -o librdkafka-0.11.0.zip && cd librdkafka-0.11.0
./configure --prefix=/home/work/lib
make && make install

#
# 安装opencc支持
#
cd /home/work/soft
unzip -o opencc-1.0.5.zip && cd OpenCC-ver.1.0.5
cmake . -DCMAKE_INSTALL_PREFIX=/home/work/lib
make && make install




## 五. PHP 5.X 版本安装

## (1) 初始化环境
# if [ $USER != "root" ]; then  su root; fi
## 如果没有执行上面的初始化环境的yum install基础软件操作，在这里务必记得操作一下 ##

## (2) 编译必须的基础库，除了上面已初始化好的lib

## (3) 安装PHP

if [ $USER != "work" ]; then  su work; fi

#创建相应目录
mkdir -p /home/work/php/etc/pool.d && mkdir -p /home/work/logs/php && mkdir -p /home/work/php/etc/php.d

#
# 编译PHP引擎
#
cd /home/work/soft
tar zxvf php-5.6.33.tar.gz && cd php-5.6.33
./configure --prefix=/home/work/php --with-config-file-path=/home/work/php/etc/ --with-config-file-scan-dir=/home/work/php/etc/php.d --with-libxml-dir=/home/work/lib --with-pgsql=/home/work/lib/pgsql --with-pdo-pgsql=/home/work/lib/pgsql  --with-jpeg-dir=/home/work/lib --with-png-dir=/usr/lib64  --with-freetype-dir --with-mhash=/home/work/lib --with-mcrypt=/home/work/lib --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-openssl --with-gd  --enable-gd-native-ttf --with-gettext --with-zlib --with-pcre-regex --with-xmlrpc --with-xsl --with-iconv --with-zlib --with-bz2 --with-gmp --with-curl --enable-mbstring --enable-mbregex --enable-exif --enable-shmop --enable-soap --enable-sockets --enable-wddx --enable-zip --enable-calendar --enable-ftp --enable-xml --enable-mysqlnd --enable-bcmath --enable-sysvsem --enable-sysvmsg --enable-sysvshm --enable-pcntl --enable-inline-optimization --enable-fpm --with-fpm-user=work --with-fpm-group=work --enable-opcache --enable-session --enable-shared --enable-static
make && make install  && make clean

#
# 安装 php composer
#
cd /home/work/soft
/home/work/php/bin/php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
/home/work/php/bin/php composer-setup.php
cp composer.phar /home/work/php/bin/
rm composer-setup.php && rm composer.phar
/home/work/php/bin/php /home/work/php/bin/composer.phar


#
# 安装Redis扩展 2.2.x版本(稳定兼容版本,推荐版本)
#
cd /home/work/soft
tar zxvf redis-2.2.8.tgz && cd redis-2.2.8
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config 
make && make install  
cd .. && rm -rf redis-2.2.8
#为了不冲突，2.2.x版本跟3.1.x版本文件名不同
cd /home/work/php/lib/php/extensions/no-debug-non-zts-20131226/ && mv redis.so redis.2.2.so 

#
# 安装Redis扩展 3.1.x版本(兼容新协议版本)
#
cd /home/work/soft
tar zxvf redis-3.1.3.tgz && cd redis-3.1.3
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config 
make && make install 
cd .. && rm -rf redis-3.1.3
#为了不冲突，2.2.x版本跟3.1.x版本文件名不同
cd /home/work/php/lib/php/extensions/no-debug-non-zts-20131226/ && mv redis.so redis.3.1.so 


#
# 安装ImageMagick扩展
#
cd /home/work/soft
tar zxvf imagick-3.4.3.tgz && cd imagick-3.4.3
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config 
make && make install 
cd .. && rm -rf imagick-3.4.3


#
# 安装GraphicsMagick扩展
#
cd /home/work/soft
tar zxvf gmagick-1.1.7RC3.tgz && cd gmagick-1.1.7RC3
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config 
make && make install 
cd .. && rm -rf magick-1.1.7RC3

#
# 安装Memcached扩展
#
cd /home/work/soft 
tar zxvf memcached-2.2.0.tgz && cd memcached-2.2.0
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config --with-libmemcached-dir=/home/work/lib
make && make install 
cd .. && rm -rf memcached-2.2.0

#
# 安装memcache扩展
#
cd /home/work/soft 
tar zxvf memcache-3.0.8.tgz && cd memcache-3.0.8
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config
make && make install 
cd .. && rm -rf memcache-3.0.8


#
# 安装mongo扩展
#
cd /home/work/soft 
tar zxvf mongo-1.6.14.tgz && cd mongo-1.6.14
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config 
make && make install 
cd .. && rm -rf mongo-1.6.14

#
# 安装mongodb扩展
#
cd /home/work/soft 
tar zxvf mongodb-1.2.9.tgz && cd mongodb-1.2.9
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config 
make && make install 
cd .. && rm -rf mongodb-1.2.9



#
# 安装Gearman扩展
#
cd /home/work/soft 
tar zxvf gearman-1.1.2.tgz && cd gearman-1.1.2
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config  --with-gearman=/home/work/lib/gearman/
make && make install 
cd .. && rm -rf gearman-1.1.2

#
# 安装SeasLog扩展
#
cd /home/work/soft
tar zxvf SeasLog-1.6.9.tgz && cd SeasLog-1.6.9
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config
make && make install 
cd .. && rm -rf SeasLog-1.6.9

#
# 安装MsgPack扩展
#
cd /home/work/soft 
tar zxvf msgpack-0.5.7.tgz && cd msgpack-0.5.7 
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config
make && make install 
cd .. && rm -rf msgpack-0.5.7

#
# 安装Protobuf扩展
#
cd /home/work/soft 
tar zxvf protobuf-3.3.2.tgz && cd protobuf-3.3.2
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config
make && make install 
cd .. && rm -rf protobuf-3.3.2

#
# 安装Swoole扩展 1.8+版本（稳定版本, 符合我们线上需求）
#
cd /home/work/soft 
tar zxvf swoole-1.8.13.tgz && cd swoole-1.8.13
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config  --enable-sockets --enable-openssl --enable-http2 --enable-async-redis --enable-thread --enable-swoole
make && make install 
cd .. && rm -rf swoole-1.8.13
#为了不冲突，1.8版本跟1.9/2.0版本文件名不同
cd /home/work/php/lib/php/extensions/no-debug-non-zts-20131226/ && mv swoole.so swoole.1.8.so 

#
# 安装Swoole扩展 1.9+版本（稳定版本）
#
cd /home/work/soft 
tar zxvf swoole-1.9.23.tgz && cd swoole-1.9.23
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config  --enable-sockets --enable-openssl --enable-http2 --enable-async-redis --enable-mysqlnd --enable-thread --enable-swoole
make && make install 
cd .. && rm -rf swoole-1.9.23
#为了不冲突，1.9版本跟2.0版本文件名不同
cd /home/work/php/lib/php/extensions/no-debug-non-zts-20131226/ && mv -if swoole.so swoole.1.9.so 

#
# 安装Swoole扩展 2.0+版本（支持协程，非稳定版本）
#
# 安装说明：（注意）
# 安装Swoole2.0 + 版本注意事项：
# gcc 4.4下如果在编译swoole的时候（即make阶段），出现 
# gcc warning： dereferencing pointer ‘v.327’ does break strict-aliasing rules、 dereferencing type-punned #pointer will break strict-aliasing rules 
# 请手动编辑Makefile，将：
# CFLAGS = -Wall -pthread -g -O2 
# 替换为：
# CFLAGS = -Wall -pthread -g -O2 -fno-strict-aliasing
# 然后重新编译：
# make;make install
#
cd /home/work/soft 
tar zxvf swoole-2.0.12.tgz && cd swoole-2.0.12
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config  --enable-coroutine  --enable-sockets --enable-openssl --enable-http2 --enable-async-redis --enable-mysqlnd --enable-thread --enable-swoole 
make && make install  
cd .. && rm -rf swoole-2.0.12
#为了不冲突，1.9版本跟2.0版本文件名不同
cd /home/work/php/lib/php/extensions/no-debug-non-zts-20131226/ && mv -if swoole.so swoole.2.0.so 

#
# 安装Yaf扩展
#
cd /home/work/soft 
tar zxvf yaf-2.3.5.tgz && cd yaf-2.3.5
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config
make && make install 
cd .. && rm -rf yaf-2.3.5

#
# 安装yar扩展
#
cd /home/work/soft 
tar zxvf yar-1.2.5.tgz && cd yar-1.2.5
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config  --enable-msgpack
make && make install 
cd .. && rm -rf yar-1.2.5



#
# 安装gRpc扩展
#
cd /home/work/soft 
/home/work/php/bin/pecl install grpc-1.1.0.tgz


#
# 安装GeoIP扩展 (使用pecl方式安装)
#
# 说明：本扩展依赖于GeoIP库，可以使用：
#       sudo yum -y install GeoIP GeoIP-data GeoIP-devel GeoIP-update

cd /home/work/soft 
/home/work/php/bin/pecl install geoip-1.1.1.tgz


#
# 安装APCu扩展 
#
# 说明：本扩展解决opcache无法缓存用户数据的问题
#       配置参考：http://cn2.php.net/manual/zh/apcu.configuration.php
cd /home/work/soft 
tar zxvf apcu-4.0.11.tgz && cd apcu-4.0.11
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config
make && make install 

#
# 安装igbinary扩展 (序列化格式扩展，性能比 json/seriablize 要快一些)
#
cd /home/work/soft 
tar zxvf igbinary-2.0.1.tgz && cd igbinary-2.0.1
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config 
make && make install 
cd .. && rm -rf igbinary-2.0.1

#
# 安装Xdebug扩展 
#
cd /home/work/soft 
tar zxvf xdebug-2.5.5.tgz && cd xdebug-2.5.5
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config 
make && make install 
cd .. && rm -rf xdebug-2.5.5
mkdir -p /home/work/data/xdebug


#
# 安装xhprof扩展 
#
cd /home/work/soft 
tar zxvf xhprof-0.9.4.tgz && cd xhprof-0.9.4/extension
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config 
make && make install 
## copy xhprof php lib
mkdir -p /home/work/php/lib/third/xhprof
mkdir -p /home/work/data/xhprof
cd /home/work/soft/xhprof-0.9.4
cp -rf xhprof_html  /home/work/php/lib/third/xhprof
cp -rf xhprof_lib  /home/work/php/lib/third/xhprof
cd ../.. && rm -rf xhprof-0.9.4


#
# 安装phptrace扩展 
#
cd /home/work/soft 
tar zxvf trace-1.0.1beta.tgz && cd trace-1.0.1beta/extension
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config 
make && make install 
cd ../.. && rm -rf trace-1.0.1beta


#
# 安装trie_filter扩展 （敏感词过滤扩展）
#
# 使用参考：
# 构建词库：https://github.com/heiyeluren/tools/blob/master/lnmp_install/trie_filter_make_dict.php
# 检查敏感词：https://github.com/heiyeluren/tools/blob/master/lnmp_install/trie_filter_find_word.php
#
cd /home/work/soft 
unzip -o php-ext-trie-filter-master.zip && cd php-ext-trie-filter-master
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config --with-trie_filter=/home/work/lib
make && make install 
cd .. && rm -rf php-ext-trie-filter-master

#
# 安装stomp扩展 （消息队列处理扩展）
#
cd /home/work/soft 
tar zxvf stomp-1.0.9.tgz && cd stomp-1.0.9
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config
make && make install 
cd .. && rm -rf stomp-1.0.9

#
# 安装amqp扩展 (消息队列客户端，RabbitMQ/OpenAMQP/Qpid等都可以使用，依赖于librabbitmq)
#
cd /home/work/soft 
tar zxvf amqp-1.9.1.tgz && cd amqp-1.9.1
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config  --with-librabbitmq-dir=/home/work/lib
make && make install 
cd .. && rm -rf amqp-1.9.1

#
# 安装rdKafka扩展
#
cd /home/work/soft 
tar zxvf rdkafka-3.0.4.tgz && cd rdkafka-3.0.4
/home/work/php/bin/phpize 
#替换lib库路径
sed -i 's/^ *SEARCH_PATH.*$/#SEARCH_PATH\n  SEARCH_PATH="\/home\/work\/lib"/' ./configure
./configure --with-php-config=/home/work/php/bin/php-config 
make && make install 
cd .. && rm -rf rdkafka-3.0.4


#
# 安装fastdfs扩展
#
cd /home/work/soft 
unzip fastdfs-5.08.zip && cd fastdfs-5.08/php_client
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config 
make && make install 
cd ../.. && rm -rf fastdfs-5.08

#
# 安装opencc4php扩展
#
cd /home/work/soft 
unzip -o opencc4php.zip && cd opencc4php-master
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config --with-opencc=/home/work/lib
make && make install 
cd .. && rm -rf opencc4php-master


#
# 安装zbarcode扩展
#
cd /home/work/soft 
unzip -o php-zbarcode-master.zip && cd  php-zbarcode-master
/home/work/php/bin/phpize 
./configure --with-php-config=/home/work/php/bin/php-config 
make && make install 
cd .. && rm -rf hp-zbarcode-master


#
# 构建使用标准配置 (本步骤必须)
#
if [ $USER != "work" ]; then  su work; fi
mkdir -p /home/work/php/etc/pool.d && mkdir -p /home/work/logs/php
cp /home/work/soft/php-5.6.33/php.ini-production /home/work/php/etc
cd /home/work/soft/conf && cp heiyeluren-php5.6.ini /home/work/php/etc/php.ini  && cp heiyeluren-php5.6-fpm.conf /home/work/php/etc/php-fpm.conf && cp heiyeluren-php5.6-fpm.www.conf  /home/work/php/etc/pool.d/www.conf

#
# 测试是否可以运行
#
## 启动php-fpm (如果php-fpm监听端口是低于1024的,需要用root账户启动,否则非root就可以了)
# /home/work/php/sbin/php-fpm && sleep 1 && ps auxx |grep php-fpm





## 六. 安装 PHP 7.1 版本

#创建相应目录
mkdir -p /home/work/php7/etc/pool.d && mkdir -p /home/work/logs/php && mkdir -p /home/work/php7/etc/php.d

#
# 编译PHP引擎
#
cd /home/work/soft
tar zxvf php-7.1.13.tar.gz && cd php-7.1.13
./configure --prefix=/home/work/php7 --with-config-file-path=/home/work/php7/etc/ --with-config-file-scan-dir=/home/work/php7/etc/php.d/  --with-libxml-dir=/home/work/lib --with-pgsql=/home/work/lib/pgsql --with-pdo-pgsql=/home/work/lib/pgsql  --with-jpeg-dir=/home/work/lib --with-png-dir=/usr/lib64 --with-freetype-dir --with-mhash=/home/work/lib --with-mcrypt=/home/work/lib --with-pgsql=/usr/lib64 --with-pdo-pgsql=/usr/lib64 --with-pcre-regex=/home/work/lib  --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd  --with-pcre-jit --with-openssl --with-gd  --enable-gd-native-ttf --with-gettext --with-zlib --with-xmlrpc --with-xsl --with-iconv --with-zlib --with-bz2 --with-gmp --with-curl --with-gdbm --enable-mbstring --enable-mbregex --enable-exif --enable-shmop --enable-soap --enable-sockets --enable-wddx --enable-zip --enable-calendar --enable-ftp --enable-xml --enable-mysqlnd --enable-bcmath --enable-sysvsem --enable-sysvmsg --enable-sysvshm --enable-pcntl --enable-inline-optimization --enable-fpm --with-fpm-user=work --with-fpm-group=work --enable-opcache --enable-session --enable-shared --enable-static
make && make install && make clean


#
# 安装 php composer
#
cd /home/work/soft
/home/work/php7/bin/php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
/home/work/php7/bin/php composer-setup.php
cp composer.phar /home/work/php7/bin/
rm composer-setup.php && rm composer.phar
/home/work/php7/bin/php /home/work/php7/bin/composer.phar



#
# 安装Redis扩展
#
cd /home/work/soft
tar zxvf redis-3.1.3.tgz && cd redis-3.1.3
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config 
make && make install 
cd .. && rm -rf redis-3.1.3


#
# 安装ImageMagick扩展
#
cd /home/work/soft
tar zxvf imagick-3.4.3.tgz && cd imagick-3.4.3
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config 
make && make install 
cd .. && rm -rf imagick-3.4.3


#
# 安装GraphicsMagick扩展
#
cd /home/work/soft
tar zxvf gmagick-2.0.4RC1.tgz && cd gmagick-2.0.4RC1
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config 
make && make install 
cd .. && rm -rf gmagick-2.0.4RC1

#
# 安装Memcached扩展
#
cd /home/work/soft 
unzip -o php-memcached-3.0.3.zip && cd php-memcached-3.0.3
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config --with-libmemcached-dir=/home/work/lib
make && make install 
cd .. && rm -rf php-memcached-3.0.3

#
# 安装mongodb扩展
#
cd /home/work/soft 
tar zxvf mongodb-1.2.9.tgz && cd mongodb-1.2.9
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config 
make && make install 
cd .. && rm -rf mongodb-1.2.9

#
# 安装Gearman扩展
#
cd /home/work/soft 
unzip -o pecl-gearman-php7-master.zip && cd pecl-gearman-php7-master
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config  --with-gearman=/home/work/lib/gearman/
make && make install 
cd .. && rm -rf pecl-gearman-php7-master

#
# 安装rdKafka扩展
#
cd /home/work/soft 
tar zxvf rdkafka-3.0.4.tgz && cd rdkafka-3.0.4
/home/work/php7/bin/phpize 
#替换lib库路径
sed -i 's/^ *SEARCH_PATH.*$/#SEARCH_PATH\n  SEARCH_PATH="\/home\/work\/lib"/' ./configure
./configure --with-php-config=/home/work/php7/bin/php-config 
make && make install 
cd .. && rm -rf rdkafka-3.0.4

#
# 安装SeasLog扩展
#
cd /home/work/soft
tar zxvf SeasLog-1.6.9.tgz && cd SeasLog-1.6.9
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config
make && make install 
cd .. && rm -rf SeasLog-1.6.9

#
# 安装MsgPack扩展
#
cd /home/work/soft 
tar zxvf msgpack-2.0.2.tgz && cd msgpack-2.0.2
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config
make && make install 
cd .. && rm -rf msgpack-2.0.2

#
# 安装Protobuf扩展
#
cd /home/work/soft 
unzip -o php-protobuf-php7.zip && cd php-protobuf-php7
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config
make && make install 
cd .. && rm -rf php-protobuf-php7

#
# 安装Swoole扩展 1.8+版本（稳定版本, 符合我们线上需求）
#
cd /home/work/soft 
tar zxvf swoole-1.8.13.tgz && cd swoole-1.8.13
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config  --enable-sockets --enable-openssl --enable-http2 --enable-async-redis --enable-thread --enable-swoole
make && make install 
cd .. && rm -rf swoole-1.8.13
#为了不冲突，1.8版本跟1.9/2.0版本文件名不同
cd /home/work/php7/lib/php/extensions/no-debug-non-zts-20160303 && mv -if swoole.so swoole.1.8.so 


#
# 安装Swoole扩展 1.9+版本（稳定版本）
#
cd /home/work/soft 
tar zxvf swoole-1.9.23.tgz && cd swoole-1.9.23
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config --enable-sockets --enable-openssl --enable-http2 --enable-async-redis --enable-mysqlnd --enable-thread --enable-swoole 
make && make install
cd .. && rm -rf swoole-1.9.23

#为了不冲突，1.9版本跟2.0版本文件名不同
cd /home/work/php7/lib/php/extensions/no-debug-non-zts-20160303 && mv -if swoole.so swoole.1.9.so 

#
# 安装Swoole扩展 2.0+版本（支持协程，非稳定版本）
#
# 安装说明：（注意）
# 安装Swoole2.0 + 版本注意事项：
# gcc 4.4下如果在编译swoole的时候（即make阶段），出现 
# gcc warning： dereferencing pointer ‘v.327’ does break strict-aliasing rules、 dereferencing type-punned #pointer will break strict-aliasing rules 
# 请手动编辑Makefile，将：
# CFLAGS = -Wall -pthread -g -O2 
# 替换为：
# CFLAGS = -Wall -pthread -g -O2 -fno-strict-aliasing
# 然后重新编译：
# make;make install 
#
cd /home/work/soft 
tar zxvf swoole-2.0.12.tgz && cd swoole-2.0.12
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config  --enable-coroutine  --enable-sockets --enable-openssl --enable-http2 --enable-async-redis --enable-mysqlnd --enable-thread --enable-swoole 
make && make install
cd .. && rm -rf swoole-2.0.12
#为了不冲突，1.9版本跟2.0版本文件名不同
cd /home/work/php7/lib/php/extensions/no-debug-non-zts-20160303 && mv -if swoole.so swoole.2.0.so 


#
# 安装Yaf扩展 (3.0版本)
#
cd /home/work/soft 
tar zxvf yaf-3.0.5.tgz && cd yaf-3.0.5
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config
make && make install 
cd .. && rm -rf yaf-3.0.5

#
# 安装yar扩展
#
cd /home/work/soft 
tar zxvf yar-2.0.3.tgz &&  cd yar-2.0.3
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config  --enable-msgpack
make && make install 
cd .. && rm -rf yar-2.0.3


#
# 安装yaconf扩展
#
cd /home/work/soft 
/home/work/php7/bin/pecl install yaconf-1.0.6.tgz


#
# 安装gRpc扩展 (使用pecl方式安装)
#
cd /home/work/soft 
/home/work/php7/bin/pecl install grpc-1.4.1.tgz

#
# 安装GeoIP扩展 (使用pecl方式安装)
#
# 说明：本扩展依赖于GeoIP库，可以使用：
#       sudo yum -y install GeoIP GeoIP-data GeoIP-devel GeoIP-update
# 也可以使用pecl安装扩展：/home/work/php/bin/pecl install geoip-1.1.1.tgz

cd /home/work/soft 
/home/work/php7/bin/pecl install geoip-1.1.1.tgz

#
# 安装APCu扩展 
#
# 说明：本扩展解决opcache无法缓存用户数据的问题
#       配置参考：http://cn2.php.net/manual/zh/apcu.configuration.php
cd /home/work/soft 
tar zxvf apcu-5.1.8.tgz && cd apcu-5.1.8
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config
make && make install 
cd .. && rm -rf apcu-5.1.8

#
# 安装amqp扩展 (消息队列客户端，RabbitMQ/OpenAMQP/Qpid等都可以使用，依赖于librabbitmq)
#
cd /home/work/soft 
tar zxvf amqp-1.9.1.tgz && cd amqp-1.9.1
/home/work/php7/bin/phpize 

#依赖库的配置文件路径修改
sed -i '/\$as_echo_n "checking for amqp files in default path... " >&6; }/a PHP_LIBRABBITMQ_DIR="\/home\/work\/lib"'  ./configure
# export PKG_CONFIG=/home/work/lib/lib64/pkgconfig/
# export PKG_CONFIG_PATH=/home/work/lib/lib64/pkgconfig
# export LD_LIBRARY_PATH=/home/work/lib:$LD_LIBRARY_PATH

./configure --with-php-config=/home/work/php7/bin/php-config --with-librabbitmq-dir==/home/work/lib
make && make install 
cd .. && rm -rf amqp-1.9.1

#
# 安装stomp扩展 (消息队列客户端，RabbitMQ 等启用了STOMP协议的都可以使用)
#
cd /home/work/soft 
tar zxvf stomp-2.0.1.tgz && cd stomp-2.0.1
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config 
make && make install 
cd .. && rm -rf stomp-2.0.1

#
# 安装igbinary扩展 (序列化格式扩展，性能比 json/seriablize 要快一些)
#
cd /home/work/soft 
tar zxvf igbinary-2.0.1.tgz && cd igbinary-2.0.1
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config 
make && make install 
cd .. && rm -rf igbinary-2.0.1

#
# 安装Xdebug扩展 
#
cd /home/work/soft 
tar zxvf xdebug-2.5.5.tgz && cd xdebug-2.5.5
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config 
make && make install 
cd .. && rm -rf xdebug-2.5.5

#
# 安装xhprof扩展 
#
cd /home/work/soft 
unzip -o xhprof-php7.zip && cd xhprof-php7/extension
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config 
make && make install 
## copy xhprof php lib
mkdir -p /home/work/php7/lib/third/xhprof
mkdir -p /home/work/data/xhprof
cd /home/work/soft/xhprof-php7
cp -rf xhprof_html  /home/work/php7/lib/third/xhprof
cp -rf xhprof_lib  /home/work/php7/lib/third/xhprof
cd /home/work/soft && rm -rf xhprof-php7


#
# 安装phptrace扩展 
#
cd /home/work/soft 
tar zxvf trace-1.0.1beta.tgz && cd trace-1.0.1beta/extension
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config 
make && make install 
cd ../.. && rm -rf trace-1.0.1beta


#
# 安装fastdfs扩展
#
cd /home/work/soft 
unzip -o fastdfs-5.08.zip && cd fastdfs-5.08/php_client
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config 
make && make install 
cd ../.. && rm -rf fastdfs-5.08


#
# 安装opencc4php扩展
#
cd /home/work/soft 
unzip -o opencc4php.zip && cd opencc4php-master
/home/work/php7/bin/phpize 
./configure --with-php-config=/home/work/php7/bin/php-config --with-opencc=/home/work/lib
make && make install 
cd ../.. && rm -rf opencc4php-master



#
# 构建使用标准配置 (本步骤必须)
#
if [ $USER != "work" ]; then  su work; fi
mkdir -p /home/work/php7/etc/pool.d && mkdir -p /home/work/logs/php
cp /home/work/soft/php-7.1.13/php.ini-production /home/work/php7/etc
cd /home/work/soft/conf && cp heiyeluren-php7.1.ini /home/work/php7/etc/php.ini  && cp heiyeluren-php7.1-fpm.conf /home/work/php7/etc/php-fpm.conf && cp heiyeluren-php7.1-fpm.www.conf  /home/work/php7/etc/pool.d/php7-www.conf

#
# 测试是否可以运行
#
## 启动php-fpm (如果php-fpm监听端口是低于1024的,需要用root账户启动,否则非root就可以了)
# /home/work/php7/sbin/php-fpm && sleep 1 && ps auxx |grep php-fpm











