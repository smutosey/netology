# Напишите скрипт, который выводит на экран все числа от 1 до 100, которые делятся на 3.
#!/bin/bash
for ((i=1; i < 100; i+=1)) do
     [ $(( $i % 3 )) == 0 ] && echo $i;
done