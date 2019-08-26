#!/bin/sh
source_list=$1
target_path=$2
for i in $(cat ${source_list}); do mv "$i" ${target_path}; done
