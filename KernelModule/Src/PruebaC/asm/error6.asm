;int error6(char& hilera); Verifica que no haya constantes de mas de 7 digitos

extern esConstante ;en error6esConstante.asm

section .text
global error6
error6:
    ;Prólogo
    push    rbp
    mov rbp, rsp
    xor rax, rax ;ret = 0
    xor rdx, rdx ;pos = 0
    xor r8, r8 ;contador = 0 (Cuenta la cantidad de constantes seguidas)

recorreHilera:
    mov cl, byte[rdi+rdx] ;cl = hilera[pos]
    inc rdx ;++pos
    cmp cl, 0
    je  epilogo ;Si llega al final de la hilera
    push    rax
    push    rdi
    mov dil, cl ;dil = caracter leído
    call    esConstante
    cmp rax, 0
    je  noEsConstante

    inc r8 ;Aumenta el contador
    pop rdi
    pop rax
    cmp r8, 7
    je  hayError

    jmp recorreHilera

noEsConstante:
    xor r8, r8 ;Reinicia el contador
    pop rdi
    pop rax
    jmp recorreHilera

hayError:
    mov rax, 6

epilogo:
    pop rbp
    ret
