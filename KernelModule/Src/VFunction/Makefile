#Create Module
obj-m += VFunction.o VFunction_main.o
VFunction-objs += evaluacion.o evalIter.o pila.o

#Global Variables
ASM	=	yasm
ASM_FLAGS	=	-f elf64 -g dwarf2
CC	=	gcc
CFlags = -static
#Make all
all: evaluacion.o evalIter.o pila.o sumaFloats.o
	make -C /lib/modules/4.19.59-1-MANJARO/build M=$(PWD) modules

test:	VFunction_main.c evaluacion.o evalIter.o pila.o
	$(CC) $(CFlags) VFunction_main.c evaluacion.o evalIter.o pila.o -o Test

evaluacion.o:	evaluacion.asm
	$(ASM) $(ASM_FLAGS) evaluacion.asm

evalIter.o: evalIter.asm
	$(ASM) $(ASM_FLAGS) evalIter.asm

pila.o:	pila.asm
	$(ASM) $(ASM_FLAGS) pila.asm

sumaFloats.o: sumaFloats.asm
	$(ASM) $(ASM_FLAGS) sumaFloats.asm
clean:
	rm *.o
	rm .*
	rm -r .*
	rm *.ord*
	clear
