# @Author: Luis Carlos Quesada <solrak>
# @Date:   2019-05-14T11:19:38-06:00
# @Email:  luiscarlosquesada@gmail.com
# @Filename: compile.sh
# @Last modified by:   solrak
# @Last modified time: 2019-05-14T11:31:17-06:00



yasm -g dwarf2 -f elf64 search.asm -l search.lst
yasm -g dwarf2 -f elf64 test.asm -l test.lst

gcc leehilera.o search.o -no-pie -o busqueda
ld test.o search.o -o test
