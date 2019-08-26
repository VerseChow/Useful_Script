#!/bin/sh

task_list=(1111 1123 113 223 2323 211)

open_sem(){
    mkfifo pipe-$$
    exec 3<>pipe-$$
    rm pipe-$$
    local i=$1
    for((;i>0;i--)); do
        printf %s 000 >&3
    done
}

run_with_lock(){
    local x
    err=0
    read -u 3 -n 3 x && ((0==x)) || err=1
    (
    "$@"
    printf '%.3d' $? >&3
    ) &
    return $err
}

# run N tasks in parallel
N=6
open_sem $N

some_task () {
	(
		errs=0
		for i in "${@:2}"; do
			run_with_lock \
			echo $i
			r=$?
			errs=$((errs + r))
		done
		wait
		return $errs
	)
}

some_task batch_task ${task_list[@]}