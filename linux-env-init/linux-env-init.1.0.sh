

## ========================================= ##
# 
#  标准Linux环境初始化文档脚本
#
#  @author: heiyeluren
#  @site: https://gibhub.com/heiyeluren
#  @version: v1.0
#  @created: 2017/7/10
#  @lastmodify: 2017/10/16
# 
## ========================================= ##


#说明文档：

# 1.  本手册是带Shell性质的文档 + Shell的方式，部分节奏适合自己环境可以微调一下
# 2.  为了方便，会默认为选择的是CentOS类的Linux系统，版本是 7.x 左右
# 3.  为了安全默认都设置密码，参考密码：
#
# 为了保证系统安全，建议把root密码设置足够健壮：大小写字母+数字+特殊字符，为了方便记，可以设置一些有意义的密码。(命令passwd root 来修改)
# 举例1：Flzc3000c1sy&l9t （飞流直下三千尺疑是银河落九天，&代表和）
# 举例2：Yhs8jCfcys / YhsbjCfcys （野火烧不尽春风吹又生）
# 举例3：C*dlxYrjn^ / Cai*dlxYourjn^ （采菊东篱下悠然见南山，*代表菊，^代表山）
# 举例4：Mhxzkyh （梅花香自苦寒来，拼音）

# 4.  如果需要按照全部环节来，建议是按照文档的第一步开始逐步操作调整，才能够构建比较优秀的环境。
# 5.  如果部分软件无法下载，或者是版本问题，建议单独下载做微调进行调整。







##########################################
#
#    初始化Linux服务器
#
#    @version: v1.0.0
#
###########################################


#####################
#     挂载硬盘
#####################

# 格式化磁盘和进行挂载,任意原始磁盘都必须把数据盘挂载到 /home 目录下 # 

## 注意: ucloud 和 aws的虚拟磁盘路径不同,注意修改 VDISK 变量 ##

VDISK=/dev/vdb
QVDISK=${VDISK//\//\\/}
umount $VDISK
mkfs.ext4 $VDISK
mount $VDISK /home
sed -i "s/$QVDISK/#\/dev\/vdb/g" /etc/fstab
echo "$VDISK  /home ext4  defaults,noatime  0  0" >> /etc/fstab



# /home 是我们核心的代码安装部署目录，所以，我们需要把核心大磁盘挂在到 /home 目录。
# 假设我们目前大磁盘默认挂在在：/data 目录下面，数据盘是 /dev/xvdb1，我们需要先umount这个挂载。
# 去掉挂载：umount /home/
# 重新挂载：mount -t ext4 /dev/xvdb1 /home/
# 需要永久生效(reboot重启依然生效)，需要修改 /etc/fstab 文件（修改后直接root权限 mount -a 生效）：
# 把：    /dev/xvdb1  /data ext4    defaults    0  0
# 修改为：/dev/xvdb1  /home ext4    defaults    0  0
# 或直接：echo "/dev/xvdb1  /home ext4    defaults    0  0" >> /etc/fstab

## 阿里云/腾讯云等服务器挂载流程是：
# (1) 购买云盘
# (2) 在服务器里加载使用 
#     a)fdisk -l  #查看新加入分区 (阿里云是 xvdb、腾讯云是vdb)
#     b)分区：fdisk  /dev/vdb ，根据提示，依次输入“n”，“p”“1”，两次回车，“wq”，分区就开始了，很快就会完成。
#     c)查看分区结果：使用“fdisk -l”命令可以看到，新的分区/dev/vdb1已经建立完成了。（注意：/dev/vdb1是针对vdb磁盘的分区1，还可以有/dev/vdb2。。。，/dev/vdb 是整个硬盘）
#     d)格式化分区： mkfs.ext4 /dev/vdb1（如果要格式化整个磁盘就是：mkfs.ext4 /dev/vdb，如果需要其他文件格式可以使用mkfs.ext3 等.）
#     e)马上加载分区：mount /dev/vdb  /home/ （把/dev/vdb整个硬盘挂载在/home目录下，也可以挂在一个分区：mount /dev/vdb1 /home/work）
#     f)永久挂载：
#     echo '/dev/vdb  /home ext4    defaults    0  0' >> /etc/fstab
#     cat /etc/fstab，看看是否写入了，可以用：mount -a 全部执行 /etc/fstab 中的配置，重启服务器效果类似。

## ucloud 默认会给你挂载好,因为我们标准环境需要,所以需要 ：
# unmount /data
# mount /dev/vdb /home

## aws 会需要自己进行格式化和 mount 磁盘到 /home 目录



#####################
#  修改root密码
#####################
#
# 为了保证系统安全，建议把root密码设置足够健壮：大小写字母+数字+特殊字符，为了方便记，可以设置一些有意义的密码。(命令passwd root 来修改)
# 举例1：Flzc3000c1sy&l9t （飞流直下三千尺疑是银河落九天，&代表和）
# 举例2：Yhs8jCfcys / YhsbjCfcys （野火烧不尽春风吹又生）
# 举例3：C*dlxYrjn^ / Cai*dlxYourjn^ （采菊东篱下悠然见南山，*代表菊，^代表山）

# passwd root 


#####################
#  关闭多余系统服务
#####################
for i in irqbalance.service acpid.service auditd.service kdump.service ntpd.service postfix.service ; do
    systemctl disable $i
done


#####################
#  LDAP托管权限修改
#####################



#####################
#  ntp时间服务器同步
#####################

## 说明：一般阿里云/腾讯云等都会有自己的ntp时间服务器，稳妥起见,需要搭建自己的ntp服务器
##
# ntp时间服务器列表：asia.pool.ntp.org / cn.pool.ntp.org / cn.ntp.org.cn ，推荐 ntp.org 域名的靠谱些

# 加入到crontab中
# sudo crontab -e
#
# 新增如下内容：(每隔15分钟从ntp服务器同步一下时间)
# */15 * * * * /usr/sbin/ntpdate asia.pool.ntp.org >> /var/log/ntpdate.log
#



#####################
#  修改ssh登陆方式
#####################
#
# 说明: 修改成为采用密钥方式登录,关闭用户密码登陆
#

# 默认网络上很多黑客和ScriptKids会没事就扫描服务器，如果发现开放了22端口的会疯狂的去入侵，为了安全起见，多一事不如省一事原则，修改ssh的服务端口
#
# 修改ssh/sshd端口为 8822，可以自行修改
# SPORT=9922
# sudo sed -i 's/^[ ]*Port/#    Port/' /etc/ssh/ssh_config
#sudo sed -i 's/^Port/#Port/'         /etc/ssh/sshd_config
#sudo echo "    Port $SPORT"       >> /etc/ssh/ssh_config
#sudo echo "Port $SPORT"           >> /etc/ssh/sshd_config
#unset SPORT

# 重启服务生效（记得重新登陆的时候需要修改ssh端口）
#service sshd restart
#/bin/systemctl restart  sshd.service


#####################
#  更改hostname
#####################

## 为了方便显示服务器，会修改hostname的显示信息，方便终端下面显示管理
# hostname 存储在 /etc/hostnmae 文件里，直接修改重启就生效啦

## 命名规则 ##
# 命名说明: 业务模块-机器用途-机器自增序列号.机房城市.所属云服务商或所属自主机房名称.业务所属主域名
#
# 示例如下:

# php-web00.bj.aliyun    #php网页00.北京机房.阿里云
# go-app01.bj.yizhuan    #go应用01.北京机房.亦庄机房
# db-mysql02.tj.qcloud   #数据库mysql.天津机房.阿里云
# 

HNAME="linux-new-env00.bj"    #本机的可识别名字
LIP="10.9.149.238"     #本机的IP(一般是绑定eth0网卡的IP地址)

echo $HNAME > /etc/hostname
sed -i 's/HOSTNAME/#HOSTNAME/g ' /etc/sysconfig/network
echo "HOSTNAME=$HNAME" >> /etc/sysconfig/network
echo "$LIP $HNAME" >> /etc/hosts



#####################
#  更改yum源
#####################

## 如果自己搭建了相关yum源,需要把 /etc/yum.repos.d/ 相关配置修改成自己的,方便更快速的安装包 #





##########################################
#
#    高性能Linux服务器配置脚本
# 
#   @version: v1.0.0
#
#   @desc: 执行完成后，需要重启服务器
#
###########################################


#####################
#     临时生效
#####################

## 网络
sudo sysctl -w "net.core.somaxconn=2048"
sudo sysctl -w "net.core.rmem_default=262144"
sudo sysctl -w "net.core.wmem_default=262144"
sudo sysctl -w "net.core.rmem_max=16777216"
sudo sysctl -w "net.core.wmem_max=16777216"
sudo sysctl -w "net.core.netdev_max_backlog=20000"
sudo sysctl -w "net.ipv4.tcp_rmem=4096 4096 16777216"
sudo sysctl -w "net.ipv4.tcp_wmem=4096 4096 16777216"
sudo sysctl -w "net.ipv4.tcp_mem=786432 2097152 3145728"
sudo sysctl -w "net.ipv4.tcp_max_syn_backlog=16384"
sudo sysctl -w "net.ipv4.tcp_fin_timeout=30"
sudo sysctl -w "net.ipv4.tcp_keepalive_time=300"
sudo sysctl -w "net.ipv4.tcp_max_tw_buckets=5000"
sudo sysctl -w "net.ipv4.tcp_tw_reuse=1"
sudo sysctl -w "net.ipv4.tcp_tw_recycle=0"
sudo sysctl -w "net.ipv4.tcp_syncookies=1"
sudo sysctl -w "net.ipv4.tcp_max_orphans=131072"
sudo sysctl -w "net.ipv4.ip_local_port_range=1024 65535"


## 文件描述符
sudo sysctl -w "fs.nr_open=5000000"
sudo sysctl -w "fs.file-max=2000000"
sudo sysctl -w "fs.inotify.max_user_watches=16384"

## 缓存
sudo sysctl -w "vm.max_map_count=655360"


#####################
#     永久生效
#####################

## 网络
sudo echo "net.core.somaxconn=2048"                 >> /etc/sysctl.conf
sudo echo "net.core.rmem_default=262144"            >> /etc/sysctl.conf
sudo echo "net.core.wmem_default=262144"            >> /etc/sysctl.conf
sudo echo "net.core.rmem_max=16777216"              >> /etc/sysctl.conf
sudo echo "net.core.wmem_max=16777216"              >> /etc/sysctl.conf
sudo echo "net.core.netdev_max_backlog=20000"       >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_rmem=4096 4096 16777216"    >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_wmem=4096 4096 16777216"    >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_mem=786432 2097152 3145728" >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_max_syn_backlog=16384"      >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_fin_timeout=30"             >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_keepalive_time=300"         >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_max_tw_buckets=5000"        >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_tw_reuse=1"                 >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_tw_recycle=0"               >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_syncookies=1"               >> /etc/sysctl.conf
sudo echo "net.ipv4.tcp_max_orphans=131072"         >> /etc/sysctl.conf
sudo echo "net.ipv4.ip_local_port_range=1024 65535" >> /etc/sysctl.conf


## 文件描述符
sudo echo "fs.nr_open=5000000"                      >> /etc/sysctl.conf
sudo echo "fs.file-max=2000000"                     >> /etc/sysctl.conf
sudo echo "fs.inotify.max_user_watches=16384"       >> /etc/sysctl.conf

## 缓存
sudo echo "vm.max_map_count=655360"                 >> /etc/sysctl.conf

## 生效
sudo sysctl -p


#####################
#     修改硬限制
#####################

## 修改limits.conf，这样可以永久生效限制

cd /etc/security/limits.d && for file in  `ls`; do mv $file $file.bak; done

sudo sed -i 's/^@users/#@users/'              /etc/security/limits.conf
sudo sed -i 's/^@root/#@root/'                /etc/security/limits.conf
sudo sed -i 's/^\*/#\*/'                      /etc/security/limits.conf
sudo sed -i 's/^root/#root/'                  /etc/security/limits.conf

sudo echo "@users soft  nofile  2000001"   >> /etc/security/limits.conf
sudo echo "@users hard  nofile  2000001"   >> /etc/security/limits.conf
sudo echo "@root  soft  nofile  2000002"   >> /etc/security/limits.conf
sudo echo "@root  hard  nofile  2000002"   >> /etc/security/limits.conf
sudo echo "*      soft  nofile  2000003"   >> /etc/security/limits.conf
sudo echo "*      hard  nofile  2000003"   >> /etc/security/limits.conf
sudo echo " "                              >> /etc/security/limits.conf

sudo echo "*      soft  nproc   10240"     >> /etc/security/limits.conf
sudo echo "root   soft  nproc   unlimited" >> /etc/security/limits.conf
sudo echo " "                              >> /etc/security/limits.conf

sudo echo "*      soft  core    unlimited" >> /etc/security/limits.conf
sudo echo "*      hard  core    unlimited" >> /etc/security/limits.conf


## 给登陆session配置文件增加限制
## 增加全局每个用户登陆后的限制(100w)，需要自行执行ulimit修改
# sed -i 's/^ulimit/#ulimit/'     /etc/bashrc
# echo "ulimit -n 1000001"     >> /etc/bashrc
# echo "ulimit -u 10240"       >> /etc/bashrc
# echo "ulimit -c unlimited"   >> /etc/bashrc

sudo sed -i 's/^ulimit/#ulimit/'     /etc/profile
sudo echo "ulimit -n 1000001"     >> /etc/profile
sudo echo "ulimit -u 10240"       >> /etc/profile
sudo echo "ulimit -c unlimited"   >> /etc/profile







##########################################
#
#    安装Linux基本软件和依赖库
# 
#   @author: heiyeluren
#   @created: 2017/3/21
#   @lasttime: 2017/3/21
#   @version: v1.0.3
#
#   @desc: 执行完成后，建议重启服务器
#
###########################################

# 1. 安装基本的系统支持库和安全升级

if [ $USER != "root" ]; then  su root; fi

# 系统安全升级
sudo yum -y install yum-security
sudo yum -y --security check-update
sudo yum -y update --security

## 安装基本命令和包依赖 (必须安装) ##
sudo yum -y install epel-release
sudo yum -y update

sudo yum -y install gcc gcc-c++ gdb make cmake automake autoconf nasm libtool imake binutils flex bison telnet wget curl libcurl libcurl-devel zip unzip gzip unzip bzip2 screen iftop iotop sysbench nload iperf iptraf mpfr tcpdump dstat mtr iptraf* strace sysstat htop gmp bzip2-devel gmp-devel glibc libgomp libmudflap ncurses ncurses-libs ncurses-devel boost boost-devel libgsasl libgsasl-devel cyrus-sasl* jemalloc jemalloc-devel gperf gperftools-libs gperftools-devel systemtap-sdt-devel openssl openssl-devel pcre-devel libevent libevent-devel libev libev-devel libuv libuv-devel libuv-static libgcrypt libgcrypt-devel libpng libpng-devel libjpeg-turbo libjpeg-turbo-devel openjpeg openjpeg-devel openjpeg-libs giflib giflib-devel giflib-utils gd gd-devel ImageMagick ImageMagick-devel ImageMagick-c++ ImageMagick-c++-devel GraphicsMagick GraphicsMagick-devel GraphicsMagick-c++ GraphicsMagick-c++-devel gettext gettext-devel freetype freetype-devel libtiff libtiff-devel libwebp libwebp-devel libwebp-tools libxml2 libxml2-devel libxslt libxslt-devel libuuid libmemcached libmemcached-devel libuuid-devel expat expat-devel  expat-static boost boost-devel leveldb-devel leveldb gdbm-devel gdbm sqlite-devel sqlite sqlite2 sqlite2-devel postgresql-devel postgresql-libs GeoIP-update GeoIP GeoIP-devel GeoIP-data snappy snappy-devel csnappy csnappy-devel librabbitmq librabbitmq-tools librabbitmq-devel libffi libffi-devel lz4 lz4-devel lz4-static lzo lzo-devel lzma-sdk457 lzma-sdk457-devel zstd libzstd libzstd-devel zlib-devel zlib-static libzip libzip-devel lrzip lrzip-libs lrzip-static p7zip xz xz-devel xz-compat-libs python python-pip python-devel perl perl-devel vim git subversion subversion-devel libdb libdb-cxx libdb-devel libdb-cxx-devel libdb4 libdb4-cxx libdb4-devel libdb4-cxx-devel libtool-ltdl libtool-ltdl-devel ntpdate psmisc lrzsz lsof bind-util* doxygen supervisor libnghttp2 libnghttp2-devel nghttp2 hiredis-devel hiredis mariadb* libsodium libsodium-devel nacl nacl-devel  nacl-static libunwind libunwind-devel tree java-1.8.0-openjdk java-1.8.0-openjdk-devel java-1.8.0-openjdk-headless java-1.8.0-openjdk-accessibility  java-1.8.0-openjdk-demo ruby ruby-devel ruby-libs zbar zbar-devel protobuf protobuf-static protobuf-devel glog glog-devel  axel  graphviz graphviz-devel graphviz-gd


## 安装 fastdfs 库依赖 ##
## # 注意:本库因为自身结构代码原因，必须采用ｒｏｏｔ账户安装，这里特别关注一下 ##
cd /tmp && if [ ! -f fastdfs-5.08.zip ]; then  wget https://github.com/happyfish100/fastdfs/archive/V5.08.zip && mv V5.08.zip fastdfs-5.08.zip; fi
cd /tmp && if [ ! -f libfastcommon-1.0.35.zip ]; then wget https://github.com/happyfish100/libfastcommon/archive/V1.0.35.zip && mv V1.0.35.zip libfastcommon-1.0.35.zip; fi
cd /tmp && unzip -o libfastcommon-1.0.35.zip && cd libfastcommon-1.0.35
sudo ./make.sh && sudo ./make.sh install
cd .. && rm -rf libfastcommon-1.0.35
cd /tmp && unzip -o fastdfs-5.08.zip && cd fastdfs-5.08
sudo ./make.sh && sudo ./make.sh install
cd .. && rm -rf fastdfs-5.08




## 安装开发运行环境相关编译语言和工具（可选，推荐安装） ##
# sudo yum -y install golang  golang-docs nodejs luajit luajit-devel lua-static;

## 针对MySQL/Mongo/Redis/PostgreSQL机器可以安装相关工具(可选,推荐安装) ##
# sudo yum -y install mytop innotop percona-xtrabackup* holland-xtrabackup sysbench mariadb* redis mongodb mongodb-mms-backup-agent mongodb-mms-monitoring-agent mongodb-server mongodb-test postgresql postgresql-devel postgresql-pgpool* postgresql-server postgresql-test postgresql-upgrade
# sudo yum -y install perl perl-devel perl-DBI perl-DBD-MySQL perl-Time-HiRes perl-IO-Socket-SSL perl-TermReadKey perl-Digest-MD5 perl-Digest-Perl-MD5 perl-Digest-MD5-File python-redis perl-Redis python-pymongo postgresql-pl*
# cd /tmp
# if [ ! -f percona-toolkit-3.0.3-1.el7.x86_64.rpm ]; then wget https://www.percona.com/downloads/percona-toolkit/3.0.3/binary/redhat/7/x86_64/percona-toolkit-3.0.3-1.el7.x86_64.rpm; fi 
# if [ ! -f percona-toolkit-debuginfo-3.0.3-1.el7.x86_64.rpm ]; then wget https://www.percona.com/downloads/percona-toolkit/3.0.3/binary/redhat/7/x86_64/percona-toolkit-debuginfo-3.0.3-1.el7.x86_64.rpm; fi
# if [ ! -f percona-xtrabackup-24-2.4.8-1.el7.x86_64.rpm ]; then wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.8/binary/redhat/7/x86_64/percona-xtrabackup-24-2.4.8-1.el7.x86_64.rpm; fi
# if [ ! -f percona-xtrabackup-24-debuginfo-2.4.8-1.el7.x86_64.rpm ]; then wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.8/binary/redhat/7/x86_64/percona-xtrabackup-24-debuginfo-2.4.8-1.el7.x86_64.rpm; fi
# if [ ! -f percona-xtrabackup-test-24-2.4.8-1.el7.x86_64.rpm ]; then wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.4.8/binary/redhat/7/x86_64/percona-xtrabackup-test-24-2.4.8-1.el7.x86_64.rpm; fi
# sudo rpm -Uvh --force --nodeps  percona-toolkit-3.0.3-1.el7.x86_64.rpm  percona-toolkit-debuginfo-3.0.3-1.el7.x86_64.rpm  percona-xtrabackup-24-2.4.8-1.el7.x86_64.rpm  percona-xtrabackup-24-debuginfo-2.4.8-1.el7.x86_64.rpm  percona-xtrabackup-test-24-2.4.8-1.el7.x86_64.rpm



## 针对RHEL 7.x+系统的特殊包区别
if [ `uname -r | grep -i el7` == "" ]; then 
  ## 注意：如果是CentOS/RHEL 7.0+系统，如果需要安装如下几个包，需要使用如下指令：（否则会报错：Error: Protected multilib versions: xxxxx） ##
  ## 也可以执行：package-cleanup --cleandupes  把旧版本包卸载后再执行上面的yum 安装命令 ## 
  ## 在 RHEL/CentOS 7.x+版本这几个软件会报错：libstdc++/pcre/zlib/xz-libs  ##
  ## 相关包安装指令：
  ## yum -y install libstdc++ pcre zlib xz-libs --setopt=protected_multilib=false
  ##
fi;



# 2. 创建用户和目录 (本部分可以托管到LDAP,也可以直接创建)
if [ $USER != "root" ]; then  su root; fi
mkdir -pv /home/coresave

#创建账户和主目录
groupadd  work -g 500 ; useradd work -u 500 -g 500 -d /home/work  # -p Flzc3000c1sy&l9t
groupadd  rd   -g 501 ; useradd rd   -u 501 -g 501 -d /home/rd  # -p YhsbjCfcys

mkdir -p /home/work/lib
mkdir -p /home/work/soft
mkdir -p /home/work/logs
mkdir -p /home/work/data
mkdir -p /home/work/opbin
mkdir -p /home/work/tmp
chmod 755 /home/work/  /home/rd /home/coresave
chown 500.500 /home/work -R


## 说明:其他目录按照自己组件安装需求再创建 ##



##########################################
#
#    基础运维工具部署
#
##########################################


# 监控工具
# 运维工具
# 上线工具





##########################################
#
#   @desc: 执行完成后，需要重启服务器
#
##########################################

sudo reboot











