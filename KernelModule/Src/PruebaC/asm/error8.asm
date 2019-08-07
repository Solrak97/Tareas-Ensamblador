;int error8(char* hilera); Verifica que no haya más de 2 operadores por término

section .text
global error8
error8:
    ;Prólogo
    push    rbp
    mov rbp, rsp
    xor rax, rax ;ret = 0
    xor rdx, rdx ;pos = 0
    xor rsi, rsi ;contador = 0

recorreHilera:
    mov cl, byte[rdi+rdx] ;cl = hilera[pos]
    inc rdx ;++pos
    cmp cl, 42 ;*
    je  esPorEntre
    cmp cl, 47 ;/
    je  esPorEntre
    cmp cl, 43 ;+
    je  esMasMenos
    cmp cl, 45 ;-
    je  esMasMenos
    cmp cl, 0
    je  epilogo
    jmp recorreHilera

esPorEntre:
    inc rsi ;++contador
    cmp rsi, 3
    je  hayError
    jmp recorreHilera

esMasMenos:
    xor rsi, rsi ;contador = 0
    jmp recorreHilera

hayError:
    mov rax, 8

epilogo:
    pop rbp
    ret
