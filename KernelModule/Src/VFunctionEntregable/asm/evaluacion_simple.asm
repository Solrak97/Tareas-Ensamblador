extern function_ptr
extern interval_ptr
extern epsilon
extern x_quant
extern y_quant
extern symbol_iterator
extern x_values
extern y_values
extern temp
extern x_limit
extern y_limit
extern spec_operator
extern spec_count
extern x_rang
extern eval_symbol
extern Nan
extern return_ptr

;Paraemtros de la funcion
;=============================================
;RDI	= Funcion
;RSI	= Epsilon
;RDX	= Cantidad rangos x
;RCX	= Rangos
;R8		= Puntos
;R9		= No se usa
;=============================================
section .text
eval_start:
	mov [function_ptr], rdi
	mov [epsilon], rsi
	mov [x_quant], rdx
	mov [interval_ptr], rcx 			;Se usa r15 como el registro donde
	mov [return_ptr], r8				;r8 se almacena la solución
	ret

;calculo de rangos
rango_simple:
	push rcx
	push rax
	push rbx
	mov ecx, [x_quant]	;cantidad de rangos en x
	xor rax, rax		;contador
	loop_rangos:
		mov rbx, [interval_ptr + rax * 8] ;toma 2 floats de intervalos
		mov [x_rang + rax * 8], rbx	;pasa los floats a x_rang
		inc rax
		loop loop_rangos
		mov eax, [x_rang]
		mov [x_limit], eax
	pop rbx
	pop rax
	pop rcx
	ret

;llena el espacio de 8 valores en el rango x
;recive el rango a evaluar en rdi
set_xval:
	push rcx	;loop
	push rdx	;iter
	push rbx
	call fill_nan
	mov eax, [x_limit]
	mov ebx, [x_rang + rdi * 8 + 4]
	mov rcx, 8
	cmp eax, ebx
	jle set_loop
	mov [x_limit], ebx
	mov rax, 1
	jmp fin_xval
	set_loop:
	cmp eax, ebx
	jbe fin_xval
		mov	[x_values + rdx * 8], eax
		add eax, [epsilon]
		inc rdx
		mov [x_limit], eax
	loop set_loop
	mov rax, 0
	fin_xval:
	pop rbx
	pop rdx
	pop rcx
	ret
;	Si los valores son mayores al siguiente limite
;	Se termina la evaluación hasta ser llamado en el siguiente intervalo


fill_nan:
	push rcx
	push rax
	xor rax, rax
	mov rcx, 8
	fill_loop:
	mov dword[x_rang + rax * 4], Nan
	inc rax
	loop fill_loop
	pop rax
	pop rcx
	ret

;Evalua una funcion con una sola variable 'x'
global evaluacion_simple
evaluacion_simple:
	push r14
	push r15
	push rbp
	xor r14, r14 ;iter de retorno
	call eval_start
	call rango_simple
	main_loop:
		mov rax, function_ptr
		mov [symbol_iterator], rax
		mov rdi, 0
		call set_xval
		cmp rax, 0
		je eval_loop
		inc rdi
		cmp rdi, [x_quant]
		jb fin_main
		;cambiar el intervalo
		eval_loop:
			call eval_symbol
			mov rax, [symbol_iterator]
			cmp rax, '\0'
			jne eval_loop
			mov ax, [spec_operator]
			cmp ax, '+'
			je evaluar_suma
			vsubps ymm12, ymm11, ymm11
			jmp fin_suma
		evaluar_suma:
			vaddps ymm12, ymm11, ymm11
			fin_suma:
			cmp ax, '+'
			je evaluar_suma2
			vsubps ymm11, ymm10, ymm10
			jmp fin_suma2
		evaluar_suma2:
			vaddps ymm11, ymm10, ymm11
			fin_suma2:
		mov r15, [return_ptr]
		shl r14, 5
		add r15, r14
		shr r14, 5
		vmovups [r15], ymm10
		inc r14
		jmp main_loop
		fin_main:
		pop rbp
		pop r15
		pop r14
		xor rax, rax
		ret
