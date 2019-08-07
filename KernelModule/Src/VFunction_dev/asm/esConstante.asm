;Compara un caracter con una hilera de constantes. Retorna 0 si no es una constante, 1 si es.

section .data
    constantes  db  "0123456789",0

section .text
global esConstante
esConstante:
    ;Prólogo
    push    rbp
    mov rbp, rsp
    push    rdx ;Guarda rdx
    push    rcx ;Guarda rcx
    xor rdx, rdx ;pos = 0
    xor rax, rax ;ret = 0

recorreConstantes:
    mov cl, byte[constantes+rdx] ;cl = constantes[pos]
    inc rdx
    cmp cl, dil ;char_recibido = constantes[pos]
    je  siEsConstante
    cmp cl, 0
    je  epilogo
    jmp recorreConstantes

siEsConstante:
    inc rax ;return 1

epilogo:
    pop rcx
    pop rdx
    pop rbp
    ret
