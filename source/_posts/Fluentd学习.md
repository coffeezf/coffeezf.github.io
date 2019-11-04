---
title: Fluentd学习
date: 2018-04-10 15:58:22
tags: 
  - Fluentd
  - 数据收集
categories: tools
---

### 什么是Fluentd？
- Fluentd是一款完全免费且完全开源的日志收集器，可立即让您拥有125种以上系统的“ Log Everything ”体系结构。
- Fluentd将日志视为JSON，一种流行的机器可读格式。它主要是用C语言编写的，它提供了一个简单的Ruby包装器，为用户提供了灵活性。
- Fluentd的可扩展性已经在现场得到验证：目前其最大的用户正在收集来自50,000多台服务器的日志。

<!-- more -->

### 参考
[fluentd](https://www.fluentd.org/)
[fluentd Quickstart Guide](https://docs.fluentd.org/v1.0/articles/quickstart)
[Ruby 安装 - Linux](http://www.runoob.com/ruby/ruby-installation-unix.html)
[关于Bundler](http://xiajian.github.io/2014/10/22/bundle)
[fluentd 安装、配置、使用介绍](https://blog.laisky.com/p/fluentd/#安装-fluentd)

#### 特点
- 使用JSON进行统一日志记录：Fluentd尽可能将数据构建为JSON：这允许Fluentd 统一处理日志数据的所有方面：在多个源和目标（统一日志记录层）上收集，过滤，缓冲和输出日志。JSON使下游数据处理更加容易，因为它具有足够的结构以便在保留灵活模式的同时可访问。
- 可插入的体系结构：Fluentd有一个灵活的插件系统，允许社区扩展其功能。我们的500多个社区贡献的插件连接了数十个数据源和数据输出。通过利用插件，您可以立即开始更好地使用您的日志。
- 所需的最少资源：Fluentd是用C语言和Ruby的组合编写的，并且只需很少的系统资源。香草实例在30-40MB内存上运行，可以处理13,000个事件/秒/内核。如果您的内存需求更为紧张（-450kb），请查看Fluentd 的轻量级转发器Fluent Bit。
- 内置可靠性：Fluentd支持基于内存和文件的缓冲以防止节点间数据丢失。Fluentd还支持强大的故障转移功能，并可设置高可用性。2,000多家数据驱动型公司依靠Fluentd通过更好地使用和理解其日志数据来区分他们的产品和服务。

#### Fluentd历史
Fluentd 在2011年由Sadayuki “Sada” Furuhashi构思.Sada是Treasure Data，Inc.的共同创始人，该公司是Fluentd项目的主要赞助商。自2011年10月开放源代码以来，Fluentd项目发展迅猛：几十个贡献者，数百个社区贡献的插件，数以千计的用户以及数以万亿计的事件被收集，过滤和存储。目前Masahiro“Masa”Nakagawa是主要的维护者。


### 快速入门指南
#### 安装Fluentd
- [通过RPM包安装Fluentd](https://docs.fluentd.org/v1.0/articles/install-by-rpm)（Redhat Linux）
- [Deb包安装Fluentd](https://docs.fluentd.org/v1.0/articles/install-by-deb)（Ubuntu / Debian Linux）
  - 安装前
    - 设置NTP
	  - 强烈建议您在节点上设置NTP守护进程（例如chrony，ntpd等）以获得准确的当前时间戳。这对生产级记录服务至关重要。
	- 增加文件描述符的最大数量
	  - 可以使用该ulimit -n命令检查当前文件描述符的最大数量
	    ```
		ulimit -n
		```
	  - 如果你的控制台显示1024，它是不够的。请将以下几行添加到您的/etc/security/limits.conf文件并重新启动您的机器
	    ```
		root soft nofile 65536
		root hard nofile 65536
		* soft nofile 65536
		* hard nofile 65536
		```
	- 优化网络内核参数
	  - 由许多Fluentd实例组成的高负载环境，请将这些参数添加到您的/etc/sysctl.conf文件中。请输入sysctl -p或重新启动您的节点以使更改生效。
	    ```
        net.core.somaxconn = 1024
        net.core.netdev_max_backlog = 5000
        net.core.rmem_max = 16777216
        net.core.wmem_max = 16777216
        net.ipv4.tcp_wmem = 4096 12582912 16777216
        net.ipv4.tcp_rmem = 4096 12582912 16777216
        net.ipv4。 tcp_max_syn_backlog = 8096
        net.ipv4.tcp_slow_start_after_idle = 0
        net.ipv4.tcp_tw_reuse = 1
        net.ipv4.ip_local_port_range = 10240 65535
		```
      - 这些内核选项最初来自演示文稿“ Netflix如何调整EC2实例的性能 ”，由AWS Re：Invent 2017高级性能架构师Brendan Gregg提供
  - 安装（从Apt存储库进行安装）
    - CentOS 安装
	  ```
	  curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh
	  ```
  - 启动守护进程
    - systemd
      - /lib/systemd/system/td-agent脚本用于start，stop或restart agent
	    ```
	    sudo systemctl start td-agent.service
	    sudo systemctl status td-agent.service
	    ```
	  - 如果你想自定义系统行为，将 td-agent.service 添加到 /etc/systemd/system
	- init.d
	  - /etc/init.d/td-agent 脚本用来提供start，stop或者restart agent。
	    ```
		/etc/init.d/td-agent restart
		/etc/init.d/td-agent status
		```
	  - 下面的命令也支持：
	    ```
		/etc/init.d/td-agent start
		/etc/init.d/td-agent stop
		/etc/init.d/td-agent restart
		/etc/init.d/td-agent status
		```
	  - 请确保你的配置文件位置在/etc/td-agent/td-agent.conf
  - 通过HTTP发布示例日志
    - 默认情况下，/etc/td-agent/td-agent.conf配置为从HTTP获取日志并将它们路由到标准输出（/var/log/td-agent/td-agent.log）。您可以使用curl命令发布示例日志记录
	  ```
	  curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test
	  ```
  - 下一步
  请参阅以下教程以了解如何从各种数据源收集数据
  - 基本配置
    - [配置文件](https://docs.fluentd.org/v1.0/articles/config-file)
  - 应用程序日志
    - [Ruby](https://docs.fluentd.org/v1.0/articles/ruby),[Java](https://docs.fluentd.org/v1.0/articles/java),[Python](https://docs.fluentd.org/v1.0/articles/python),[PHP](https://docs.fluentd.org/v1.0/articles/php),[Perl](https://docs.fluentd.org/v1.0/articles/perl),[Node.js](https://docs.fluentd.org/v1.0/articles/nodejs),[Scala](https://docs.fluentd.org/v1.0/articles/scala)
  - 例子
    - [将Apache日志存储到Amazon S3中](https://docs.fluentd.org/v1.0/articles/apache-to-s3)
    - [将Apache日志存储到MongoDB中](https://docs.fluentd.org/v1.0/articles/apache-to-mongodb)
    - [将数据收集到HDFS中](https://docs.fluentd.org/v1.0/articles/http-to-hdfs)
  - 更多参考
    - [td-agentde的更新日志](http://docs.treasuredata.com/articles/td-agent-changelog)
    - [Chef Cookbook](https://github.com/treasure-data/chef-td-agent/)
    
- [通过MSI包安装Fluentd](https://docs.fluentd.org/v1.0/articles/install-by-msi)（Windows msi）
- [由Ruby Gem安装Fluentd](https://docs.fluentd.org/v1.0/articles/install-by-gem)
- [从源代码安装Fluentd](https://docs.fluentd.org/v1.0/articles/install-from-source)

#### 用例
下面显示的文章涵盖了Fluentd的典型用例。根据需求选择查看：
- 用例
  - [像Splunk一样进行数据搜索](https://docs.fluentd.org/v1.0/articles/free-alternative-to-splunk-by-fluentd)
  - [数据过滤和告警](https://docs.fluentd.org/v1.0/articles/splunk-like-grep-and-alert-email)
  - [有价值的数据分析](https://docs.fluentd.org/v1.0/articles/http-to-td)
  - [数据收集到MongoDB](https://docs.fluentd.org/v1.0/articles/apache-to-mongodb)
  - [数据收集到HDFS](https://docs.fluentd.org/v1.0/articles/http-to-hdfs)
  - [数据归档到Amazon S3](https://docs.fluentd.org/v1.0/articles/apache-to-s3)
- 基础配置
  - [config 文件](https://docs.fluentd.org/v1.0/articles/config-file)
- 应用日志
  - [Ruby](https://docs.fluentd.org/v1.0/articles/ruby),[Java](https://docs.fluentd.org/v1.0/articles/java),[Python](https://docs.fluentd.org/v1.0/articles/python),[PHP](https://docs.fluentd.org/v1.0/articles/php),[Perl](https://docs.fluentd.org/v1.0/articles/perl),[Node.js](https://docs.fluentd.org/v1.0/articles/nodejs),[Scala](https://docs.fluentd.org/v1.0/articles/scala)

#### 了解更多信息
下面显示的文章将提供详细信息，供您了解更多关于Fluentd的信息
- [架构概述](https://docs.fluentd.org/v1.0/articles/architecture)
- [一个Fluentd事件的生命周期](https://docs.fluentd.org/v1.0/articles/life-of-a-fluentd-event)
- 插件概述
  - [Input Plugins](https://docs.fluentd.org/v1.0/articles/input-plugin-overview)
  - [Output Plugins](https://docs.fluentd.org/v1.0/articles/output-plugin-overview)
  - [Buffer Plugins](https://docs.fluentd.org/v1.0/articles/buffer-plugin-overview)
  - [Filter Plugins](https://docs.fluentd.org/v1.0/articles/filter-plugin-overview)
  - [Parser Plugins](https://docs.fluentd.org/v1.0/articles/parser-plugin-overview)
  - [Formatter Plugins](https://docs.fluentd.org/v1.0/articles/formatter-plugin-overview)
- [高可用性配置](https://docs.fluentd.org/v1.0/articles/high-availability)
- [FAQ](https://docs.fluentd.org/v1.0/articles/faq)

------
### Fluentd常用帮助文档
- [Fluentd event的生命周期](https://docs.fluentd.org/v1.0/articles/life-of-a-fluentd-event)
- [配置文件语法](https://docs.fluentd.org/v1.0/articles/config-file)
- [Fluentd命令行选项](https://docs.fluentd.org/v1.0/articles/command-line-option)
- [Fluentd的UI界面](https://docs.fluentd.org/v1.0/articles/fluentd-ui)
- Fluent7大插件
  - Input Plugins
    - [in_tail](https://docs.fluentd.org/v1.0/categories/in_tail)
    - [in_forward](https://docs.fluentd.org/v1.0/categories/in_forward)
    - [in_udp](https://docs.fluentd.org/v1.0/categories/in_udp)
    - [in_tcp](https://docs.fluentd.org/v1.0/categories/in_tcp)
    - [in_http](https://docs.fluentd.org/v1.0/categories/in_http)
    - [in_syslog](https://docs.fluentd.org/v1.0/categories/in_syslog)
    - [in_exec](https://docs.fluentd.org/v1.0/categories/in_exec)
    - [in_dummy](https://docs.fluentd.org/v1.0/categories/in_dummy)
    - [in_monitor_agent](https://docs.fluentd.org/v1.0/categories/in_monitor_agent)
    - [in_windows_eventlog](https://docs.fluentd.org/v1.0/categories/in_windows_eventlog)
  - Output Plugins
    - [out_file](https://docs.fluentd.org/v1.0/categories/out_fil://docs.fluentd.org/v1.0/categories/out_file)
    - [out_s3](https://docs.fluentd.org/v1.0/categories/out_s3)
    - [out_elasticsearch](https://docs.fluentd.org/v1.0/categories/out_elasticsearch)
    - [out_forward](https://docs.fluentd.org/v1.0/categories/out_forward)
    - [out_exec](https://docs.fluentd.org/v1.0/categories/out_exec)
    - [out_exec_filter](https://docs.fluentd.org/v1.0/categories/out_exec_filter)
    - [out_copy](https://docs.fluentd.org/v1.0/categories/out_copy)
    - [out_roundrobin](https://docs.fluentd.org/v1.0/categories/out_roundrobin)
    - [out_stdout](https://docs.fluentd.org/v1.0/categories/out_stdout)
    - [out_null](https://docs.fluentd.org/v1.0/categories/out_null)
    - [out_mongo](https://docs.fluentd.org/v1.0/categories/out_mongo)
    - [out_mongo_replset](https://docs.fluentd.org/v1.0/categories/out_mongo_replset)
    - [out_relabel](https://docs.fluentd.org/v1.0/categories/out_relabel)
    - [out_rewrite_tag_filter](https://docs.fluentd.org/v1.0/categories/out_rewrite_tag_filter)
    - [out_webhdfs](https://docs.fluentd.org/v1.0/categories/out_webhdfs)
  - Filter Plugins
    - [filter_record_transformer](https://docs.fluentd.org/v1.0/categories/filter_record_transformer)
    - [filter_grep](https://docs.fluentd.org/v1.0/categories/filter_grep)
    - [filter_parser](https://docs.fluentd.org/v1.0/categories/filter_parser)
    - [filter_geoip](https://docs.fluentd.org/v1.0/categories/filter_geoip)
    - [filter_stdout](https://docs.fluentd.org/v1.0/categories/filter_stdout)
  - Parser Plugins
    - [parser_regexp](https://docs.fluentd.org/v1.0/categories/parser_regexp)
    - [parser_apache2](https://docs.fluentd.org/v1.0/categories/parser_apache2)
    - [parser_apache_error](https://docs.fluentd.org/v1.0/categories/parser_apache_error)
    - [parser_nginx](https://docs.fluentd.org/v1.0/categories/parser_nginx)
    - [parser_syslog](https://docs.fluentd.org/v1.0/categories/parser_syslog)
    - [parser_ltsv](https://docs.fluentd.org/v1.0/categories/parser_ltsv)
    - [parser_csv](https://docs.fluentd.org/v1.0/categories/parser_csv)
    - [parser_tsv](https://docs.fluentd.org/v1.0/categories/parser_tsv)
    - [parser_json](https://docs.fluentd.org/v1.0/categories/parser_json)
    - [parser_multiline](https://docs.fluentd.org/v1.0/categories/parser_multiline)
    - [parser_none](https://docs.fluentd.org/v1.0/categories/parser_none)
  - Formatter Plugins
    - [formatter_out_file](https://docs.fluentd.org/v1.0/categories/formatter_out_file)
	- [formatter_json](https://docs.fluentd.org/v1.0/categories/formatter_json)
	- [formatter_ltsv](https://docs.fluentd.org/v1.0/categories/formatter_ltsv)
	- [formatter_csv](https://docs.fluentd.org/v1.0/categories/formatter_csv)
	- [formatter_msgpack](https://docs.fluentd.org/v1.0/categories/formatter_msgpack)
	- [formatter_hash](https://docs.fluentd.org/v1.0/categories/formatter_hash)
	- [formatter_single_value](https://docs.fluentd.org/v1.0/categories/formatter_single_value)
	- [formatter_stdout](https://docs.fluentd.org/v1.0/categories/formatter_stdout)
  - Buffer Plugins
    - [buf_memory](https://docs.fluentd.org/v1.0/categories/buf_memory)
    - [buf_file](https://docs.fluentd.org/v1.0/categories/buf_file)
  - Storage Plugins
    - [storage_local](https://docs.fluentd.org/v1.0/categories/storage_local)
