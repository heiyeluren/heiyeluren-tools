
## 高性能 LNMP-install-2.0 说明

* lnmp-install-2.0 是基于高性能为基础的，构建满足大部分 Nginx+PHP 5/7 方面所需要的web业务场景的基础运行环境。
* 本安装必须依赖于基准环境的基础之上来进行, 所有相关账户权限目录等体系都是基于基准环境来进行的. （<a href="https://github.com/heiyeluren/heiyeluren-tools/tree/master/linux-env-init">标准高性能Linux环境参考</a>）
* 如果有必要，按照自己情况去修改关键的安装脚本：<a href="https://github.com/heiyeluren/heiyeluren-tools/blob/master/lnmp-install-2.0/lnmp-install-2.0.sh">lnmp-install-2.0.sh </a>

## 脚本执行步骤
* 1. 构建基本环境（账户、目录、权限等）
* 2. 下载相关软件（各类依赖的基础包、Nginx、PHP、各类php扩展库）
* 3. 安装Nginx
* 4. 安装基础Lib库
* 5. php 5.x版本安装
* 6. php 7.x版本安装
* 7. 收尾

<pre>

</pre>

<pre>
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



