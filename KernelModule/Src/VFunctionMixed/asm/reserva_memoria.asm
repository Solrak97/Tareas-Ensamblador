;Exportacion de datos
;===================================================
;===================================================

section .bss
;Metadatos de la funcion
;===================================================
	global function_ptr
	function_ptr	resq 1	;ptr a funcion

	global interval_ptr
	interval_ptr	resq 1	;ptr a intervalos

	global epsilon
	epsilon 		resq 1	;epsilon

	global x_quant
	x_quant			resb 1	;cuantos x intervals?

	global y_quant
	y_quant			resb 1	;cuantos y intervals?

	global symbol_iterator
	symbol_iterator	resb 1	;iterar en la funcion

	global return_ptr
	return_ptr		resq 1
;===================================================

;Punteros a intervalos
;===================================================
	global x_values
	x_values		resd 8	;32B array de valores x

	global y_values
	y_values		resd 8	;32B array de valores y

	global temp
	temp			resd 8  ;temp var 32B const

	global x_rang
	x_rang			resq 3	;rangos x

	global y_rang
	y_rang			resq 3	;rangos y
;===================================================

;Avance en intervalos
;===================================================
	global x_limit
	x_limit			resd 1

	global x_limit
	y_limit			resd 1
;===================================================

;Operadores especiales
;===================================================
	global spec_operator
	spec_operator	resb 2	;Sumas/restas
;===================================================
section .text
