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
  mov qword[CPU_registers + 8], 42
  mov qword[CPU_registers + 16], 24
  instruction_caller 8, 1, 0, 1, 1, 1, 2, RAM, CPU_registers

  mov rax, 60
  mov rdi, [CPU_registers]
  syscall
;exit 0
