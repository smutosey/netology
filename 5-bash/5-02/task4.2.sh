# скрипт проверки состояния системы с заданными условиями:
#   - loadavg1 < 1 за последние 2 минуты;
#   - memfree / memtotal < 60% за последние 3 минуты;
#   - diskfree / disktotal < 60% за последние 5 минут.
# Скрипт возвращает код ответа 0, если все условия выполняются, и любой другой в случае невыполнения.
# В консоль выводится, какое именно из условий не выполняется.

# P.S. не самое изящное решение, но зато удобное, компактное и расширяемое

#!/bin/bash
log_file="/home/nedorezov/5-02/system.log"
WARN_PATTERN="\t\033[0;31mПРОБЛЕМА: \033[0m"

check () {
    # Функция анализирует логи за период $2 в файле $log_file по входящим параметрам
    #   $1 - Имя параметра, необходимо для вывода
    #   $2 - время (в минутах), за которое анализирем логи
    #   $3 - граничный показатель (может быть 1, либо в %)
    #   $4 - номер колонки в логах с измеряемой характеристикой (loadavg1, memfree, diskfree)
    #   $5 - номер колонки с абсолютной величиной характеристики в (memtotal, disktotal). 
    #        В случае её отсутствия заполняется служебным значением "100" (костыль), необходимо для loadavg1
    #   Алгоритм:
    #       -> вычисляем период сбора логов;
    #       -> берем логи из файла за этот период и по номерам колонок ($4 и $5 на входе) вычисляем показатель;
    #       -> при этом с помощью sed подменяем точку на запятую (и обратно), т.к. awk работает почему-то только с запятыми, а bc только с точкой
    #       -> сравниваем полученный показатель с граничным значением ($3). Если превышает, то возвращает 1, если ок, то 0.
    
    period=$(date --date="-$2 min" -Iseconds)
    value=$(tail -n 100 $log_file \
        | awk -v p="$period" '$1 >= p' \
        | sed 's/\./,/g' \
        | awk -v c1=$4 -v c2=$5 'BEGIN{max=0} $100=100 {if ($c1>0+max) max=$c1} END{print (max*100)/$c2}' OFMT="%.5f" \
        | sed 's/,/\./g' )
    echo "$1: $value"
    result=$(echo "$value >= $3" | bc)
    return $result
}

while true; do
    clear
    check LOAD 2 1 2 100 || echo -e "$WARN_PATTERN loadavg1 превысило 1 за последние 2 минуты"
    check MEM 3 60 5 6 || echo -e "$WARN_PATTERN memfree / memtotal превысило 60% за последние 3 минуты"
    check DISK 5 60 7 8 || echo -e "$WARN_PATTERN diskfree / disktotal превысило 60% за последние 5 минут"
    sleep 5
done