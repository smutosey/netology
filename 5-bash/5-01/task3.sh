# Напишите функцию для подсчета среднего размера файла в директории.
#   - путь к директории должен передаваться параметром;
#   - функция должна проверять, что такая директория существует, после чего выводить на экран средний размер файла в ней;
#   - при подсчете необходимо исключить поддиректории и символьные ссылки.

#!/bin/bash
avg_size () {
    let sum_size=0
    let count=0
    if [[ -d $1 ]]; then 
        echo ">>>>>>>>>> Path $1"
        for file in $1/*
        do
            if [[ ! -d $file && ! -h $file ]]; then
                # file is not dir and not symbol link"
                (( sum_size+=$(stat -c %s $file) ))
                (( count+=1 ))
            fi;
        done
        if [[ $count == 0 ]]; then 
            echo "Path is empty"
        else
            echo "Average file size: $sum_size / $count = $(($sum_size / $count)) bytes"
        fi;
    else 
        echo ">>>>>>>>>> Path not exists: $1 "
    fi;
}

avg_size "/home/nedorezov"
avg_size "/d/netology-homeworks/netology"
avg_size "/tmp/"