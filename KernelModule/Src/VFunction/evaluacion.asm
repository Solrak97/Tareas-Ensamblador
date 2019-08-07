section .data
	global ptr_valX, ptr_valY
	global ptr_retr, fun_iter
	ptr_valX	dq 0	;puntero valores de x
	ptr_valY	dq 0	;puntero valores de y
	ptr_retr	dq 0	;puntero retorno
	fun_iter	dq 0	;iterador de la funcion
	neg1		dw -1.0

section .text
extern evalIter
extern spec_operator
extern vpush, vpop, temp
;Esta funcion evalua X, Y en la funncion en un unico punto
;Los loops de la funcion se manejan por fuera en C
;Para facilidad, será como evaluar f(X) = y

;RDI = puntero al inicio de la funcion
;RSI = puntero a valores de x
;RDX = puntero a valores de y
;RCX = puntero a donde retornar
global evaluacion
evaluacion:
;Push stack frame
	push rbp
	mov [fun_iter], rdi
	mov	[ptr_valX], rsi
	mov	[ptr_valY], rdx
	mov	[ptr_retr], rcx
	vpxor ymm10, ymm10		;Setea ymm10 en 0 por si hay un menos inicial
	loop_evaluacion:
		mov rdi, [fun_iter]
		call evalIter		;evalua la expresion
		mov rax, [fun_iter]
		mov eax, dword[rax]
		cmp eax, 0		;revisa si acabó la subrutina
		jne loop_evaluacion	;repite mientras no acabe
		fin_evaluacion:
		mov eax, [spec_operator]
		cmp eax, '+'
		je add_fst
			vsubps ymm11, ymm12, ymm11
			jmp fin_fst
		add_fst:
			vaddps ymm11, ymm12, ymm11
		fin_fst:
		mov eax, [spec_operator + 4]
		cmp eax, '+'
		je add_sec
			vsubps ymm10, ymm11, ymm10
			jmp fin_sec
		add_sec:
			vaddps ymm10, ymm11, ymm10
		fin_sec:
		mov rax, [ptr_retr]
		vmovups [rax], ymm10	;copia el resultado
	;Pop stack frame
	pop rbp
	ret
