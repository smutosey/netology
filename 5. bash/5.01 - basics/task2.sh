# Напишите скрипт, который каждые 5 секунд будет выводить на экран текущее время и содержимое файла /proc/loadavg.
#!/bin/bash
while true; do
	date +'%T' && cat /proc/loadavg
    sleep 5
done