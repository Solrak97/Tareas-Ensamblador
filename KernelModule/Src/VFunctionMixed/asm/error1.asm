;error1(char& hilera); Verifica que no haya más de 2 signos + o - en la funcion

section .text
global error1
error1:
    ;Prólogo
    push    rbp
    mov rbp, rsp

    xor rax, rax ;ret = 0
    xor rdx, rdx ;pos = 0
    xor rsi, rsi ;cantidad = 0

    ;No toma en cuenta el primer - (si existe)
    mov cl, byte[rdi] ;cl = hilera[0]
    cmp cl, 45 ;-
    jne recorreHilera
    dec rsi

recorreHilera:
    mov cl, byte[rdi+rdx] ;cl = hilera[pos]
    inc rdx ;++pos
    cmp cl, 43 ;+
    je  esMasMenos
    cmp cl, 45 ;-
    je  esMasMenos
    cmp cl, 0 ;Si llega al final de la hilera
    je  epilogo
    jmp recorreHilera

esMasMenos:
    inc rsi
    cmp rsi, 3
    je  hayError
    jmp recorreHilera

hayError:
    inc rax

epilogo:
    pop rbp
    ret
