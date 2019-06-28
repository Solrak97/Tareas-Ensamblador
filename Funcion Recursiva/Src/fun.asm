global fun
extern printf


;   Macro para hacer printf
;   Solo para mantener el orden
;   print formato, dato
%macro print 2
push rdi        ;   Almacena el rdi
xor rax, rax    ;   Limpia rax
mov rsi, %2     ;   Envia n a printf
mov rdi, %1     ;   Envia el formato a printf
call printf     ;   Realiza el print
pop rdi         ;   Retorna el rdi
%endmacro


section .data
formato db "%d ", 0 ;   ("%d ", n)

section .text
;   Función fun de tarea programada 4
;   Lee un entero en rdi, hace un llamado
;   Recursivo, imprime el numero y llama nuevamente
;   Es posible usar variables temporales
;   Como solo es una no se hizo para ser optimo

fun:
enter 0, 0              ;   Crea el stack frame con 0 espacios extra
push rdi                ;   Conserva n

cmp rdi, 0              ;   if(n > 0)
jle base                 ;   then -> base
                        ;   else -> recursivo

recursivo:              ;   Caso recursivo
dec rdi                 ;   --n
call fun                ;   fun(n) / fun(n-1)
inc rdi                 ;   Amenta n para el print
print formato, rdi      ;   print("%d ", n)
dec rdi                 ;   Reduce n nuevamente
call fun                ;   fun(n) / fun(n-1)

base:                   ;   Caso base

pop rdi                 ;   Retorna n
leave                   ;   Termina el stack frame
ret                     ;   Retorna el control
