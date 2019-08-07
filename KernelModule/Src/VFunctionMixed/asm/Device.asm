section .data
;Data type constante
;====================================
	const	equ 1 ; constant datatype
	var		equ 2 ; variable datatype
	oper	equ	3 ; operator datatype
;====================================

;Operation table
;====================================
	addition	equ '+'
	substrac	equ '-'
	multiply	equ '*'
	divide		equ '/'
	sin			equ 's'
	cos			equ 'c'
	tan			equ 't'
;====================================

section .bss
;Function metadata
;====================================
	function_ptr	resq 1	;ptr to function
	interval_ptr	resq 1	;ptr to interval
	epsilon 		resq 1	;epsilon
	x_quant			resb 1	;how many x intervals?
	y_quant			resb 1	;how many y intervals?
	symbol_iterator	resb 1	;iterates on function
;====================================

;Operation datatype
;====================================
	x_values		resd 8	;32B array of x values
	y_values		resd 8	;32B array of y values
	final_array		resd 1048576 ;4MB dim array
;====================================
section .text

;Global declarations
;====================================
	global simple_evaluation
	global double_evaluation
;====================================

; Read a symbol in rdi, and applyes
; it into the vectorial function
evaluate_operator:
	; Switch operation
	cmp rdi, addition
		je eval_add
	cmp rdi, substrac
		je eval_sub
	cmp rdi, multiply
		je eval_mul
	cmp rdi, divide
		je eval_div
	cmp rdi, sin
		je eval_sin
	cmp rdi, cos
		je eval_cos
	cmp rdi, tan
		je eval_tan
	switch_end:
	ret

eval_add:
	jmp switch_end

eval_sub:
	jmp switch_end

eval_mul:
	jmp switch_end

eval_div:
	zero_div:
	jmp switch_end

eval_sin:
	jmp switch_end

eval_cos:
	jmp switch_end

eval_tan:
	jmp switch_end


symbol_reader:
	cmp rdi, const

	cmp rdi, var

	cmp rdi, oper

	ret

simple_evaluation:

double_evaluation:

;Pila de datos empieza en ymm10 y termina en ymm15
%macro vpush 1
%endmacro

%macro vpop 1
%endmacro
