---
title: Hexo搭建博客教程
date: 2019-11-04 16:53:19
tags: hexo
categories: tools
---

现在越来越多的人喜欢利用Github搭建静态网站，原因不外乎简单省钱。本人也利用hexo+github搭建了本博客，用于分享一些心得。在此过程中，折腾博客的各种配置以及功能占具了我一部分时间，在此详细记录下我是如何利用hexo+github搭建静态博客以及一些配置相关问题，以免过后遗忘，且当备份之用。

<!-- more -->

参考：
[hexo官网](https://hexo.io/zh-cn/)
[hexo＋next主题配置官网]( https://theme-next.org/docs/getting-started/ )
[nMask 的 Hexo搭建博客教程](https://thief.one/2017/03/03/Hexo%E6%90%AD%E5%BB%BA%E5%8D%9A%E5%AE%A2%E6%95%99%E7%A8%8B/)
[Hexo的Next主题详细配置](https://www.jianshu.com/p/3a05351a37dc)
[github pages +hexo 博客搭建，Next主题个性化修改](https://www.lixint.me/hexo-blog.html)

### 准备工作
- 下载node.js并安装（官网下载安装），默认会安装npm。

- 下载安装git（官网下载安装）

- 通过npm安装hexo。打开cmd 运行命令：

  ```
  npm install -g hexo
  ```

### 本地搭建hexo静态博客

- 创建博客写作目录：  *mkdir blog_coffee*
- cd到blog_coffee目录下，初始化hexo：  *hexo init*
- 启动hexo服务：  *hexo server*
- 测试本地是否能访问自己的博客http://localhost:4000/

### 将博客与Github关联
- 在Github上创建名字为XXX.github.io的项目，XXX为自己的github用户名。
- 打开本地的blog_coffee文件夹项目内的_config.yml配置文件，将其中的deploy 相关配置设置为git
```
deploy:
  type: git
  repository: git@github.com:coffeezf/coffeezf.github.io.git
  branch: master
```

- 安装hexo git发布插件，运行：*npm install hexo-deployer-git –save*
- 至此，博客已经搭建好，也能通过github的域名访问。也可以设置将自己的域名绑定到github这个博客项目上。可以在阿里云上买了一个域名，将博客绑定自己的域名。

### 更新博客内容（写markdown文件）
至此博客已经搭建完毕，域名也已经正常解析，那么剩下的问题就是更新内容了。

#### 更新文章
- 在blog_coffee目录下执行：*hexo new "我的第一篇文章"*，会在source->_posts文件夹内生成一个.md文件。
- 编辑该文件（遵循Markdown规则）
- 修改起始字段
  - title 文章的标题
  - date 创建日期 （文件的创建日期 ）
  - updated 修改日期 （ 文件的修改日期）
  - comments 是否开启评论 true
  - tags 标签
  - categories 分类
  - permalink url中的名字（文件名）
- 编写正文内容（MakeDown）
- *hexo clean* 删除本地静态文件（Public目录），可不执行。
- *hexo g* 生成本地静态文件（Public目录）
- *hexo deploy* 将本地静态文件推送至github（或者 *hexo d*）
- 补充：hexo常用命令如下。更多命令参考[hexo 命令](https://hexo.io/zh-cn/docs/commands.html)
```
hexo new "文章名"     在source->_posts文件夹内生成一个.md文件
hexo clean           删除本地静态文件（Public目录）
hexo g               本地生成静态文件（Public目录）
hexo d               将本地静态文件推送至Github
```

### 使用next主题
访问[主题列表](http://www.zhihu.com/question/24422335)，获取主题代码。
这里以next主题示例

#### 安装主题
- 下载主题
  ```
  cd blog_coffee
  # 新版本
  git clone https://github.com/theme-next/hexo-theme-next themes/next
  ```
  
- 启用主题：开_config.yml文件，将theme修改为next

- 验证主题： *hexo s --debug* 启调试模式.注意观察命令行输出是否有任何异常信息，如果你碰到问题，这些信息将帮助他人更好的定位错误。

#### 设置主题
hexo-next主题下的一些个性化配置，参考：[Next主题配置](http://theme-next.iissnan.com/)
编辑主题配置文件_config.yml文件：

- 选择 scheme风格（不做调整）

- 设置 languge语言，修改hexo配置文件_config.yml

```
  language： zh_CN
```

- 设置 menu菜单 ：菜单配置包括三个部分，第一是菜单项（名称和链接），第二是菜单项的显示文本，第三是菜单项对应的图标。

  - 设定菜单内容 menu，开启about、tags、categories
    
  ```
    menu:
      home: / || home
      about: /about/ || user
      tags: /tags/ || tags
      categories: /categories/ || th
      archives: /archives/ || archive
      #schedule: /schedule/ || calendar
      #sitemap: /sitemap.xml || sitemap
      #commonweal: /404/ || heartbeat
  ```

  - 让菜单生效，执行下面命令，生成相关分类页面：
    ```
    hexo new page tags
    hexo new page categories
    hexo new page about
    ```
    
  - 参考[Hexo的Next主题详细配置](https://www.jianshu.com/p/3a05351a37dc)

- 设置 sidebar 侧栏

- 设置 avatar 头像（替换主题配置文件avatar属性gif文件，并开启路径）

  ```
  avatar:
    # Replace the default image and set the url here.
    url: /images/avatar.gif
  ```

- 设置 author 作者昵称（修改hexo中_config.yml中author属性）

- 设置 description 站点描述（修改hexo中_config.yml中description属性）

#### 添加categories模块
- 新建一个分类页面*hexo new page categories*
- 你会发现你的source文件夹下有了categorcies/index.md，打开index.md文件将title设置为title: 分类
- 打开 主题配置文件 找到menu，将categorcies取消注释
- 把文章归入分类只需在文章的顶部标题下方添加categories字段，即可自动创建分类名并加入对应的分类中
- 举个例子：
  ```
  title: 分类测试文章标题
  categories: 分类名
  ```

#### 添加tags模块
- 新建一个标签页面*hexo new page tags*
- 你会发现你的source文件夹下有了tags/index.md，打开index.md文件将title设置为title: 标签
- 打开 主题配置文件 找到menu，将tags取消注释
- 把文章添加标签只需在文章的顶部标题下方添加tags字段，即可自动创建标签名并归入对应的标签中
- 举个例子：
  ```
  title: 标签测试文章标题
  tags: 
    - 标签1
    - 标签2
    ...
  ```

#### 添加about模块
- 新建一个关于页面*hexo new page about*
- 你会发现你的source文件夹下有了about/index.md，打开index.md文件即可编辑关于你的信息，可以随便编辑。
- 打开 主题配置文件 找到menu，将about取消注释

#### 添加search功能
- 安装 [hexo-generator-searchdb](https://link.jianshu.com/?t=https%3A%2F%2Fgithub.com%2Fflashlab%2Fhexo-generator-search) 插件
  ```
  npm install hexo-generator-searchdb --save
  ```
- 打开 站点配置文件 找到Extensions在下面添加
  ```
  # search
  search:
    path: search.xml
    field: post
    format: html
    limit: 10000
  ```
- 打开 主题配置文件 找到Local search，将enable设置为true

#### 添加阅读全文按钮
在首页显示一篇文章的部分内容，并提供一个链接跳转到全文页面是一个常见的需求。 NexT 提供三种方式来控制文章在首页的显示方式。 也就是说，在首页显示文章的摘录并显示 阅读全文 按钮，可以通过以下方法：
- 在文章中使用 <!-- more --> 手动进行截断，Hexo 提供的方式 推荐
- 在文章的 [front-matter](https://hexo.io/docs/front-matter.html) 中添加 description，并提供文章摘录
- 自动形成摘要，在 主题配置文件 中添加：
  ```
  auto_excerpt:
    enable: true
    length: 150
  ```
  默认截取的长度为 150 字符，可以根据需要自行设定
> 建议使用 <!-- more -->（即第一种方式），除了可以精确控制需要显示的摘录内容以外， 这种方式也可以让 Hexo 中的插件更好的识别。

#### 博文压缩
在站点的根目录下执行以下命令：
```
npm install gulp -g
npm install gulp-minify-css gulp-uglify gulp-htmlmin gulp-htmlclean gulp --save
```

在博客根目录下新建 gulpfile.js ，并填入以下内容：
```
var gulp = require('gulp');
var minifycss = require('gulp-minify-css');
var uglify = require('gulp-uglify');
var htmlmin = require('gulp-htmlmin');
var htmlclean = require('gulp-htmlclean');
// 压缩 public 目录 css
gulp.task('minify-css', function() {
    return gulp.src('./public/**/*.css')
        .pipe(minifycss())
        .pipe(gulp.dest('./public'));
});
// 压缩 public 目录 html
gulp.task('minify-html', function() {
  return gulp.src('./public/**/*.html')
    .pipe(htmlclean())
    .pipe(htmlmin({
         removeComments: true,
         minifyJS: true,
         minifyCSS: true,
         minifyURLs: true,
    }))
    .pipe(gulp.dest('./public'))
});
// 压缩 public/js 目录 js
gulp.task('minify-js', function() {
    return gulp.src('./public/**/*.js')
        .pipe(uglify())
        .pipe(gulp.dest('./public'));
});
// 执行 gulp 命令时执行的任务
gulp.task('default', [
    'minify-html','minify-css','minify-js'
]);
```

生成博文是执行 hexo g && gulp 就会根据 gulpfile.js 中的配置，对 public 目录中的静态资源文件进行压缩。

更多内容请参考[Hexo搭建博客教程](https://thief.one/)



