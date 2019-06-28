# @Author: Luis Carlos Quesada <solrak>
# @Date:   2019-06-18T22:12:11-06:00
# @Email:  luiscarlosquesada@gmail.com
# @Filename: Makefile
# @Last modified by:   solrak
# @Last modified time: 2019-06-18T22:34:57-06:00



tp4  : tp4.c fun.o
	gcc -static fun.o tp4.c -o tp4

fun.o : fun.asm
	yasm fun.asm -o fun.o -f elf64 -g dwarf2

clean :
	rm fun.o tp4.o
