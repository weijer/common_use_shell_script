#!/bin/bash

echo "----------------执行更新-----------------"
cd /home/wwwroot/test
chmod -R 777 jenkins_update.sh
./jenkins_update.sh

echo "----------------删除空文件夹-----------------"
empty_dir=($(find -type d -empty))
for item in ${empty_dir[@]};
do
echo $item
rm -rf $item
done

echo "----------------删除更新脚本-----------------"
rm -rf jenkins_update.sh

echo "----------------修改文件执行权限-----------------"
chown www:www -R  /home/wwwroot/test
chmod -R 777  /home/wwwroot/test/storage

echo "----------------更新成功-----------------"
exit 0
