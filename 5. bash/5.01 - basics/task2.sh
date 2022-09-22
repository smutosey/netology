# Напишите скрипт, который каждые 5 секунд будет выводить на экран текущее время и содержимое файла /proc/loadavg.
#!/bin/bash
while :
do
	date +'%R' && cat /proc/loadavg
    sleep 5
done