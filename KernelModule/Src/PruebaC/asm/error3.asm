;int error3(char& hilera, int cantidad_terminos); Verifica que no haya */ de más en la función

section .text
global error3
error3:
    ;Prólogo
    push    rbp
    mov rbp, rsp
    xor rdx, rdx ;pos = 0
    xor rax, rax ;ret = 0
    xor r8, r8 ;cantidadPorEntre = 0

    shl rsi, 1
    add rsi, 2 ;rsi = cantidad_terminos*2 + 2 (cantidad máxima de */ que puede haber)

recorreHilera:
    mov cl, byte[rdi+rdx] ;rcx = hilera[pos]
    inc rdx ;++pos
    cmp cl, 42 ;*
    je  esPorEntre
    cmp cl, 47 ;/
    je  esPorEntre
    cmp cl, 0
    je  epilogo ;Si llegó a la terminación nula de la hilera
    jmp recorreHilera

esPorEntre:
    inc r8 ;++cantidadPorEntre
    cmp r8, rsi ;Si cantidadPorEntre > rsi
    jg  hayError
    jmp recorreHilera

hayError:
    mov rax, 3 ;return 3

epilogo:
    pop rbp
    ret
