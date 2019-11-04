---
title: GoAccess使用教程 
date: 2018-03-30 16:00:40
tags: 
  - GoAccess
  - 分析nginx日志
categories: tools
---

为了查看本站点的健康状况以及用户访问情况，就需要定期的分析服务器的 access 日志。但是由于没有使用日志分析工具，只能使用 cat、awk、sed 等命令做一些简单的日志分析统计，这样分析结果不理想也不全面，方法也极不高效。作为个人站点更适合引入轻量级的日志分析工具，例如 [GoAccess](https://goaccess.io/) ，其使用简单且分析效果较好

<!-- more -->



[allinurl/goaccess](https://github.com/allinurl/goaccess)
[GoAccess 官方文档](https://goaccess.io/man)
[使用GoAccess分析Nginx日志](https://www.fanhaobai.com/2017/06/go-access.html)
[服务器日志分析利器:ngxtop和GoAccess-实时监控可视化管理快速找出异常来源](https://wzfou.com/ngxtop-goaccess/)

### 使用GoAccess分析Nginx日志
#### 安装GoAccess
- 安装GoAccss前提
  ```
  # 安装GoAccess前提
  yum install glib2 glib2-devel GeoIP-devel  ncurses-devel zlib zlib-devel libtokyocabinet-dev
  ```
- 使用到GoAccess 磁盘存储选项（ON-DISK STORAGE OPTIONS）特性，需要配置--enable-tcb = btree
  ```
  # 安装TokyoCabinet
  wget https://src.fedoraproject.org/repo/pkgs/tokyocabinet/tokyocabinet-1.4.48.tar.gz/md5/fd03df6965f8f56dd5b8518ca43b4f5e/tokyocabinet-1.4.48.tar.gz
  tar -xzvf tokyocabinet-1.4.48.tar.gz
  cd tokyocabinet-1.4.48
  ./configure --prefix=/usr --enable-off64 --enable-fastest --disable-zlib --disable-bzip
  #  Cygwin only - some processing is required
  sed -i.bak 's/iprintf/my_iprintf/g' *.c *.h bros/*.c
  sed -i.bak -e '1332d' tcucodec.c
  make
  make install
  ```
- 安装GoAccess  
  ```
  # 安装
  wget http://tar.goaccess.io/goaccess-1.2.tar.gz
  tar -xzvf goaccess-1.2.tar.gz
  cd goaccess-1.2/
  ./configure --enable-utf8 --enable-geoip=legacy --enable-tcb=btree
  make
  make install
  # 建立软连接
  ln -s /usr/local/bin/goaccess /usr/bin/goaccess
  ```
- 根据你自己的需要，你可以在安装GoAccess调整配置选项。如下：
  - --enable-debug 使用调试标志编译且关闭编译器优化。
  - --enable-utf8 宽字符支持。依赖 Ncursesw 模块。
  - --enable-geoip=<legacy|mmdb> 地理位置支持。依赖 MaxMind GeoIP 模块。 legacy 将使用原始 GeoIP 数据库。 mmdb 将使用增强版 GeoIP2 数据库。
  - --enable-tcb=<memhash|btree> Tokyo Cabinet 存储支持。 memhash 将使用 Tokyo Cabinet 的内存哈希数据库。btree 将使用 Tokyo Cabinet 的磁盘 B+Tree 数据库。 
  - –-disable-zlib 禁止在 B+Tree 数据库上使用 zlib 压缩。
  - --disable-bzip 禁止在 B+Tree 数据库上使用 bzip2 压缩。
  - --with-getline 使用动态扩展行缓冲区用来解析完整的行请求，否则将使用固定大小(4096)的缓冲区。
  - --with-openssl 使 GoAccess 与其 WebSocket 服务器之间的通信能够支持 OpenSSL。

#### 配置
- 安装完成后，默认将配置文件goaccess.conf放置于/usr/local/etc路径，为了统一管理，使用cp /usr/local/etc/goaccess.conf /data1/coffee/goaccess_test/令将其拷贝到个人指定目录下。
- 可以对配置文件做一些配置
  ```
  time-format %H:%M:%S
  date-format %d/%b/%Y
  log-format %h %^[%d:%t %^] "%r" %s %b "%R" "%u"
  ```
- 其中，log-format 与 access.log 的 log_format 格式对应，每个参数以空格或者制表符分割，参考[自定义日志格式字符串](http://httpd.apache.org/docs/current/mod/mod_log_config.html)。参数说明如下：
  ```
  %x  与时间格式和日期格式变量匹配的日期和时间字段。当给定时间戳而不是日期和时间在两个单独的变量时使用这个
  %t  匹配time-format格式的时间字段
  %d  匹配date-format格式的日期字段
  %v  服务器名称根据规范名称设置（服务器块或虚拟主机）
  %e  这是由HTTP验证确定的请求文档的人的用户名
  %h  host(客户端ip地址，包括ipv4和ipv6)
  %r  来自客户端的请求行
  %m  请求的方法
  %U  URL路径
  %q  查询字符串
  %H  请求协议
  %s  服务器响应的状态码
  %b  服务器返回的内容大小
  %R  HTTP请求头的referer字段
  %u  用户代理的HTTP请求报头
  %D  请求所花费的时间，单位微秒
  %T  请求所花费的时间，单位秒
  %L  以毫秒为单位提供请求所需的时间，以十进制数表示
  %^  忽略这一字段
  %~  向前移动通过日志字符串，直到找到非空格（！isspace）字符
  ~h  X-Forwarded-For（XFF）字段中的主机（客户端IP地址，IPv4或IPv6）
  ```
- 其他常用配置
  ```
  real-time-html true
  ssl-cert <cert.crt>
  ssl-key <priv.key>
  ws-url wss://<your-domain>
  port <port>
  ```
  - 需要注意的几点:
    - real-time-html 用来使用实时刷新特性
	- port 是用来和浏览器通信的，选一个没被占用的就行（别忘了在防火墙里开启端口！）
	- 如果你不走 https 的话，ssl-cert，ssl-key，ws-url都不是必需的
	- 说一下 ws-url，我之前没有设置这个选项的时候 HTML 里 WebSocket 用的协议是 ws://， 浏览器是不允许在 https 网页里使用非加密协议的，找了一圈发现 ws-url 这个选项，其实我觉得应该叫 ws-scheme 才贴切

#### 命令
- 查看 GoAccess 命令参数*goaccess -h*，常用参数如下：
  ```
  # 常用参数
  -a --agent-list 启用由主机用户代理的列表。为了更快的解析，不启用该项
  -d --with-output-resolver 在HTML/JSON输出中开启IP解析，会使用GeoIP来进行IP解析
  -f --log-file 需要分析的日志文件路径
  -p --config-file 配置文件路径
  -o --output 输出格式，支持html、json、csv
  -m --with-mouse 控制面板支持鼠标点击
  -q --no-query-string 忽略请求的参数部分
  --real-time-html 实时生成HTML报告
  --daemonize 守护进程模式，--real-time-html时使用
  ```

#### 分析日志
分析日志/www/wwwlogs/access.log
##### 终端控制台模式
- 执行命令
  ```
  goaccess -a -d -f /www/wwwlogs/access.log -p /data1/coffee/goaccess_test/goaccess.conf
  ```
- 控制台下的操作方法：
  ```
  F1   主帮助页面
  F5   重绘主窗口
  q    退出
  1-15 跳转到对应编号的模块位置 
  o    打开当前模块的详细视图
  j    当前模块向下滚动
  k    当前模块向上滚动
  s    对模块排序
  /    在所有模块中搜索匹配
  n    查找下一个出现的位置
  g    移动到第一个模块顶部
  G    移动到最后一个模块底部
  ```

##### 生成HTML报告
- 执行命令：
  ```
  goaccess -a -d -f /www/wwwlogs/access.log -p /data1/coffee/goaccess_test/goaccess.conf -o /data1/coffee/goaccess_test/html/go-access.html
  ```

##### 生成JSON报告
- 执行命令：
  ```
  goaccess -a -d -f /www/wwwlogs/access.log -p /data1/coffee/goaccess_test/goaccess.conf -o /data1/coffee/goaccess_test/html/go-access.json
  ```
##### 生成CSV文件
- 执行命令：
  ```
  goaccess -a -d -f /www/wwwlogs/access.log -p /data1/coffee/goaccess_test/goaccess.conf --no-csv-summary -o /data1/coffee/goaccess_test/html/go-access.csv
  ```
##### 其他特征
- 支持管道实时分析过滤
  ```
  tail -f access.log | goaccess -
  ```
- 支持多日志文件分析
  ```
  goaccess access.log access.log.1
  # 甚至可以在读取常规文件时从管道解析文件
  cat access.log.2 | goaccess access.log access.log.1 -
  ```
##### 实时html输出
- 执行命令
  ```
  goaccess -a -d -f /www/wwwlogs/access.log -p /data1/coffee/goaccess_test/goaccess.conf -o /data1/coffee/goaccess_test/html/go-access.html --real-time-html
  ```
- 默认情况下，GoAccess使用生成的报告的主机名，也可以指定URL，例如：
  ```
  goaccess -a -d -f /www/wwwlogs/access.log -p /data1/coffee/goaccess_test/goaccess.conf -o /data1/coffee/goaccess_test/html/go-access.html --real-time-html --ws-url = goaccess.io
  ```
- 默认情况下，GoAccess监听的是7890端口，也可以指定端口
  ```
  goaccess -a -d -f /www/wwwlogs/access.log -p /data1/coffee/goaccess_test/goaccess.conf -o /data1/coffee/goaccess_test/html/go-access.html --real-time-html --port = 9870
  ```
- 将WebSocket服务器绑定到除0.0.0.0以外的其他地址，可以将其指定
  ```
  goaccess -a -d -f /www/wwwlogs/access.log -p /data1/coffee/goaccess_test/goaccess.conf -o /data1/coffee/goaccess_test/html/go-access.html --real-time-html --addr = 127.0.0.1
  ```

##### daemonize 方式
- GoAccess 已经为我们考虑到这点了，它可以以 daemonize 模式运行，并提供创建实时 HTML 的功能，只需要在启动命令后追加--real-time-html --daemonize参数即可。
  ```
  goaccess -a -d -f /www/wwwlogs/access.log -p /data1/coffee/goaccess_test/goaccess.conf -o /data1/coffee/goaccess_test/html/go-access.html --real-time-html --daemonize
  # 监听端口7890
  $ netstat -tunpl | grep "goaccess"
  tcp   0   0 0.0.0.0:7890      0.0.0.0:*     LISTEN      21136/goaccess
  ```
- 以守护进程启动 GoAccess 后，使用 Websocket 建立长连接，它默认监听 7890 端口，可以通过--port参数指定端口号。
- 由于我的站点启用了 HTTPS，所以 GoAccess 也需要使用 openssl，在配置文件goaccess.conf中配置ssl-cert和ssl-key项，并确保在安装过程中 configure 时已添加--with-openssl项来支持 openssl 。当使用 HTTPS 后 Websocket 通信时也应该使用 wss 协议，需要将ws-url项配置为wss://www.domain.com。


##### crontab 方式
在某些场景下，没有这样的实时性要求，可采用 crontab 机制实现定时更新 HTML 报表。例如：
```
# 每天执行
0 0 1 * *
goaccess -a -d -f /www/wwwlogs/access.log -p /data1/coffee/goaccess_test/goaccess.conf -o /data1/coffee/goaccess_test/html/go-access.html 2> /data1/coffee/goaccess_test/logs/go-access.log
```

##### 服务器
如果我们想以较低的优先级运行GoAccess，我们可以将其运行为：
```
nice -n 19 goaccess access.log -a
```
如果你不想在服务器上安装它，你仍然可以从本地机器上运行它：
```
ssh root @ server'cat /var/log/apache2/access.log'| goaccess -a -
```

##### 处理日志增量
- GoAccess能够通过磁盘B +树数据库逐步处理日志。它的工作原理如下：
  - 数据集必须先保存--keep-db-files，然后可以加载相同的数据集--load-from-disk
  - 如果新数据通过（传送或通过日志文件），它会将其附加到原始数据集
  - 为了始终保存数据，--keep-db-files必须使用
  - 如果--load-from-disk没有使用--keep-db-files，关闭程序后数据库文件将被删除
- 例子：
  ```
  # 上个月访问日志
  goaccess access.log.1 --keep-db-files
  ```
  然后，加载它
  ```
  # 追加本月访问日志，并保存新数据
  goaccess access.log --load-from-disk --keep-db-files
  ```
  仅读取持久数据（不解析新数据）
  ```
  goaccess --load-from-disk --keep-db-files
  ```

##### 补充
- 当 access 日志被切割后，怎么合理使用 GoAccess 分析日志，--keep-db-files这个功能倒是可以尝试，这样就可以只分析新生产的日志文件了。
- 一个实时的例子：
  ```
  goaccess -a -d \
    -f /var/log/apache2/access.log \
    -p /data1/coffee/goaccess_test/goaccess.conf \
    -o /data1/coffee/goaccess_test/html/go-access.html \
    --real-time-html \
    --load-from-disk \
    --keep-db-files
  ```
- 另一个实时的例子：
  ```
  tail -f /var/log/apache2/access.log | goaccess \
    -p /data1/coffee/goaccess_test/goaccess.conf \
    -o /data1/coffee/goaccess_test/html/go-access.html \
    --real-time-html \
    --load-from-disk \
    --keep-db-files -
  ```
- 注意--real-time-html 和 --daemonize冲突，不可同时使用

#### [常见问题](https://goaccess.io/faq)
以下罗列一些问题：
- 解析日志文件时GoAccess的速度有多快？
- GoAccess的内存占用量是多少？
- 我们如何配置Apache或Nginx的日志/日期/时间格式？
- 配置文件位于何处？
- 我如何配置IIS日志格式？
- 我如何生成静态HTML报告？
- 我如何生成实时HTML报告？
