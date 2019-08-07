;error9(float epsilon, float limiteInferior, float limiteSuperior) (xmm0, xmm1, xmm2)

section .text
global error9
error9:
    ;Prólogo
    push    rbp
    mov rbp, rsp
    xor rax, rax ;ret = 0
    mov edx, 3276800
    cvtsi2ss    xmm3, edx ;xmm3 = 3276800 (Cantidad de floats máxima)

    ;Calcula (b-a)/epsilon
    subss   xmm2, xmm1 ;xmm2 = b-a
    divss   xmm2, xmm0 ;xmm2 = (b-a)/epsilon

    ;Verifica si (b-a)/epsilon es menor al máximo
    ucomiss xmm2, xmm3
    jb  epilogo ;Si xmm2 es una cantidad válida

hayError:
    mov rax, 9

epilogo:
    pop rbp
    ret
