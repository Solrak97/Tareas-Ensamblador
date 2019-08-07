mkdir o

#Ensamblador de VFunctionDev
nasm -f elf64 asm/error1.asm -o o/error1.o
nasm -f elf64 asm/error2.asm -o o/error2.o
nasm -f elf64 asm/error3.asm -o o/error3.o
nasm -f elf64 asm/error4.asm -o o/error4.o
nasm -f elf64 asm/error5.asm -o o/error5.o
nasm -f elf64 asm/error6.asm -o o/error6.o
nasm -f elf64 asm/error7.asm -o o/error7.o
nasm -f elf64 asm/error8.asm -o o/error8.o
nasm -f elf64 asm/error9.asm -o o/error9.o
nasm -f elf64 asm/esConstante.asm -o o/esConstante.o
nasm -f elf64 asm/verificaErrores.asm -o o/verificaErrores.o
nasm -f elf64 asm/identifica.asm -o o/identifica.o

#Ensamblador de VFunction
nasm -f elf64 asm/evalIter.asm -o o/evalIter.o
nasm -f elf64 asm/evaluacion.asm -o o/evaluacion.o
nasm -f elf64 asm/pila.asm -o o/pila.o

#Archivos de C
gcc -g -Wall -c VFunctionDev.c
gcc -g -Wall -c VFunction.c
gcc -g -Wall -c userApp.c
gcc -g -Wall -c EvalTest.c

#Linkear
gcc -static -o app userApp.o VFunctionDev.o VFunction.o o/*.o

#Limpia
rm o/* userApp.o VFunction.o VFunctionDev.o
rm -rf o
