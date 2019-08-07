extern ptr_valX, ptr_valY
extern ptr_retr, fun_iter
extern vpush, vpop

%macro incIter 0
	push rax
	mov rax, [fun_iter]
	add rax, 4
	mov [fun_iter], rax
	pop rax
%endmacro

%macro decIter 0
	push rax
	mov rax, [fun_iter]
	sub rax, 4
	mov [fun_iter], rax
	pop rax
%endmacro

global spec_operator
global spec_count
global temp
section .data
	const	equ 1
	var	equ 2
	oper	equ 3
	spec_count dq 0

section .bss
temp resd 8
spec_operator resd 2

section .text
;Lee simbolo de iterador y ejecuta una acción
;rdi = iterador
global evalIter
evalIter:
	push rax
	mov eax, [rdi]	;desreferencia el iterador
	cmp eax, const
		je	evalConst
	cmp eax, var
		je	evalVar
	cmp eax, oper
		jmp evalOper
	finEvalIter:
	incIter			;itera a travez de la funcion
	pop rax			;ningun otro metodo debe terminaro
	ret				;con incIter
	;las iteraciones en la funcion las maneja eval
	;solo se itera dentro en casos de ser un operador
	;con 2 operandos


;Si lo que sigue es constante, entonces
;se guarda esa constante en pila
evalConst:
	push rdi
	incIter	;avanza al siguiente double
	mov rdi, temp
	call vpush			;Pushea basura a la pila
	mov rdi, [fun_iter]
	vcvtsi2ss xmm0, dword[rdi]	;desreferencia iterador en edi
	movss dword[temp], xmm0
	vbroadcastss ymm10, [temp]	;reemplaza con la constante
	pop rdi
	jmp finEvalIter

;Si lo que sigue es variable
;Se guarda esa variable a la pila
evalVar:
	push rdi
	incIter	;avanza al siguiente double
	mov rdi, [fun_iter]
	mov edi, [rdi]	;desreferencia iterador en edi
	cmp edi, 'x'		;revisa si la variable es X o Y
	jne es_Y
		mov rdi, [ptr_valX]
		call vpush		;Pushea X en la pila
		jmp fin_evalVar
	es_Y:
		mov rdi, [ptr_valY]
		call vpush		;Pushea Y en la pila
		fin_evalVar:
	pop rdi
	jmp finEvalIter

;Si lo que sigue es un operador
;se evalua ese operador (Cuidado con los dobles)
evalOper:
	push rax
	incIter	;incrementa el iterador a posicion actual
	mov rax, [fun_iter]
	mov al, [rax]
	; Switch selección de operaciones
	cmp al, '+'
		je eval_esp
	cmp al, '-'
		je eval_esp
	cmp al, '*'
		je eval_mul
	cmp al, '/'
		je eval_div
	cmp al, 's'
		je eval_sin
	cmp al, 'c'
		je eval_cos
	jmp eval_tan ;caso base, tangente
	fin_evalOper:
	pop rax
	jmp finEvalIter	;retorna a evalIter

	;Envia simbolo a especial para evaluar luego
eval_esp:
	push rdi
	mov rdi, [spec_count]
	mov [spec_operator + rdi], al	; Añade el symbolo a especiales
	add rdi, 4
	mov [spec_count], rdi
	pop rdi
	jmp fin_evalOper

	;Para las siguientes subrutinas el caso 3 de eval_symbol se ignora, el parser evita que
	;2 simbolos de operacion se encuentren continuos, por lo que se evita el error de
	;enciclarse entre lecturas
eval_mul:
	incIter			; aumenta el iterador en 1 para ir al siguiente simbolo
	mov rdi, [fun_iter]
	call evalIter		; no se puede dar caso 3, así que solo pushea var o const
	vmulps ymm11, ymm11, ymm10	;Realiza la multiplicacion en la pila
	mov rdi, temp
	call vpop					;popea ymm10 y simula fmulp
	decIter
	jmp fin_evalOper

eval_div:
	incIter			; aumenta el iterador en 1 para ir al siguiente simbolo
	mov rdi, [fun_iter]
	call evalIter		; no se puede dar caso 3, así que solo pushea var o const
	vdivps ymm11, ymm10, ymm11	;Realiza la multiplicacion entre los 2 primeros elementos de la pila
	mov rdi, temp
	call vpop
	decIter
	jmp fin_evalOper

eval_sin:
	incIter
	mov rdi, [fun_iter]
	call evalIter	;Push de var o const
	push rax	;Contadores de temporal
	push rcx	;loop count
	sin_loop:
		vmovups [temp], ymm10		;Mueve el valor a calcular a temp
		fld qword[temp + rax * 4]
		fsin						;calcula seno del valor
		fstp qword[temp + rax * 4]	;lo retorna a temp
	loop sin_loop
	vmovups ymm10, [temp]	;retorna temp a ymm10
	pop rcx
	pop rax
	decIter
	jmp fin_evalOper

eval_cos:
	incIter
	mov rdi, [fun_iter]
	call evalIter	;Push de var o const
	push rax	;Contadores de temporal
	push rcx	;loop count
	cos_loop:
		vmovups [temp], ymm10		;Mueve el valor a calcular a temp
		fld qword[temp + rax * 4]
		fcos						;calcula seno del valor
		fstp qword[temp + rax * 4]	;lo retorna a temp
	loop cos_loop
	vmovups ymm10, [temp]	;retorna temp a ymm10
	pop rcx
	pop rax
	decIter
	jmp fin_evalOper

eval_tan:
	incIter
	mov rdi, [fun_iter]
	call evalIter	;Push de var o const
	push rax	;Contadores de temporal
	push rcx	;loop count
	tan_loop:
		vmovups [temp], ymm10		;Mueve el valor a calcular a temp
		fld qword[temp + rax * 4]
		fsin						;calcula seno
		fld qword[temp + rax * 4]
		fcos						;calcula coseno
		fdivr st0, st1				; tan = sen/cos
		fstp qword[temp + rax * 4]	;lo retorna a temp
	loop tan_loop
	vmovups ymm10, [temp]	;retorna temp a ymm10
	pop rcx
	pop rax
	decIter
	jmp fin_evalOper
