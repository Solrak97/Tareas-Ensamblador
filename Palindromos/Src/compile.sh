# @Author: Luis Carlos Quesada <solrak>
# @Date:   2019-04-23T19:19:44-06:00
# @Email:  luiscarlosquesada@gmail.com
# @Filename: compile.sh
# @Last modified by:   solrak
# @Last modified time: 2019-04-28T15:42:19-06:00

#Ensamblar el programa con la primer mitad de los datos
yasm -g dwarf2 -f elf64 parteA.asm -l ListaA.lst

#Linkear el programa con la primer mitad de los datos
gcc -static -o parteA parteA.o


#Ensamblar el programa con la segunda mitad de los datos
yasm -g dwarf2 -f elf64 parteB.asm -l ListaB.lst

#Linkear el programa con la primer mitad de los datos
gcc -static -o parteB parteB.o
