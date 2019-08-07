;int error2(char& hilera); Verifica que haya una variable luego de 's', 'c', 't'
section .text
global error2
error2:
    push    rbp
    mov rbp, rsp
    xor rax, rax ;ret = 0
    xor rdx, rdx ;pos = 0

recorreHilera:
    mov cl, byte[rdi+rdx]
    inc rdx
    cmp cl, 115 ;s
    je  esSCT
    cmp cl, 99 ;c
    je  esSCT
    cmp cl, 116 ;t
    je  esSCT
    cmp cl, 0
    je  epilogo
    jmp recorreHilera

esSCT:
    cmp byte[rdi+rdx], 120 ;x
    je  recorreHilera
    cmp byte[rdi+rdx], 121 ;y
    je  recorreHilera

hayError:
    mov rax, 2

epilogo:
    pop rbp
    ret
