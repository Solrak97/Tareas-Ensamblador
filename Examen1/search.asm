global search
search:
  ret

;rdi = direccion de patron
;rsi = direccion de hilera
;rdx = tamaño de patron
;retorna 1 si es patron y 0 si no
global compare
compare:
  push r10  ;respaldo de variables extra

  xor rax, rax ;limpiar rax para usar como contador
  compare_loop:
  cmp rax, rdx
  jg compare_calza
  mov r10b, byte[rdi + rax]
  cmp r10b, byte[rsi + rax]
  je compare_loop
  mov rax, 0
  jmp compare_fin
  compare_calza:
  mov rax, 1

  compare_fin:
  pop r10
  ret

;rdi = dirección
;retorna el tamaño de la string -1
get_size:
  xor rax, rax            ;Clear a rax
size_loop:
  cmp byte[rax + rdi], 0  ;Comparacion de char con 0
  je ret_size
  inc rax
  jmp size_loop
ret_size:
  dec rax                 ;Retorno size - 1 (considerando el 0)
  ret
