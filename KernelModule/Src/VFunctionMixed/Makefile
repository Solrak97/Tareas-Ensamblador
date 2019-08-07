ifneq ($(KERNELRELEASE),)
obj-m := vfunctiondev.o vfunction.o
vfunctiondev-objs := vfunction_dev.o error1.o error2.o error3.o error4.o error5.o error6.o error7.o error8.o error9.o esConstante.o verificaErrores.o identifica.o
vfunction-objs := VFunction_main.o constantes.o evaluacion_simple.o operaciones.o pila.o reserva_memoria.o
else
KDIR = /lib/modules/$(shell uname -r)/build
INSTDIR = /lib/modules/$(shell uname -r)

all: error1.o error2.o error3.o error4.o error5.o error6.o error7.o error8.o error9.o esConstante.o verificaErrores.o identifica.o reserva_memoria.o constantes.o pila.o operaciones.o evaluacion_simple.o
	make -C $(KDIR) CFLAGS=-fPIC  M=$(shell pwd) modules

install:
	cp vfunction.ko $(INSTDIR)
	cp vfunctiondev.ko $(INSTDIR)
	cp 30-vfunctiondev.rules /etc/udev/rules.d/
	depmod -a
	modprobe vfunction
	modprobe vfunctiondev

uninstall:
	-rmmod vfunctiondev
	-rmmod vfunction
	rm $(INSTDIR)/vfunction.ko
	rm $(INSTDIR)/vfunctiondev.ko
	rm /etc/udev/rules.d/30-vfunctiondev.rules
	depmod -a

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

constantes.o: asm/constantes.asm
	nasm -f elf64 asm/constantes.asm -o constantes.o

eval_symbol.o: asm/eval_symbol.asm
	nasm -f elf64 asm/eval_symbol.asm -o eval_symbol.o

evaluacion_doble.o: asm/evaluacion_doble.asm
	nasm -f elf64 asm/evaluacion_doble.asm -o evaluacion_doble.o

evaluacion_simple.o: asm/evaluacion_simple.asm
	nasm -f elf64 asm/evaluacion_simple.asm -o evaluacion_simple.o

operaciones.o: asm/operaciones.asm
	nasm -f elf64 asm/operaciones.asm -o operaciones.o

pila.o: asm/pila.asm
	nasm -f elf64 asm/pila.asm -o pila.o

reserva_memoria.o: asm/reserva_memoria.asm
	nasm -f elf64 asm/reserva_memoria.asm -o reserva_memoria.o

clean:
	make -C $(KDIR)  M=$(shell pwd) clean

endif
