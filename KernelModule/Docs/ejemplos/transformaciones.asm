;---------------------------------------------------------------
;
;	Dispositivo
; 	Grupo 1 - Proyecto integrador
;
;----------------------------------------------------------------

global transformarImagen


section .data
	
section .bss

section .text

transformarImagen:
	;pila
	push rbp
	mov rbp, rsp
	
	; registros callee saved
	push rbx
	push r12
	push r13
	push r14
		
	; ----------------------parametros---------------------------------------------------
	; cantidad de transformaciones, vector de transformaciones, cantidad puntos x o filas, cantidad de puntos y o columnas y puntero a imagen
	; guardar direcciones de variables globales
	; se pasan como parametro (direccionTransformaciones, direccionImagen)
	;mov [cantTransformaciones], rdi
	;mov [dirTransformaciones], rsi
	;mov [cantX], rdx
	;mov [cantY], rcx
	;mov [dirImagen], r8
	
	mov r10, rdx
	mov r8, rcx		; copia direccion de la imagen
	
	; for por cantidad de transformaciones
	mov rbx, 0  ;contador
	jmp testFor1

for1:
	; obtiene tipo de transformacion 
	mov rax, 12		; guarda un 12 
	mul rbx			; guarda un 12*i en rax
	mov r12, rax
	mov r13, rsi
	add r13, r12
	xor rax, rax	; limpia rax
	mov eax, [r13]	;el tipo de transformacion se guarda en el espacio (dirTransformaciones+ i*12)
	
	
	; obtiene parametros
	
	;primer parametro (r15)
	; se guarda en i+4
	mov r12, 4
	add r12, rbx
	mov r15, rsi
	add r15, r12		; direccion del primer parametro

	
	;segundo parametro (r9)
	; se guarga en i+8
	mov r12, 8
	add r12, rbx
	mov r9, rsi
	add r9, r12			; direccion del segundo parametro
	
	;incrementa contador
	inc rbx
	
	comparacion:
	
	;compara rax para saltar a la ejecucion de la transformacion
	cmp rax, 0
	je reflexion
	cmp rax, 1
	je escalacion
	cmp rax, 2
	je traslacion
	cmp rax, 3
	je brillo
	cmp rax, 4
	je negativo
	cmp rax, 5
	je contraste
	
;test para ver si faltan mas transformaciones	
testFor1:
	cmp rbx, rdi	;compara contador con la cantidad de transformaciones
	jl for1			; salta al contenido del for si el contador es menor que la cantidad de transformaciones
	jmp fin			; salta al fin de la funcion
	
; ------------------------------- REGISTROS OCUPADOS ---------------------------------------
; 
; Registros ocupados:
;	- rax = tipo de transformacion
;	- rsi = vector de transformaciones 
;	- rdi = cantidad de transformaciones
;	- rdx = transformaciones
;	- rbx = i
;	- r8 = imagen
;	- r15 = primer parametro
;	- r9 = segundo parametro



; --------------------- Transformaciones de imagenes vectoriales -----------------------------

;id = 0
reflexion:		
	
	;get inicio de puntos y (r11)
	mov rax, r10
	mov r11, 2
	div r11			; divide entre 2 el total de coordenadas
	mov r11, rax	; cantidad de puntos
	mov rax, 4
	mul r11
	mov r11, rax	;distancia del inicio del vector
	mov r13, r8
	add r11, r13		; posicion inicial de puntos y

	
	;calcular cantidad de operaciones requeridas 
	mov rax, r10
	mov r13, 2
	div r13			; divide entre 2 el total de coordenadas para tener total de puntos
	
	mov r13, 8
	div r13			; (total de puntos en un eje/8)
	mov r14, rax

	
	; contador (r12)
	mov r12, 0
	mov r13, 0
	
	;inicia ciclo
	jmp testForReflexion
	
	
	forReflexion:
		; mueve parte del vector de datos x a ymm0
		vmovups ymm0, [r8+r13] 
		;mueve parte del vector de datos y a ymm1
		vmovups ymm1, [r11+r13]
		
		; guarda invertidos los puntos
		vmovups  [r8+r13], ymm1
		vmovups  [r11+r13], ymm0
	
		; aumentar contador
		inc r12
		add r13, 20h		; aumenta la cantidad de bits que ya se utilizaron (256 bits = 8 puntos)
	
	testForReflexion:
	; compara contador (r12) con cantidad de puntos (rax)
		cmp r12, r14
		; continua el ciclo si el contador es menor
		jl forReflexion
		
	vzeroupper	
	jmp testFor1

; ----------------------------------------------------------------------------------------

;id = 1
escalacion:
	; Se utiliza AVX, se procesan 256 bits a la vez, de 8 en 8 puntos en formato punto flotante de 32 bits.
	
	;get inicio de puntos y (r11)
	mov rax, r10
	mov r13, 2
	div r13	

	mov r11, 4
	mul r11
	mov r11, rax	;distania del inicio del vector
	mov r13, r8
	add r11, r13		; posicion inicial de puntos y
	
	
	; crea vector de x y vector de y para poder hacer las operaciones en paquetes
	
	; parametro x: poner el valor de r15 (ymm0)
	vpbroadcastd ymm0, [r15]
	vcvtdq2ps ymm0, ymm0		; convertir int a float
	
	; parametro y: poner el valor de r9 64 veces (ymm1)
	vpbroadcastd ymm1, [r9]
	vcvtdq2ps ymm1, ymm1		; convertir int a float
	
	;calcular cantidad de operaciones requeridas 
	mov rax, r10
	mov r13, 2
	div r13			; divide entre 2 el total de coordenadas para tener total de puntos
	
	mov r13, 8
	div r13			; (total de puntos en un eje/8)
	mov r14, rax

	; contador (r12)
	mov r12, 0
	mov r13, 0
	
	;inicia ciclo
	
	jmp testForEscalacion
	
	;ciclo para leer los valores y sumarles el parametro en x y y
	forEscalacion:
		; mueve parte del vector de datos x a ymm2
		vmovups ymm2,  [r8+r13] 
		
		; multiplicacion
		vmulps ymm4,ymm0,ymm2
		
		; guarda resultado de vuelta al vector
		vmovups  [r8+r13], ymm4
		
		; mueve parte del vector de datos y a ymm3
		vmovups ymm2, [r11+r13] 

		; multiplicacion 
		vmulps ymm4,ymm1,ymm3
	
		; guarda resultado de vuelta al vector
		vmovups [r11+r13],ymm4
		
		; aumentar contador
		inc r12
		add r13, 20h		; aumenta la cantidad de bits que ya se utilizaron (256)
		
	testForEscalacion:
		; compara contador (r12) con cantidad de puntos (r14)
		cmp r12, r14
		; continua el ciclo si el contador es menor
		jl forEscalacion
		
	
	vzeroupper
	jmp testFor1


;--------------------------------------------------------------------------------------------
; id = 2
traslacion:
	; Se utiliza AVX, se procesan 256 bits a la vez, de 8 en 8 puntos en formato punto flotante de 32 bits.
	
	;get inicio de puntos y (r11)
	mov rax, r10
	mov r13, 2
	div r13	

	mov r11, 4
	mul r11
	mov r11, rax		; distancia del inicio del vector
	mov r13, r8
	add r11, r13		; posicion inicial de puntos y
	
	; crea vector de x y vector de y para poder hacer las operaciones en paquetes
	
	; parametro x: poner el valor de r15 (ymm0)
	vpbroadcastd ymm0, [r15]
	vcvtdq2ps ymm0, ymm0		; convertir int a float
	
	; parametro y: poner el valor de r9 64 veces (ymm1)
	vpbroadcastd ymm1, [r9]
	vcvtdq2ps ymm1, ymm1		; convertir int a float
	
	
	;calcular cantidad de operaciones requeridas (r14)
	mov rax, r10
	mov r13, 2
	div r13			; divide entre 2 el total de coordenadas para tener total de puntos
	mov r13, 8
	div r13			; (total de puntos en un eje/8)
	mov r14, rax
	
	; contador (r12)
	mov r12, 0
	mov r13, 0
	
	;inicia ciclo
	
	jmp testForTraslacion
	
	;ciclo para leer los valores y sumarles el parametro en x y y
	forTraslacion:
		; mueve parte del vector de datos x a ymm2
		vmovups ymm2, [r8+r13] 
		
		;suma
		vaddps ymm4,ymm0,ymm2
		
		; guarda resultado de vuelta al vector
		vmovups [r8+r13], ymm4
		
		; mueve parte del vector de datos y a ymm3
		vmovups ymm3, [r11+r13] 

		; suma 
		vaddps ymm4,ymm1,ymm3
	
		; guarda resultado de vuelta al vector
		vmovups [r11+r13],ymm4
		
		; aumentar contador
		inc r12
		add r13, 20h		; aumenta la cantidad de bits que ya se utilizaron (256)
		
	testForTraslacion:
		; compara contador (r12) con cantidad de puntos (r14)
		cmp r12, r14
		; continua el ciclo si el contador es menor
		jl forTraslacion 
		
	
	vzeroupper
	jmp testFor1


; ---------------- Transformaciones de mapas de bits --------------------
; Para estas se utilizan instrucciones AVX de numeros de 1 byte. 
; Se procesan de 32 en 32 porque se utilizan enteros de 1 byte 

; id = 3
brillo:
	; Se le suma el nivel del cambio de brillo a todas las entradas, verificando que no sean mayores a 255.
		
	; Se genera vector que contiene 64 veces el valor contenido en r15 (se guarda en ymm0)
	vpbroadcastb ymm0, [r15]
	
	; Ciclo para sumar el vector a todas las entradas 
	; contador
	mov r11, 0		; contador
	mov r12, 0 		; traslacion dentro del vector de pixeles
	mov rax, r10	; cantidad total de bits
	mov r13, 256  	; cantidad simultanea  
	div r13
	mov r13, rax	; cantidad total de operaciones requeridas
	
	jmp tesForBrillo
	
	forBrillo:
		; Se guarda imagen en ymm1
		vmovdqu ymm1, [r8+r12]
		
		; Se le suma el nivel del cambio en ymm2 (ymm0 + ymm1) (instruccion para 1 byte)
		vpaddb ymm2, ymm0, ymm1	
		
		; Se guarda imagen nuevamente
		vmovdqu [r8+r12], ymm2
		
		; aumentar contador
		inc r11
		add r12, 100h 	;(sumar 256)
	
	tesForBrillo:
		cmp r11, r13
		jl forBrillo
	
	vzeroupper
	jmp testFor1

;--------------------------------------------------------------------------------------------

; id = 4
negativo:
	; Se genera vector que contiene 255 (64 255's) se guarda en ymm0
	mov r15, 255
	push 255
	vpbroadcastb ymm0, [rsp]
	pop r15
	
	; Ciclo para negativo
	
	; contador
	mov r11, 0		; contador
	mov r12, 0 		; traslacion dentro del vector de pixeles
	mov rax, r10	; cantidad total de bits
	mov r13, 256  	; cantidad simultanea  
	div r13
	mov r13, rax	; cantidad total de operaciones requeridas
	
	
	jmp testForNegativo
	
	forNegativo:
		; Se guarda imagen en ymm1
		vmovdqu ymm1, [r8+r12]
		
		; Se le resta el vector de 255 
		vpsubb ymm2, ymm0, ymm1
		
		; Se guarda imagen nuevamente
		vmovdqu [r8+r12], ymm2
		
		; aumentar contador
		inc r11
		add r12, 100h 	;(sumar 256)
	
	testForNegativo:
		cmp r11, r13
		jl forNegativo
	
	vzeroupper
	jmp testFor1

;--------------------------------------------------------------------------------------------
	
; id = 5
contraste:
	
	; Ciclo para contraste

	;calculo de FC
	xor rax, rax
	numerador:
	mov r11, 259
	mov rax, 255
	add rax, [r15]
	mul r11
	mov r11, rax
	
	denominador:
	mov rax, 259
	sub rax, [r15]
	mov r12, 255
	mul r12
	mov r12, rax
	
	division:
	mov rax, r11
	div r12
	
	generarVector:
	push rax	;push resultado
	; Se genera vector que contiene el parametro 
	vpbroadcastb ymm0, [rsp]
	pop rax
	xor rax, rax
	mov al, 128
	push rax
	vpbroadcastb ymm1, [rsp] 
	
	pop rax

	contador:
	mov r11, 0		; contador
	mov r12, 0 		; traslacion dentro del vector de pixeles
	mov rax, r10	; cantidad total de bits
	mov r13, 256  	; cantidad simultanea  
	div r13
	mov r13, rax	; cantidad total de operaciones requeridas
	
	
	
	jmp testForContraste
	
	forContraste:
		
		; Se guarda imagen en ymm2
		vmovdqu ymm2, [r8+r12]
		
		; Se le resta 128 
		vpsubb ymm3, ymm2, ymm1		
		
		;multiplica por fc
		vpmaddubsw ymm2, ymm3, ymm0
		
		; suma 128
		vpaddb ymm3, ymm2, ymm1
		
		; Se guarda imagen nuevamente
		vmovdqu [r8+r12], ymm3
		
		; aumentar contador
		inc r11
		add r12, 100h
		
	testForContraste:
		cmp r11, r13
		jl forContraste
	
	vzeroupper
	jmp testFor1

;------------------------------------------------------------------------------------------------
fin:
	pop r14
	pop r13
	pop r12
	pop rbx
	
	pop rbp
	ret