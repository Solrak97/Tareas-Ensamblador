%macro new_interval 1
	movsd [preimages + %1], xmm1	; Upper bound = c
	inc r10
	jmp calculate_function_zero
%endmacro
; ----
section .data

zero_constant dq 0.0
input_message db "false_position_method: Enter the following parameters: <a> <b> <epsilon>: ",0xa ,0
input_format db "%lf %lf %lf",0
output_message db "false_position_method: zero found after %d iterations: %5.5f: ",0xa ,0
const dq 1.0, 3.0, 5.0

; ----
section .bss
val_x resq 4
preimages resq 3	; preimages[0] = a, preimages[1] = c, preimages[2] = b
images resq 3		; images[0] = f(a), images[1] = f(c), images[2] = f(b)
error_range resq 1	; Epsilon

; ----
section .text

global main
extern printf, scanf

main:
	sub	rsp, 8  					; Align the stack to a 16 B boundary.
	mov rdi, input_message
	xor al, al
	call printf

parameters_scann:
	mov rdi, input_format
	mov rsi, preimages			; Lower bound preimage (a).
	mov rdx, preimages + 16		; Upper bound preimage (b).
	mov rcx, error_range		; Error range (epsilon).
	xor al, al
	call scanf

	xor r10, r10							; r10: Iterations.
calculate_function_zero:
; Calculate f(a) and f(b).
	movsd xmm0, qword [preimages]
	call calculate_image					; Calculate f(a).
	movsd qword [images], xmm0

	movsd xmm0, qword [preimages + 16]
	call calculate_image					; Calculate f(b).
	movsd qword [images + 16], xmm0 ;

; Calculate c
	fld qword[images + 16]                 ; st0 = f(b)
  fmul qword[preimages]             ; st0 = f(b)a
  fld qword[images]                      ; st0 = f(a), st1 = f(b)a
  fmul qword[preimages + 16]     ; st0 = f(a)b, st1 = f(b)a
  fsubrp                              ; st0 = f(b)a - f(a)b
  fld qword[images + 16]                ; st0 = f(b), st1 = f(b)a - f(a)b
  fsubr qword[images]                    ; st0 = f(b) - f(a), st1 = f(b)a - f(a)b
  fdivp st1, st0                        ; st0 = f(b)a - f(a)b / f(b) - f(a) = c
  fstp qword[preimages + 8]

; Calculate f(c)
	movsd xmm0, qword[preimages + 8]
	call calculate_image				; Calculate f(c).
	movsd qword [images + 8], xmm0		; Store f(c).

; Check |f(c)| < epsilon
	fld qword[images + 8]			; Load f(c) to fpu stack.
	fabs						; st0 = |f(c)|
	fcomp qword[error_range]			; Compare |f(c)| and epsilon.
	fstsw ax
	fwait
	sahf              			; Transfer the condition codes to the CPU's flag register.
	jb zero_found   			; If |f(c)| < epsilon, a function zero has been found (c).

; If the condition is not satisfied, a new reduced interval is defined.
	movsd xmm1, [preimages + 8]	; xmm1 = c
	mulsd xmm0, [images]		; xmm0 = f(a)*f(c)
	ucomisd xmm0, [zero_constant]
	jae upper_interval			; Check if f(a) and f(c) are of opposite sign. The mulsd result would be negative.

; Reduced interval: [a,c]
	new_interval 16

upper_interval:					; Reduced interval: [c,b]
	new_interval 0

zero_found:
	mov rdi, output_message
	mov rsi, r10				; Iterations required.
	movsd xmm0, qword[preimages + 8]
	mov al, 1						; xmm0 contains f(c)
	call printf
	add rsp, 8 	; Aligment.
	ret

calculate_image:
  movsd qword[val_x], xmm0     ; Almacena el valor de x
  fld qword[const + 8]      ; stack 3
  fld qword[val_x]
  fld qword[val_x]
  fmul st0, st1
  fmulp                     ; stack x³ 3
  fmulp                     ; stack 3x³
  fld qword[val_x]          ; stack x 3x³
  fmul st0, st0
  fld qword[const + 16]     ; stack 5 x² 3x³
  fmulp                     ; stack 5x² 3x³
  fsubp                     ; stack 3x³-5x²
  fld qword[val_x]          ; stack x 3x³-5x²
  fsubp                     ; stack 3x³-5x²-x
  fld qword[const]          ; stack 1 3x³-5x²-x
  faddp                     ; ; stack 3x³-5x²-x+1
	fld qword[const]          ; stack 1 (3x³ - 5x² - x + 1)
  fld qword[val_x]          ; stack x 1 (3x³ - 5x² - x + 1)
  fmul st0, st0             ; stack x² 1 (3x³ - 5x² - x + 1)
  fmul st0, st0             ; stack x⁴ 1 (3x³ - 5x² - x + 1)
  faddp                     ; stack (x⁴ + 1) (3x³ - 5x² - x + 1)
  fdivp                     ; stack [(3x³ - 5x² - x + 1)/(x⁴ + 1)]
	fld qword[val_x]          ; stack x [(3x³ - 5x² - x + 1)/(x⁴ + 1)]
  fsin                      ; stack sin(x) [(3x³ - 5x² - x + 1)/(x⁴ + 1)]
  fldln2                    ; stack ln(2) sin(x) [(3x³ - 5x² - x + 1)/(x⁴ + 1)]
  fld qword[val_x]          ; stack x ln(2) sin(x) [(3x³ - 5x² - x + 1)/(x⁴ + 1)]
  fmul st0, st0             ; stack x² ln(2) sin(x) [(3x³ - 5x² - x + 1)/(x⁴ + 1)]
  fld qword[val_x]          ; stack x x² ln(2) sin(x) [(3x³ - 5x² - x + 1)/(x⁴ + 1)]
  fdiv st0, st0             ; stack 1 x² ln(2) sin(x) [(3x³ - 5x² - x + 1)/(x⁴ + 1)]
  faddp                     ; stack (x² + 1) ln(2) sin(x) [(3x³ - 5x² - x + 1)/(x⁴ + 1)]
  fyl2x                     ; stack ln(1 + x²) sin(x) [(3x³ - 5x² - x + 1)/(x⁴ + 1)]
  fmulp                     ; stack [sin(x)ln(1 + x²)] [(3x³ - 5x² - x + 1)/(x⁴ + 1)]
  faddp                     ; stack [sin(x)ln(1 + x²) + (3x³ - 5x² - x + 1)/(x⁴ + 1)]
	fstp qword[val_x]
  movsd xmm0, qword[val_x]
	ret
