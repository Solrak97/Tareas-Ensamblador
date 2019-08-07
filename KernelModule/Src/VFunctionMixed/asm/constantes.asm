;Exportacion de datos
;====================================

;====================================

section .data
;Constantes de tipo de datos
;====================================
	global const
	const	equ 1 ; constant datatype

	global var
	var		equ 2 ; variable datatype

	global oper
	oper	equ	3 ; operator datatype

	global Nan
	Nan		equ 2139095041 ;constante Not a number
;====================================

;Tabla de operaciones
;====================================
	global addition
	addition	equ '+'

	global substract
	substract	equ '-'

	global multiply
	multiply	equ '*'

	global divide
	divide		equ '/'

	global sin
	sin			equ 's'

	global cos
	cos			equ 'c'

	global tan
	tan			equ 't'
;====================================

;Special operator count
;====================================
	global spec_count
	spec_count db 0
;====================================
section .text
