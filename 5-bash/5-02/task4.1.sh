# bash-скрипт который собирает информацию о системе и пишет ее в лог каждые 5 секунд.
# Используемые параметры:
#   - loadavg[1,5,15] средний показатель загрузки ЦПУ за последние 1 5 и 15 минут. 
#   - memfree количество свободной оперативной памяти в байтах. 
#   - memtotal количество всей оперативной памяти в байтах. 
#   - diskfree свободное место на диске подключенного к /. 
#   - disktotal общий объем диска подключенного к /.
# Формат записи: timestamp loadavg1 loadavg5 loadavg15 memfree memtotal diskfree disktotal

#!/bin/bash
while true; do
    timestamp=$(date -Iseconds)
    loadavg=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
    mem=$(free | awk '$1 == "Mem:" {print $4, $2}')
    disk=$(df | awk '$6 == "/" {print $4, $2}')
    echo $timestamp $loadavg $mem $disk >> system.log
    sleep 5
done
