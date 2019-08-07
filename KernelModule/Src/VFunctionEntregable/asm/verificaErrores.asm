extern  error1
extern  error2
extern  error3
extern  error4
extern  error5
extern  error6
extern  error7
extern  error8
extern  error9

section .data
    funcion dq  0
    terminos    db  0

section .text
global verificaErrores
verificaErrores:
    push    rbp
    mov rbp, rsp
    mov qword[funcion], rdi

    xor rax, rax ;ret = 0

    ;Error 1
    mov rdi, qword[funcion]
    call    error1 ;Deja en rsi la cantidad de +- contados
    mov byte[terminos], sil

    ;Error 2
    cmp rax, 0
    jne fin
    mov rdi, qword[funcion]
    call    error2

    ;Error 3
    cmp rax, 0
    jne fin
    mov rdi, qword[funcion]
    xor rsi, rsi
    mov sil, byte[terminos] ;rsi = cantidad de terminos
    call    error3

    ;Error 4
    cmp rax, 0
    jne fin
    mov rdi, qword[funcion]
    call    error4

    ;Error 5
    cmp rax, 0
    jne fin
    mov rdi, qword[funcion]
    call    error5

    ;Error 6
    cmp rax, 0
    jne fin
    mov rdi, qword[funcion]
    call    error6

    ;Error 7
    cmp rax, 0
    jne fin
    mov rdi, qword[funcion]
    call    error7

    ;Error 8
    cmp rax, 0
    jne fin
    mov rdi, qword[funcion]
    call    error8

    ;Error 9
    cmp rax, 0
    jne fin
    call    error9

fin:
    pop rbp
    ret
