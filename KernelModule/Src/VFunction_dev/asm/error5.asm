;int error5(char& hilera); Revisa que no haya variables diferentes a 'x' o 'y'

extern esConstante

section .text
global error5
error5:
    ;Prólogo
    push    rbp
    mov rbp, rsp
    xor rax, rax ;ret = 0
    xor rdx, rdx ;pos = 0

recorreHilera:
    mov cl, byte[rdi+rdx] ;cl = hilera[pos]
    inc rdx ;++pos
    cmp cl, 0
    je  epilogo
    cmp cl, 42 ;*
    je  recorreHilera
    cmp cl, 47 ;/
    je  recorreHilera
    cmp cl, 43 ;+
    je  recorreHilera
    cmp cl, 45 ;-
    je  recorreHilera

siEsConstante:
    push    rax
    push    rdi
    mov dil, cl
    call    esConstante
    cmp rax, 1
    pop rdi
    pop rax
    je  recorreHilera

esOperando:
    cmp cl, 115 ;s
    je  recorreHilera
    cmp cl, 99 ;c
    je  recorreHilera
    cmp cl, 116 ;t
    je  recorreHilera
    cmp cl, 120 ;x
    je  recorreHilera
    cmp cl, 121 ;y
    je  recorreHilera ;Si no es 'x' o 'y' sigue con hayError

hayError:
    mov rax, 5

epilogo:
    pop rbp
    ret
