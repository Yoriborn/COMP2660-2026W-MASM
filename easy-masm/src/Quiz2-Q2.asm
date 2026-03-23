TITLE

; Name: 
; ID: 110014919
; Date: Mar 25th, 2026
; Description: Quiz 2, Problem 2

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    Prompt1 BYTE "What is Integer N?> ", 0
    Prompt2 BYTE "Fibonacci sequence with N = ", 0
	Prompt3 BYTE " is: ", 0

    Integer_N DWORD ?
    Integer_K DWORD 0

.code
main PROC
; [STEP 1]: Get N.
    mov edx, OFFSET Prompt1
    call WriteString
    call ReadDec
    mov Integer_N, eax
    
    mov edx, OFFSET Prompt2
    call WriteString
	mov eax, Integer_N
    call WriteDec

	mov edx, OFFSET Prompt3
	call WriteString

Start:
; [STEP 2]: Calculate K.
	mov eax, Integer_K
	push eax

	call Fibonacci
	add esp, 4

; [STEP 3]: Print Fibonacci Number + Spaces.
	call WriteDec
	
	mov al, 20h		; ASCII for " "
	call WriteChar
	mov al, 20h		; ASCII for " "
	call WriteChar

; [STEP 4]: Increase K.
	mov eax, Integer_K
	inc eax
	mov Integer_K, eax

; [STEP 5]: Check if K == N.
	mov eax, Integer_K
	cmp eax, Integer_N

	jg Quit
	jmp Start
Quit:
	call Crlf
	exit

Fibonacci PROC
; EAX -> Input
; EAX <- Output
	cmp eax, 0
	je Fibonacci_Zero	; Jump if exactly 0.

	cmp eax, 1
	je Fibonacci_One	; Jump if exactly 1.

	jmp Continue

	Fibonacci_Zero:
		mov eax, 0
		ret

	Fibonacci_One:
		mov eax, 1
		ret

	Continue:
		push ebx	; Preserve state of prior call.
		push eax	; Preserve state of prior call.

		; [STEP 2.2]: Fibonacci (N-1).
		sub eax, 1
		call Fibonacci

		mov ebx, eax
		pop eax		; Resume state after call.

		; [STEP 2.3]: Fibonacci (N-2).
		sub eax, 2
		call Fibonacci

		add eax, ebx
		pop ebx		; Resume state after call.
		
	ret
Fibonacci ENDP

main ENDP
END main
; ./run.sh Quiz2-Q2