# Напишите свой калькулятор.
# В нем реализуйте простейшие арифметические операции: «+»; «-»; «*»; «/».
# Считывание параметров реализуйте с помощью read и select.
# Примечение: постарайтесь максимально защититься от ошибок, т.к. пользователи любят написать строку вместо числа.



calc () {
  read -p "Введите первое число: " n1
  read -p "Введите второе число: " n2
  echo "$n1 $1 $n2 = " $(bc -l <<< "$n1$1$n2")
}

echo "Выберите операцию: "
while true do 
    select opt in "+" "-" "*" "/" do 
        calc $opt';
    done
done



# calculate () {
#   read -p "Введите первое число: " n1
#   read -p "Введите второе число: " n2
#   echo "$n1 $1 $n2 = " $(bc -l <<< "$n1$1$n2")
# }

# PS3="Выберите операцию: "

# select opt in add subtract multiply divide quit; do

#   case $opt in
#     add)
#       calculate "+";;
#     subtract)
#       calculate "-";;
#     multiply)
#       calculate "*";;
#     divide)
#       calculate "/";;
#     quit)
#       break;;
#     *) 
#       echo "Недопустимая опция $REPLY";;
#   esac
# done