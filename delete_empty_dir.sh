#!/bin/bash

empty_dir=($(find -type d -empty))
for item in ${empty_dir[@]};
do
echo $item
rm -rf $item
done
