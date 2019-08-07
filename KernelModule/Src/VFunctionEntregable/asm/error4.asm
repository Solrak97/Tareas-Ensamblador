;int error4(char& hilera); Si hay dos * o / o + o - contiguos

section .text
global error4
error4:
    ;Prólogo
    push    rbp
    mov rbp, rsp
    xor rdx, rdx ;pos = 0
    xor r8, r8 ;posTmp = 0
    xor rax, rax ;ret = 0

recorreHilera:
    mov r8, rdx ;posTmp = pos
    mov cl, byte[rdi+rdx] ;rcx = hilera[pos]
    inc rdx ;++pos
    cmp cl, 42 ;*
    je  esOperador
    cmp cl, 47 ;/
    je  esOperador
    cmp cl, 43 ;+
    je  esOperador
    cmp cl, 45 ;-
    je  esOperador
    cmp cl, 30 ;Si llegó al fin de la hilera
    je  epilogo
    cmp cl, 0
    je  epilogo ;Si llegó a la terminación nula de la hilera
    jmp recorreHilera

esOperador:
    mov cl, byte[rdi+r8-1] ;hilera[posTmp-1]
    cmp cl, 42
    je hayError
    cmp cl, 47
    je  hayError
    cmp cl, 43
    je  hayError
    cmp cl, 45
    je  hayError

    mov cl, byte[rdi+r8+1] ;hilera[posTmp+1]
    cmp cl, 42
    je hayError
    cmp cl, 47
    je  hayError
    cmp cl, 43
    je  hayError
    cmp cl, 45
    je  hayError

    jmp recorreHilera

hayError:
    mov rax, 4 ;return 4

epilogo:
    pop rbp
    ret
