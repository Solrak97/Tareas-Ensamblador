global vpush, vpop

section .text
;Pushea 256b en el registro ymm10
vpush:
	vmovups	ymm15, ymm14
	vmovups	ymm14, ymm13
	vmovups	ymm13, ymm12
	vmovups	ymm12, ymm11
	vmovups ymm11, ymm10
	vmovups ymm10, [rdi]
	ret

;Popea la pila vectorial en rdi
vpop:
	vmovups	[rdi], ymm10
	vmovups	ymm10, ymm11
	vmovups	ymm11, ymm12
	vmovups	ymm12, ymm13
	vmovups	ymm13, ymm14
	vmovups	ymm14, ymm15
	vpxor	ymm15, ymm15
	ret
