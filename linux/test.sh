#! /bin/bash 

#var="thsi is test"
#echo $var
#var="this is test too"
#echo ${#var}
#echo $var
#
#unset var
##数组操作
#echo $var
#arr=(1 2 3 4 5)
#
#echo ${arr[1]}
#echo ${arr[@]}
#
##字符串截取，#表示从左开始，%表示从右边开始
## ##表示左边开始的最后（最右边）
## %%表示右边开始的最后（最左边）
#string="this is a string"
#echo ${string#*h}
#echo ${string##*is}
#
#echo "$@"
#echo "$*"
#
#aaaa="$@"
#./aaa.txt
#error=$?
#echo $error
#if [[ $error == 0  ]]
#then
#    echo "no error"
#else
#    echo "has error"
#fi
#echo $?
#
#for i in a b c d
#do
#    echo $i 
#done
#
#j=0
#while [[ $j < 4  ]]
#do 
#    let j++
#    echo $j
#done
#
#

## -d判断目录是否存在
## -f判断文件是否存在
## -e判断文件或目录是否存在
## -w文件是否可写
## -r文件是否可读
#if [ -d YouCompleteMe ]
#then
#    echo "this is a file"
#else
#    echo "unknown"
#fi
#
#
#if [ -w a.txt  ]
#then
#    echo "ececutable"
#fi
#
#
#func()
#{
#    expr
#}
#
##func
#
#if [ ! -f aaa.txt  ]
#then
#    echo not exit
#fi
#
##文件遍历
#readDir()
#{
#
#    files=`ls $1`
#    for file in $files
#    do
#        if [ -d $1'/'$file  ]
#        then
#            readDir $1'/'$file
#        else
#            echo "$1/$file"
#        fi
#    done
#}
#
#readDir /

##遍历目录，找到指定后缀的文件
#findFile()
#{
#    files=`ls $1`
#    for file in $files
#    do
#        subfile="$1/$file"
#        if [ -d $subfile ]
#        then
#            findFile $subfile $2
#        elif [ -f $subfile ]
#        then
#            extention=${subfile##*.}
#            if [[ $extention == $2 ]]
#            then
#                echo $subfile
#            fi
#        fi
#    done
#}
#
#
#findFile .  py


