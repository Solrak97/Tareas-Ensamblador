; ----
%macro	dref_operands	3	;	%1 reg?, %2 cant mov, 3% destino
	cmp %1, 1			; Revisa si el operando es registro.
  je %%is_reg
  cmp %1, 2			; Revisa si el operando es memoria.
  je %%is_mem
  mov %3, %2			;	Mueve el inmediato al registro parametro
  jmp %%end_params
%%is_reg:					;	%1 es registro
	mov rax, qword[r13 + (%2 * 8)]
  jmp %%end_params
%%is_mem:				      ; %1 es memoria
	mov rax, qword[r14 + %2]	;	Mueve el contenido de r14 + %2 a parametro
%%end_params:
mov %3, rax
%endmacro

; ----
%macro dref_destino 3 ;	%1 reg?, %2 cant mov, 3% destino
	cmp %1, 1			; Revisa si el operando es registro.
	je %%is_reg
	add %2, r14
	mov rax, %2
	jmp %%end_params
%%is_reg:					;	%1 es registro
	shl %2, 3
	add %2, r13
	mov rax, %2
%%end_params:
	mov %3, rax
%endmacro

; ----
; Preparación de los registros para hacer call de operacion, sencillo pero conveniente
%macro oper_prep 3  ; %1 destino, %2 operando 1, %3 operando 2
  mov rdi, %1
  mov rsi, %2
  mov rdx, %3
%endmacro

; ----
; Instruccion de llamado
global instr
instr:
instr_prelude:  ; Backup de registros y toma de valores temporales
; los registros a guardar no estan en uso, sin embargo por convencion se guardaran
push r15
push r14
push r13
push r12  ;temporal 1
push r11  ;temporal 2
push r10  ;temporal 3
push rax  ;temporal 4
; Nota si los push cambian, cambiar la cantidad de desplazamiento en los mov
; Considere operando 1 como destino, operando 2 como operando 1 y operando 3 como operando 2
; Es posible usar menos variables temporales, pero por claridad se utilizan 3 en registro
mov r15, [rsp + (8*8)]  ; r15 = Parametro 7, operando 3
mov r14, [rsp + (9*8)]  ; r14 = parametro 8, direccion de "RAM"
mov r13, [rsp + (10*8)] ; r13 = parametro 9, direccion de Registros virtuales
instr_funct:
dref_operands cl, r8, r11   ; r10 = dref de operando 1
dref_operands r9b, r15, r12 ; r11 = dref de operando 2
dref_destino  sil, rdx, r10 ; r10 = destino de resultado

; Selección de operaciones
cmp dil, 4
je add_oper
oper_prep r10, r11, r12
call sub_instruction
jmp instr_epilogue
add_oper:
oper_prep r10, r11, r12
call add_instruction
instr_epilogue: ; Retorno de los registros guardados
pop rax
pop r10
pop r11
pop r12
pop r13
pop r14
pop r15
ret

; ----
;	Instruccion de suma
add_instruction:
  add rsi, rdx ; Efectua suma de parametro 2 y 3
  mov qword[rdi], rsi ; Mueve resultado a parametro
  ret

; ----
;	Instruccion de resta
sub_instruction:
  not rdx
  add rdx, 1
  call add_instruction
  ret
