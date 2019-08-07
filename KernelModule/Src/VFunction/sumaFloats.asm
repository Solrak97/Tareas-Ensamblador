section .data
	resultado dd 0
section .text
;Parámetros:
; xmm0 = sumando
; xmm1 = sumando
;Retorna:
; rax = total
global sumaFloats
sumaFloats:
    fld dword[rdi]
	fld dword[rsi]
	faddp
	fstp dword[rdi]
    ret
