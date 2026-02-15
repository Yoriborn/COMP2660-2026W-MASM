TITLE

; Name: 
; ID: 110014918
; Date: Feb 15th 2026
; Description: Assignment 2, Question 3

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    Prompt0A BYTE "C:\Programming\asm>Ass2-Q3", 0
    Prompt0B BYTE "C:\Programming\asm>", 0

    Prompt1 BYTE "Enter a string of at most 128 characters: ", 0
    Prompt2 BYTE "Here it is, with all lowercases and uppercases flipped, and in reverse order: ", 0
    
    Input BYTE 128 DUP(0), 0
    InputLen DWORD ?
    Reverse BYTE 128 DUP(0), 0
    CountUpper DWORD 0

    Prompt3 BYTE "There are ", 0
    Prompt3A BYTE " upper-case letters after conversion.", 0
    Prompt3B Byte " characters in the string.", 0

.code
main PROC
;([operand] [destination], [source])
    mov edx, OFFSET Prompt0A
    call WriteString

    call Crlf

    mov edx, OFFSET Prompt1
    call WriteString

    mov edx, OFFSET Input
    mov ecx, 128
    call ReadString
    
    ; Get length of the string
    mov edx, OFFSET Input
    call StrLength
    mov InputLen, eax

    mov ecx, 0 ; ecx to count current position
reverse_loop: ; reverse[strlen - 1 - ecx] = input[ecx]
    ; Reverse one char in the string
    mov al, [Input + ecx]
    mov ebx, InputLen ; len - 1 - ecx (index)
    sub ebx, 1
    sub ebx, ecx
    mov [Reverse + ebx], al
    inc ecx ; Increment ecx to get the next char in the string

    ; Check to see if done (check if the index != strlen)
    mov ebx, InputLen 
    cmp ebx, ecx ; ecx - ebx and set flags
    jnz reverse_loop ; check ZF != 0, and jump if true

    ; This is after the loop
    call Crlf
    

    ; Working with REVERSE!
    ; if char > 60h && char < 7bh it's lowercase
    ; if char > 40h && char < 5bh it's uppercase
    ; upper -> lower = char + 20h
    ; lower -> upper = char - 20h

    mov ecx, 0
case_loop:
    mov al, [Reverse + ecx]

check_lower:
    ; Check if lowercase
    ; above/below for unsigned, greater/less for signed ; 7Dh
    cmp al, 60h ; al > 60h ? 
    jna check_upper
    cmp al, 7bh ; al < 7bh ?
    jb to_upper

check_upper:
    ; Check if uppercase
    cmp al, 40h ; al > 40h ?
    jna continue
    cmp al, 5bh ; al < 5bh ?
    jb to_lower

continue:
    inc ecx ; get next char
    
    ; Check index bounds
    mov ebx, InputLen 
    cmp ebx, ecx ; ecx - ebx and set flags
    jnz case_loop ; check ZF != 0, and jump if true
    jmp done

to_upper: ; Converts lower -> upper
    sub al, 20h
    mov [Reverse + ecx], al
    inc CountUpper
    jmp continue

to_lower: ; Converts upper -> lower
    add al, 20h
    mov [Reverse + ecx], al
    jmp continue

done:
    mov edx, OFFSET Prompt2
    call WriteString
    mov edx, offset Reverse
    call WriteString

    call Crlf
    
    mov edx, OFFSET Prompt3
    call WriteString
    mov eax, CountUpper
    call WriteDec
    mov edx, OFFSET Prompt3A
    call WriteString

    call Crlf
    
    mov edx, OFFSET Prompt3
    call WriteString
    mov eax, InputLen
    call WriteDec
    mov edx, OFFSET Prompt3B
    call WriteString
    
    call Crlf
    
    mov edx, OFFSET Prompt0B
    call WriteString
    call Crlf
    exit

main ENDP
END main
; ./run.sh Ass2-Q3