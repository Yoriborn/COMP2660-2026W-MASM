TITLE

; Name: 
; ID: 110014918
; Date: Feb 15th 2026
; Description: Assignment 2, Question 2

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    Prompt1 BYTE "What is Integer N?> ", 0
    Prompt2 BYTE "Fibonacci sequence with N = ", 0
    Prompt2_End BYTE " is: ", 0
    Integer_N DWORD ?

    var1 DWORD 0
    var2 DWORD 1
    output DWORD ?

.code
main PROC
;([operand] [destination], [source])

    mov edx, OFFSET Prompt1
    call WriteString
    call ReadDec
    mov Integer_N, eax
    
    mov edx, OFFSET Prompt2
    call WriteString
    call WriteDec
    mov edx, OFFSET Prompt2_End
    call WriteString

    ; Write the first two numbers
    mov eax, var1
    call WriteDec
    mov eax, 20h
    call WriteChar
    
    mov eax, var2
    call WriteDec
    mov eax, 20h
    call WriteChar

    ; Sub 2 from Integer_N for the values we printed
    mov eax, Integer_N
    sub eax, 2
    mov Integer_N, eax

start:
    ; 1. Perform fib calc (var1 + var2 = output) and display value
    mov eax, var1
    add eax, var2 ; var1 + var2
    call WriteDec
    mov output, eax
    
    mov eax, 20h ; Place a space
    call WriteChar

    ; 2. var1 = var2
    mov eax, var2
    mov var1, eax

    ; 3. var2 = output
    mov eax, output
    mov var2, eax
    
    ; 4. Check if at n value (n == 0)
    mov eax, Integer_N
    cmp eax, 0
    jz done
    
    ; 5. go to step 1
    mov eax, Integer_N
    sub eax, 1
    mov Integer_N, eax
    jmp start 

done:
    call Crlf
    exit

main ENDP
END main
; ./run.sh Ass2-Q2 