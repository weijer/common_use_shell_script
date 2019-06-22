#!/bin/bash

# 获取去除tag其他标识函数
function get_tag_real_name(){
   tag_real_tag_arr=(`echo $1 | tr '-' ' '`)
   len=${#tag_real_tag_arr[*]}
   if (($len>=2)); then
	 echo ${tag_real_tag_arr[@]:0:$len-2}
   else
	 echo $1
   fi
}

# 创建更新目录
rm -rf update_dir
mkdir update_dir

# 获取最新得两个tag
last_two_tags=($(git describe --tags `git rev-list --tags --max-count=2`))

# 获取去除tag其他标识
first_tag=${last_two_tags[0]}
second_tag=${last_two_tags[1]}

first_real_tag=$(get_tag_real_name $first_tag)
second_real_tag=$(get_tag_real_name $second_tag)

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

# 复制当前版本差异到 update_dir 限制 Add Create Modify Rename 操作
cp -pv --parents $(git diff $second_real_tag $first_real_tag --name-only --diff-filter=ACMR)  ./update_dir/
