TITLE

; Name: 
; ID: 110014918
; Date: Feb 15th 2026
; Description: Assignment 2, Question 1

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    Prompt1A BYTE "What is the size N of Vector?> ", 0
    Prompt1B BYTE "Size must be positive or non-zero.", 0
    Size_N DWORD ? ; 13

    Prompt2A BYTE "[VECTOR ", 0
    Prompt2B BYTE " What are the ", 0
    Prompt2C BYTE " values in Vector?> ", 0
    Values_N SDWORD 50 DUP(0) ; -1 +3 +17 0 -100 -30 +2 -30 -100 0 +17 +3 -1
    Values_NREV SDWORD 50 DUP(0) ; 

    Prompt3 BYTE "Size of Vector is N = ", 0
    Prompt4A BYTE "Vector = ", 0
    Prompt4B Byte "   ", 0

    Prompt5 BYTE "The sum of all the negative values in Vector is: Sum = ", 0
    Values_NEG SDWORD 0 

    Prompt6 BYTE "The number of all the positive values in Vector is: Count = ", 0
    Values_POS SDWORD 0

    Prompt7A BYTE "Please give me two values I and J such that 1 <= I <= J <= N > ", 0
    Prompt7B BYTE "Invalid I or J.", 0

    Prompt7I BYTE "[VALUE I]> ", 0
    Value_I DWORD 0
    Prompt7J BYTE "[VALUE J]> ", 0
    Value_J DWORD 0
    
    Prompt8A BYTE "The minimum value between position ", 0
    Prompt8B BYTE " and ", 0
    Prompt8C BYTE " of Vector is: Minimum = ", 0
    Value_MIN SDWORD 0

    Prompt9A BYTE "Vector is a palindrome because it reads the same way in both directions.", 0
    Prompt9B BYTE "Vector is NOT a palindrome.", 0

    Prompt10 BYTE "Repeat with a new Vector of different size and/or content?> ", 0
    Input_Y BYTE 2 DUP (?)

    ;inputBuffer BYTE 512 DUP(0) ; String holding the users numbers for the array
    ;inputPtr DWORD offset inputBuffer ; Pointer to the beginning of the string to parse
.code
main PROC
;([operand] [destination], [source])

start:
    ; Refresh values
    mov Values_NEG, 0
    mov Values_POS, 0

    ; Get the size N
    call Crlf
    mov edx, OFFSET Prompt1A
    call WriteString
    call ReadDec
    cmp eax, 0
    
    jz invalid ; if the return value is zero, the number is invalid
    jmp valid
    
invalid:
    call Crlf
    mov edx, OFFSET Prompt1B
    call WriteString

    call Crlf
    
    jmp start

valid:
    mov Size_N, eax

    call Crlf

    ; Get the values for N
    mov ecx, Size_N
    mov edi, OFFSET Values_N ; edi has the address of Values_N
    mov ebx, 1

values:
    mov edx, OFFSET Prompt2A
    call WriteString
    mov eax, ebx
    call WriteDec
    mov al, ']'
    call WriteChar

    mov edx, OFFSET Prompt2B
    call WriteString

    mov eax, Size_N
    call WriteDec

    mov edx, OFFSET Prompt2C
    call WriteString

    call ReadInt    ; eax has return value of ReadDec
    mov [edi], eax  ; [edi] means address in edi
    add edi, 4      ; increment address by one SDWORD (go to next element in array)

    inc ebx
    loop values

    call Crlf

    mov edx, OFFSET Prompt3
    call WriteString
    mov eax, Size_N
    call WriteDec

    call Crlf

    mov edx, OFFSET Prompt4A
    call WriteString

    ; init display loop
    mov ecx, Size_N
    mov edi, OFFSET Values_N ; Pointer to position in array

display:
    mov eax, [edi]
    call WriteInt

    mov edx, OFFSET Prompt4B
    call WriteString

    cmp eax, 0
    jl negative
    jg positive
    jmp done

positive: ; increment count of positive numbers
    inc Values_POS
    jmp done

negative: ; Add eax to sum of negative numbers
    add Values_NEG, eax
    jmp done
    
done:
    add edi, 4
    loop display
    
    call Crlf
    call Crlf

    mov edx, OFFSET Prompt5
    call WriteString
    mov eax, Values_NEG
    call WriteInt

    call Crlf

    mov edx, OFFSET Prompt6
    call WriteString
    mov eax, Values_POS
    call WriteDec

    call Crlf
    call Crlf
    
    ; Pick two elements WITHIN the array, and I must be a lesser element or equal to J
    ; ie. I = 3 J = 4 N = 13
    ; I & J Math 1 ≤ I ≤ J ≤ N >
        ; 1 less than or equal to I
            ; I less than or equal to J
                ; J less than or equal to N
                    ; N greater than or equal to J

ij_values:                    
    mov edx, OFFSET Prompt7A
    call WriteString
    call Crlf

    mov edx, OFFSET Prompt7I
    call WriteString
    call ReadDec    ; get value of I
    mov Value_I, eax

    mov edx, OFFSET Prompt7J
    call WriteString
    call ReadDec    ; get value of J
    mov Value_J, eax
    
    ; perform checks...
        ; i < 1
            ; i < J
                ; J < i
                    ; N > 1
                        ; N > i
                            ; N > J
    mov eax, Value_I 
    cmp eax, 0  ; i > 0
    jng invalid_ij

    mov eax, Value_J
    cmp eax, 0  ; j > 0
    jng invalid_ij
    
    mov ebx, Value_I
    cmp eax, ebx ; j > 0
    jng invalid_ij

    mov eax, Size_N
    cmp eax, 0 ; N > 0
    jng invalid_ij

    mov ebx, Value_I
    cmp eax, ebx ; N > i
    jng invalid_ij
    
    mov ebx, Value_J
    cmp eax, ebx ; N > J
    jnge invalid_ij
    
    jmp good_ij

invalid_ij:
    call Crlf
    mov edx, OFFSET Prompt7B
    call WriteString

    call Crlf
    jmp ij_values

good_ij:
    
    ; Set edi to the index to start at (I - 1)
    mov edi, OFFSET Values_N ; Start at the beginning of the array    
    mov eax, Value_I    ; edi += (Value_I - 1) * 4
    dec eax
    shl eax, 2 ; multiply by 4 by shifting the bits over 2 times to the left
    add edi, eax

    ; Set the count of items to check (J - 1 + 1)
    mov ecx, Value_J 
    sub ecx, Value_I
    add ecx, 1

    ; Set the lowest value to the first value in the array
    mov eax, [edi]    
    mov Value_MIN, eax
    
    
lowest:
    mov eax, [edi]
    cmp eax, Value_MIN
    jl lower
    jmp not_lower

lower:
    mov Value_MIN, eax

not_lower:
    add edi, 4
    loop lowest

    call Crlf
    
    mov edx, OFFSET Prompt8A
    call WriteString
    mov eax, Value_I
    call WriteDec

    mov edx, OFFSET Prompt8B
    call WriteString
    mov eax, Value_J
    call WriteDec

    mov edx, OFFSET Prompt8C
    call WriteString
    mov eax, Value_MIN
    call WriteInt

    call Crlf
    call Crlf
    
    ; Compare if Vector is or is NOT a Palindrome
    mov edi, OFFSET Values_N
    mov ecx, Size_N ; Current index
reverse_loop:
    ; Addr to insert = Value_NREV + ((ecx - 1) * 4)
    mov ebx, OFFSET Values_NREV ; address of the index into the reversed array
    mov eax, ecx    ; ecx (eax holds the ecx value to not change the loop counter)
    dec eax         ; (ecx - 1)
    shl eax, 2      ; (ecx - 1) * 4
    add ebx, eax    ; Value_NREV + ((ecx - 1) * 4)

    mov eax, [edi] ; get the value
    mov [ebx], eax ; place forward array value into reversed array
    add edi, 4     ; Move to next item in the forward array
    loop reverse_loop
    
    mov edi, OFFSET Values_N
    mov edx, OFFSET Values_NREV
    mov ecx, Size_N
pal_check:
    mov eax, [edi]
    mov ebx, [edx]
    cmp eax, ebx

    jnz not_pal

    add edi, 4
    add edx, 4
    
    loop pal_check
    
    ; Print it is a palindrome
    mov edx, OFFSET Prompt9A
    call WriteString
    call Crlf
    jmp pal_done
    
not_pal:
    mov edx, OFFSET Prompt9B
    call WriteString
    call Crlf

pal_done:
    call Crlf
    mov edx, OFFSET Prompt10
    call WriteString

    mov edx, OFFSET Input_Y
    mov ecx, 2
    call ReadString
    mov al, Input_Y
    cmp al, "Y"
    je start

    call Crlf
    exit

main ENDP
END main
; ./run.sh Ass2-Q1
