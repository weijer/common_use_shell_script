#!/bin/bash

# 创建更新目录
rm -rf update_dir
mkdir update_dir

# 获取最新得两个tag
# last_two_tags=($(git describe --tags `git rev-list --tags --max-count=2`))
last_two_tags=($(git tag -l))
last_two_tags_len=${#last_two_tags[*]}


# 获取去除tag其他标识
first_real_tag=${last_two_tags[$last_two_tags_len-1]}
second_real_tag=${last_two_tags[$last_two_tags_len-2]}

echo "----------------当前对比两个版本-----------------"
echo $first_real_tag
echo $second_real_tag

# 创建删除文件列表shell
touch ./update_dir/jenkins_update.sh
echo "#!/bin/bash" >> update_dir/jenkins_update.sh

# 把要删除得文件写入shell脚本
delete_file_list=($(git diff $second_real_tag $first_real_tag --name-only --diff-filter=D))
echo "----------------把要删除得文件写入shell脚本-----------------"
for item in ${delete_file_list[@]};
do
echo $item
echo "rm -rf ${item}" >> update_dir/jenkins_update.sh
done

# 把重命名的文件也加入删除shell脚本
rename_file_list=($(git diff $first_real_tag $second_real_tag --name-only --diff-filter=R))
echo "----------------把重命名的文件也加入删除shell脚本-----------------"
for item in ${rename_file_list[@]};
do
echo $item
echo "rm -rf ${item}" >> update_dir/jenkins_update.sh
done

echo "----------------拷贝要更新的文件到update_dir文件夹-----------------"
# 复制当前版本差异到 update_dir 限制 Add Create Modify Rename 操作
new_file=($(git diff $second_real_tag $first_real_tag --name-only --diff-filter=ACMR))
new_file_len=${#new_file[*]}
if (($new_file_len>0)); then
    cp -pv --parents $(git diff $second_real_tag $first_real_tag --name-only --diff-filter=ACMR)  ./update_dir/
fi
