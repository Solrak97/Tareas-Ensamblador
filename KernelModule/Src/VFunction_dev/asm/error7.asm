;int error7(&hilera); Verifica que la hilera comience con una constante o una variable
section .data
    validos db  "0123456789xysct",0

section .text
global error7
error7:
    ;Prólogo
    push    rbp
    mov rbp, rsp
    xor rdx, rdx ;pos = 0
    mov rax, 7 ;ret = 7

    mov cl, byte[rdi] ;cl = hilera[0]
    cmp cl, 45 ;-
    jne recorreValidos
    inc rdi
    mov cl, byte[rdi] ;Si empieza con - comienza a Verificar a partir de hilera[1]

recorreValidos:
    mov sil, byte[validos+rdx] ;sil = validos[pos]
    inc rdx ;++pos
    cmp cl, sil
    je  noHayError
    cmp sil, 0
    je  epilogo
    jmp recorreValidos

noHayError:
    xor rax, rax ;ret = 0

epilogo:
    pop rbp
    ret
