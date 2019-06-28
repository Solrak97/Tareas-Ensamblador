# @Author: Luis Carlos Quesada <solrak>
# @Date:   2019-06-14T04:02:40-06:00
# @Email:  luiscarlosquesada@gmail.com
# @Filename: Make.sh
# @Last modified by:   solrak
# @Last modified time: 2019-06-16T23:05:03-06:00

yasm regla_falsi.asm -f elf64 -g dwarf2 -o regla_falsi.o -l regla_falsi.lst
#yasm math.asm -f elf64 -g dwarf2 -o math.o -l math.lst IDK el linker no me esta aceptando esto
gcc -static regla_falsi.o -o falsi
