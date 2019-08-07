yasm -f elf64 -g dwarf2 evaluacion.asm
yasm -f elf64 -g dwarf2 evalIter.asm
yasm -f elf64 -g dwarf2 pila.asm
yasm -f elf64 -g dwarf2 sumaFloats.asm

gcc -static pila.o evaluacion.o evalIter.o sumaFloats.o EvalTest.c -o EvalTest
