extern addition
extern substract
extern multiply
extern divide
extern sin
extern cos
extern tan
extern vpush
extern vpop
extern x_values
extern y_values
extern spec_count
extern spec_operator
extern const
extern var
extern oper
extern symbol_iterator
extern temp

%macro inc_iterator 1
	push rax
	mov rax, symbol_iterator
	add rax, %1
	mov [symbol_iterator], rax
	pop rax
%endmacro

section .text
global evaluar_operador
evaluar_operador:
	push rax
	mov al, [symbol_iterator]
	; Switch selección de operaciones
	case_add:
		cmp al, addition
		jne case_sub
		call eval_add
		jmp switch_end
	case_sub:
		cmp al, substract
		jne case_mul
		call eval_sub
		jmp switch_end
	case_mul:
		cmp al, multiply
		jne case_divide
		call eval_mul
		jmp switch_end
	case_divide:
		cmp al, divide
		jne case_sin
		call eval_div
		jmp switch_end
	case_sin:
		cmp al, sin
		jne case_cos
		call eval_sin
		jmp switch_end
	case_cos:
		cmp al, cos
		jne case_tan
		call eval_cos
		jmp switch_end
	case_tan:			;Caso base... si algo no es symbolo es tangente :v
		call eval_tan
	switch_end:
	pop rax
	ret

;Envia simbolo a especial para evaluar luego
eval_add:
	push rdi
	mov rdi, [spec_count]
	mov [spec_operator + rdi], al	; Añade el symbolo a especiales
	inc rdi
	mov [spec_count], rdi
	pop rdi
	ret

;Envia simbolo a especial para evaluar luego
eval_sub:
	push rdi
	mov rdi, [spec_count]
	mov [spec_operator + rdi], al	; Añade el symbolo a especiales
	inc rdi
	mov [spec_count], rdi
	pop rdi
	ret

;Para las siguientes subrutinas el caso 3 de eval_symbol se ignora, el parser evita que
;2 simbolos de operacion se encuentren continuos, por lo que se evita el error de
;enciclarse entre lecturas
eval_mul:
	inc_iterator 1			; aumenta el iterador en 1 para ir al siguiente simbolo
	call eval_symbol		; no se puede dar caso 3, así que solo pushea var o const
	vmulps ymm10, ymm11, ymm10	;Realiza la multiplicacion entre los 2 primeros elementos de la pila
	ret

eval_div:
	inc_iterator 1			; aumenta el iterador en 1 para ir al siguiente simbolo
	call eval_symbol		; no se puede dar caso 3, así que solo pushea var o const
	vmulps ymm10, ymm11, ymm10	;Realiza la multiplicacion entre los 2 primeros elementos de la pila
	ret

eval_sin:
	inc_iterator 1
	call eval_symbol	;Push de var o const
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
	ret

eval_cos:
	inc_iterator 1
	call eval_symbol	;Push de var o const
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
	ret

eval_tan:
	inc_iterator 1
	call eval_symbol	;Push de var o const
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
	ret

;Pushea a VStack el intervalo X o Y correspondiente a la variable
global var_select
var_select:
	push rax
	mov rax, [symbol_iterator]
	push rdi					;Guarda el RDI
	cmp rax, 'x'	;Compara el puntero con x
	jne case_y
	mov rdi, x_values			;Pushea x a la pila
	call vpush
	case_y:
	mov rdi, y_values			;Pushea y a la pila
	call vpush
	pop rdi						;Devuelve RDI
	mov rax, symbol_iterator
	inc rax			;Incrementa el iterador en 1
	mov [symbol_iterator], rax
	pop rax
	ret

;Lee simbolo de iterador y ejecuta una acción
global eval_symbol
eval_symbol:
	push rsi
	push rdi
	;Switch de simbolos
	;Caso constante
	cmp byte[symbol_iterator], const
		jne case_var
		inc_iterator 1
		mov esi, [symbol_iterator]
		call fill_const
		mov rdi, temp
		call vpush	;Pushea temp, donde se guardan 8 copias del const
		inc_iterator 4	;vanza 4 valores de double al siguiente simbolo
		jmp fin_symbol
	;Caso variables
	case_var:
		cmp byte[symbol_iterator], var
		jne caso_operador
		inc_iterator 1
		call var_select	;Pushea el intervalo de x/y correspondiente
		inc_iterator 1	;Avanza al siguiente simbolo
		jmp fin_symbol
	;Caso operando
	caso_operador:
		inc_iterator 1
		call evaluar_operador
	fin_symbol:
	pop rdi
	pop rsi
	ret

	;Subrutina para copiar un numero de esi a 256b
fill_const:
	push rcx
	push rax
	xor rax, rax
	mov rcx, 8
	fill_loop:
	mov dword[temp + rax * 4], esi	;Llenado de temp
	inc rax
	loop fill_loop
	pop rax
	pop rcx
	ret
