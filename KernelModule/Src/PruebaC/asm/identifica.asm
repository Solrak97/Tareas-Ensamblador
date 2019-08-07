;void identifica(char* termino, int* resultado); Identifica cada elemento del término

section .text
global identifica
identifica:
    ;Prólogo
    push    rbp
    push    r12
    mov rbp, rsp
    xor r8, r8 ;pos = 0
    xor r12, r12 ;pos2 = 0
    xor r9, r9 ;tmp = 0 (Este es el que voy a usar para las constantes)
    ;rax y rdx no se tocan!

recorreHilera:
    mov cl, byte[rdi+r8] ;cl = hilera[pos]
    cmp cl, 0
    je  preEpilogo
    cmp cl, 42 ;*
    je  preOperador
    cmp cl, 43 ;+
    je  preOperador
    cmp cl, 45 ;-
    je  preOperador
    cmp cl, 47 ;/
    je  preOperador
    cmp cl, 99 ;c
    je  preOperador
    cmp cl, 115 ;s
    je  preOperador
    cmp cl, 166 ;t
    je  preOperador
    cmp cl, 120 ;x
    je  preVariable
    cmp cl, 121 ;y
    je  preVariable
    jmp esOperando

preOperador:
    ;Si viene de procesar una constante, la agrega al resultado
    cmp r9, 0
    je esOperador
    mov dword[rsi+r12], 1
    add r12, 4
    mov dword[rsi+r12], r9d
    add r12, 4
    xor r9, r9 ;Reinicia r9

esOperador:
    mov dword[rsi+r12], 3 ;3 es el código de esta operación
    add r12, 4
    movzx   ecx, cl
    mov dword[rsi+r12], ecx ;mueve hilera[pos] a resultado
    add r12, 4
    inc r8 ;++pos
    jmp recorreHilera

preVariable:
    ;Si viene de procesar una constante, la agrega al resultado
    cmp r9, 0
    je esVariable
    mov dword[rsi+r12], 1
    add r12, 4
    mov dword[rsi+r12], r9d
    add r12, 4
    xor r9, r9 ;Reinicia r9

esVariable:
    mov dword[rsi+r12], 2
    add r12, 4
    movzx   ecx, cl
    mov dword[rsi+r12], ecx ;mueve hilera[pos] a resultado
    add r12, 4
    inc r8 ;++pos
    jmp recorreHilera

esOperando:
    ;Convierte la constante a un numero
    mov eax, r9d ;eax = resultado previo
    mov edx, 10 ;*10
    mul edx
    mov r9d, eax ;r9d = resultado
    movzx   eax, cl
    sub eax, 48 ;Convierte el ASCII al int representado
    add eax, r9d ;ax = resultado + caracter
    mov r9d, eax ;Almacena el resultado en r9d
    inc r8 ;++pos
    jmp recorreHilera

preEpilogo:
    ;Si viene de procesar una constante, la agrega al resultado
    cmp r9, 0
    je epilogo
    mov dword[rsi+r12], 1
    add r12, 4
    mov dword[rsi+r12], r9d
    add r12, 4
    xor r9, r9 ;Reinicia r9

epilogo:
    pop r12
    pop rbp
    xor rax, rax ;return 0 (aunque no importa)
    ret
