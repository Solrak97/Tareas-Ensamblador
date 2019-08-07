ifneq ($(KERNELRELEASE),)
obj-m := vfunctiondev.o
vfunctiondev-objs := vfunction_dev.o error1.o error2.o error3.o error4.o error5.o error6.o error7.o error8.o error9.o esConstante.o verificaErrores.o identifica.o
else
KDIR = /lib/modules/$(shell uname -r)/build

all: error1.o error2.o error3.o error4.o error5.o error6.o error7.o error8.o error9.o esConstante.o verificaErrores.o identifica.o
	make -C $(KDIR)  M=$(shell pwd) modules
	cp 30-vfunctiondev.rules /etc/udev/rules.d/

error1.o: asm/error1.asm
	nasm -f elf64 asm/error1.asm -o error1.o

error2.o: asm/error2.asm
	nasm -f elf64 asm/error2.asm -o error2.o

error3.o: asm/error3.asm
	nasm -f elf64 asm/error3.asm -o error3.o

error4.o: asm/error4.asm
	nasm -f elf64 asm/error4.asm -o error4.o

error5.o: asm/error5.asm
	nasm -f elf64 asm/error5.asm -o error5.o

error6.o: asm/error6.asm
	nasm -f elf64 asm/error6.asm -o error6.o

error7.o: asm/error7.asm
	nasm -f elf64 asm/error7.asm -o error7.o

error8.o: asm/error8.asm
	nasm -f elf64 asm/error8.asm -o error8.o

error9.o: asm/error9.asm
	nasm -f elf64 asm/error9.asm -o error9.o

esConstante.o: asm/esConstante.asm
	nasm -f elf64 asm/esConstante.asm -o esConstante.o

verificaErrores.o: asm/verificaErrores.asm
	nasm -f elf64 asm/verificaErrores.asm -o verificaErrores.o

identifica.o: asm/identifica.asm
	nasm -f elf64 asm/identifica.asm -o identifica.o

clean:
	make -C $(KDIR)  M=$(shell pwd) clean

endif
