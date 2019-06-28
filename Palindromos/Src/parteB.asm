; Notas importantes
; rcx = loop dec
; rdx = ptrIzq
; rsi = ptrDer

section .data

SYS_exit equ 60;
SUCCES equ 0;

;Strings a revisar
hilerax:   db   0  ; Hilera 0 para salto
hilera0:   db   'notardesysedraton', 0  ; 16 + 1
hilera1:   db   'hasoidoalaodiosahadamariajose', 0 ; 28 + 1
hilera2:   db   'a', 0  ; 1 + 1
hilera3:   db   'ab', 0 ; 2 + 1
hilera4:   db   'aa', 0 ; 2 + 1
hilera5:   db   'aba', 0  ; 3 + 1
hilera6:   db   'abc', 0  ; 3 + 1
hilera7:   db   'abba', 0 ; 4 + 1


dirstring: dq hilerax, hilera0, hilera1, hilera2, hilera3
           dq hilera4, hilera5, hilera6, hilera7

resultado: dq 0

section .text
global  main
main:

mov rcx, 8  ; Mantener fuera del loop principal
buscapalindromo:
;Encuentra el indice donde empieza la string de palindromo
getIndice:
  mov rax, qword [dirstring + rcx * 8] ;  rax almacena dirección de string

; Encuentra el puntero fel fin
buscDer:
   mov rbx, rax
ploop: ;  Principio del loop condicional
   cmp byte[rbx], 0
   je floop
   inc rbx
   jmp ploop
floop:  ; Fin del loop condicional
   dec rbx ; Resta para dejar en el ultimo caracter, no en el 0

palindromo: ;Encuentra palindromos
   mov rdx, rax   ; Inicializa el indice Iquierdo
   mov rsi, rbx   ; Inicializa el indice Derecho
condicion:
   cmp rdx, rsi
   jae  pal ; Saltar a si Derecha <= Izquierda
   mov r14b, [rdx]  ; Mover caracter a registro 14
   mov r15b, [rsi]  ; Mover caracter a registro 15
   cmp r14b, r15b    ; Comparacion de caracteres
   je  reduc
   push 0        ; No son iguales
   jmp fpal
reduc:  ; Cambia los punteros de los bordes
   inc rdx
   dec rsi
   jmp condicion
pal:
   push 1  ; Son iguales
fpal:
   loop  buscapalindromo

sum:
   xor rax, rax  ; Se pone rax en 0
   mov rcx, 8   ; Se inicia un contador 8
   sumloop:
   shl rax, 1    ; rax se corre 1 bit a la derecha
   pop rbx
   add rax, rbx  ; Se suma 1/0 a rax
   loop sumloop
endsum:
   mov qword [resultado], rax

fin:
   mov rax, SYS_exit
   mov rdi, [resultado]
   syscall
