#### 代码管理方案
- 分支 hexo   用来存放hexo原始的开发文件
- 主线 master 用来存放生成的静态网页

#### 拉取hexo分支代码
```
git clone git@github.com:coffeezf/coffeezf.github.io.git
cd coffeezf.github.io/
# 获取远程分支hexo 到本地新分支hexo，并跳到hexo分支
git checkout origin/hexo -b hexo
```

#### 从零搭建恢复博客开发环境
- 前提工作
  
  ```
  # 安装好node.js
  # 安装好git
  # 通过nodejs的npm命令安装好hexo及其他需要的插件
  npm install -g hexo
  # hexo 提交git插件
  npm install hexo-deployer-git -–save
  # 其他插件
  npm install hexo-generator-searchdb --save
  npm install gulp -g
  npm install gulp-minify-css gulp-uglify gulp-htmlmin gulp-htmlclean gulp --save
  ```
  
- 新建博客目录
  
  ```
  mkdir demo
  cd demo
  ```
  
- hexo环境初始化
  ```
  hexo init
  ```
  
- 下载next主题
  ```
  git clone https://github.com/theme-next/hexo-theme-next themes/next
  # 下载完的主题，要删掉其中的.git
  ```
  
- 修改站点配置文件和主题配置文件，调整相关参数，具体参考hexo和next主题官网

  - 修改_config.yml，主要修改项：

    ```
    # 1. 站点信息，包括语言
    title: Coffeezf's Blog
    subtitle:
    description: 磨刀不误砍柴工
    keywords:
    author: Coffee
    language: zh-CN
    timezone: Asia/Shanghai
    
    # 2. 菜单及创建分类页
    menu项打开tags、categories、tags页面，同时命令行执行以下三条命令:
    #hexo new page about
    #hexo new page categories
    #hexo new page tags
    
    # 3. 设置主题风格为next
    theme: next
    
    # 4. 与github关联发布
    deploy:
      type: git
      repository: git@github.com:coffeezf/coffeezf.github.io.git
      branch: master
    ```

  - 修改themes/next/_config.yml

  ```
  # 1. 设置作者头像
  # 开启avatar: url属性，并更换图片，图片位置themes/next/source下，或者独立在source/下新建images目录，放入图片，独立于next内容
  avatar:
    url: /images/avatar.gif
  
  # 2. 侧边栏社交链接，根据需要开启
  social：
  
  # 3. 开启打赏功能，可以开启微信和支付宝收款二维码地址
  reword：
  
  # 4. 开启友情链接 or 侧边栏推荐阅读
  links：
  
  # 5. 设置rss
  rss：
  
  # 6. 设置网站图标
  favicon：
  ```

- 注意拷贝hexo分支中以下文件
  
  ```
  git_auto_commit.sh
  README.md
  gulpfile.js
  ```
  
- 可以开始创建markdown博文了
  
  ```
  hexo new post "xxx"
  ```

#### hexo常用命令

```
# 创建markdown文件，在source->_posts文件夹内生成一个.md文件
hexo new post "xxx"
# 删除本地静态文件（Public目录）
hexo clean
# 本地生成静态文件（Public目录）
hexo g
# 将本地静态文件推送至Github仓库
hexo d
```

更多命令参考[hexo指令]( https://hexo.io/zh-cn/docs/commands.html )