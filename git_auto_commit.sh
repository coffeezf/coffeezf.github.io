echo "begin git push hexo..."

v_time=$(date +"%Y-%m-%d %T")

# 切换到分支hexo，维护好.gitignore文件，提交代码
git checkout hexo
git add .
echo "git commit -m 'commit ${v_time} $@'" |bash
#git push -f origin hexo
git pull origin hexo
git push origin hexo


echo "finish..."

