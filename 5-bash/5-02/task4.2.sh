# Формат записи: timestamp loadavg1 loadavg5 loadavg15 memfree memtotal diskfree disktotal
# скрипт проверки состояния системы с заданными условиями:
#   - loadavg1 < 1 за последние 2 минуты;
#   - memfree / memtotal < 60% за последние 3 минуты;
#   - diskfree / disktotal < 60% за последние 5 минут.
# Скрипт должен возвращать 0 код ответа, если все условия выполняются, и любой другой в случае невыполнения.
# В консоль выводится, какое именно из условий не выполняется.

#!/bin/bash
log_file="/home/nedorezov/5-02/system.log"
WARN_PATTERN="\t\033[0;31mПРОБЛЕМА: \033[0m"

# check_loadavg () {
#     # Функция проверяет, что loadavg1 < X за N минут
#     period=$(date --date="-$1 min" -Iseconds)
#     load_max=$(tail -n 100 $log_file \
#         | awk -v p="$period" '$1 >= p' \
#         | awk 'BEGIN{max=0}{if ($2>0+max) max=$2} END{print max}' \
#         | sed 's/,/\./g')
#     echo "LOAD: $load_max"
#     result=$(echo "$load_max >= $2" | bc)
#     return $result
# }

# check_memory () {
#     period=$(date --date="-$1 min" -Iseconds)
#     memstat=$(tail -n 100 $log_file \
#         | awk -v p="$period" '$1 >= p' \
#         | awk 'BEGIN{max=0}{if (($5/$6)*100>0+max) max=($5/$6)*100} END{print max}' \
#         | sed 's/,/\./g')
#     echo "MEM: $memstat"
#     result=$(echo "$memstat >= $2" | bc)
#     return $result
# }

# check_disk () {
#     period=$(date --date="-$1 min" -Iseconds)
#     diskstat=$(tail -n 100 $log_file \
#         | awk -v p="$period" '$1 >= p' \
#         | awk 'BEGIN{max=0}{if (($7/$8)*100>0+max) max=($7/$8)*100} END{print max}' \
#         | sed 's/,/\./g')
#     echo "DISK: $diskstat"
#     result=$(echo "$diskstat >= $2" | bc)
#     return $result
# }

check () {
    period=$(date --date="-$2 min" -Iseconds)
    if [[$5==""]]; then
        $5=100
    fi;
    value=$(tail -n 100 $log_file \
        | awk -v p="$period" '$1 >= p' \
        | sed 's/\./,/g' \
        | awk -v c1=$4 -v c2=$5 \ 
            'BEGIN{max=0} \
            $100="100" \ 
            {if ($c1>0+max) max=$c1} \
            END{print (max*100)/$c2}' \
            OFMT="%.5f" \
        | sed 's/\./,/g' )
    echo "$1: $value"
    result=$(echo "$value >= $3" | bc)
    return $result
}

while true; do
    clear
    # check_loadavg 2 1 || echo -e "$WARN_PATTERN loadavg1 превысило 1 за последние 2 минуты"
    # check_memory 3 60 || echo -e "$WARN_PATTERN memfree / memtotal превысило 60% за последние 3 минуты"
    # check_disk 3 60 || echo -e "$WARN_PATTERN diskfree / disktotal превысило 60% за последние 5 минут"
    check LOAD 2 1 2
    check MEM 3 60 5 6
    check DISK 5 60 7 8
    sleep 5
done
