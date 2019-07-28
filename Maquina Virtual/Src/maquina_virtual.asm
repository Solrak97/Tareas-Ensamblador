; ----

%macro exit 1
  mov rax, 60
  mov rdi, %1
  syscall
%endmacro

%macro instruction_caller 9
	mov dil, 	%1		; Codigo de operacion.
	mov sil,	%2		; Operando 1: Tipo.
	mov rdx,	%3		; Operando 1: Contenido.
	mov cl,		%4		; Operando 2: Tipo.
	mov r8,		%5		; Operando 2: Contenido.
	mov r9b, 	%6		; Operando 3: Tipo.
	push %9				; Operando 3: Contenido.
	push %8				; Direccion inicial del arreglo de bytes (RAM).
	push %7				; Direccion inicial del arreglo de 'registros' (CPU_registers).
	call instr
	add rsp, 24 		; Limpia los argumentos colocados en el stack.
%endmacro

; ----

section .data

RAM: times 1024 db 0 		; Un arreglo de 1024 bytes inicializado en cero.
CPU_registers: times 4 dq 0 ; Registros virtuales: R0, R1, R2, R3.

; ----

section .text
extern instr
global main

main:
	;	Adds a memoria en caso de ser necesarios
  	instruction_caller 4, 1, 0, 3, 100, 3, 0, RAM, CPU_registers

	instruction_caller 4, 2, 200, 1, 0, 3, 50, RAM, CPU_registers

	instruction_caller 8, 2, 40, 3, 1000, 2, 200, RAM, CPU_registers

 exit 0
