TITLE

; Name: 
; ID: 110014918
; Date: Mar 18th, 2026
; Description: Assignment 4

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    Hello BYTE "What do you want to do? ", 0 ; (W/w or R/r)
    Goodbye_1 BYTE "Thank you, Sweetey Honey Bun...", 0 
    GoodBye_2 BYTE "Get Lost, you Sweetey Honey Bun...", 0  

    Number_Input BYTE "Enter a Number: ", 0 ; Convert Number to Hexadecimal-String.
    String_Input BYTE "Enter a String: ", 0 ; Convert Hexadecimal-String to Number.

    HexNumbers BYTE "0123456789ABCDEF" ; DEADBEEF | 3735928559
    InputBuffer BYTE 10 DUP(0), 0

.code

main PROC
Start:
;--------------------------------;
;--------START & QUIT CODE-------;
;--------------------------------;
    mov edx, OFFSET Hello
    call WriteString
    call ReadChar

    cmp al, "w"
        je Num_toHex 
    cmp al, "W" 
        je Num_toHex

    cmp al, "r"
        je Hex_toNum
    cmp al, "R"
        je Hex_toNum

    jmp Invalid 
Invalid: 
    call Crlf
    mov edx, OFFSET Goodbye_2
    call WriteString

    call Crlf
    jmp Quit
Quit:
    call Crlf
    exit
    
;--------------------------------;
;---------HEXOUTPUT CODE---------;
;--------------------------------;
Num_toHex: 
    call Crlf
    mov edx, OFFSET Number_Input
    call WriteString
    call ReadDec

    mov ebx, eax
    call HexOutput

    call Crlf
    mov edx, OFFSET Goodbye_1
    call WriteString
    call Quit
HexOutput PROC
    ; EBX -> Number to print to terminal as HEX string.

    mov ecx, 8 ; 8 bytes in 32 bits.
    HexOutput_Loop:
        ; Step 1: Calculate how much to shift by (offset -> eax).
        mov eax, ecx                ; offset = eax
        dec eax                     ; offset = eax - 1
        shl eax, 2                  ; offset = [(eax - 1) * 4] || 4 bits needd at a time.

        ; Step 2: Shift and Mask the 4 bits for current char (index -> edx).
        push ecx                    ; Save ecx to the stack since we need 'cl' for operation 'shr'.
        mov edx, ebx
        mov ecx, eax
        shr edx, cl                 ; shr = Shift Right ( eax >> offset ).
        pop ecx                     ; Restore ecx from the stack.
        and edx, 0Fh                ; and = (edx >> offset ) & 0b1111.

        ; Step 3: Use the 4 bits isolated as an index into HexNumbers.
        mov al, [HexNumbers + edx]  ; Put char at index edx into al.
        call WriteChar
        loop HexOutput_Loop

    ; Step 4: Finish with 'h'
    mov al, "h"
    call WriteChar
    call Crlf
    ret
HexOutput ENDP

;--------------------------------;
;----------HEXINPUT CODE---------;
;--------------------------------;
Hex_toNum: 
    call Crlf
    mov edx, OFFSET String_Input
    call WriteString
    call ReadString

    call HexInput

    call Crlf
    mov edx, OFFSET Goodbye_1
    call WriteString
    call Quit
HexInput PROC
    ; EAX -> Destination of parsed hex string from console

    ; Step 1: Read in the input.
    mov edx, OFFSET InputBuffer
    mov ecx, 9                  ; Only allow 9 chars, 8 hex digits and one 'h' character.
    call ReadString

    mov edi, OFFSET InputBuffer
    mov ecx, 8
    xor ebx, EBX                ; EBX = 0

    ; Step 2: Get the current character through a loop.
    ParseChar_Loop:
        push ecx
        mov eax, 8              ; Offset = 8 - ecx.
        sub eax, ecx
        mov ecx, eax
        mov al, [edi + ecx]
        pop ecx

        ; Step 3: Parse the character into an integer.
        cmp al, "9"
        ja Char_Letter          ; If AL is above "9", it's a letter.
        jmp Char_Number         ; Otherwise it's a number.

                ; Option 1: The current character is A <-> F.
                Char_Letter:
                sub al, "A"     ; A == 0x41
                add al, 10
                jmp Hex_Found

                ; Option 2: The current character is 0 <-> 9.
                Char_Number:
                sub al, "0"     ; 0 == 0x30
                jmp Hex_Found

        ; Step 4: Shift the left side by 4, then insert 4 bits into BL.
        Hex_Found:
        shl ebx, 4              ; Shift left by 4 bits.
        and eax, 0Fh            ; Mask the 4 bits.
        or bl, al               ; Insert.
        
    loop ParseChar_Loop

    ; Step 5: Print the output.
    mov eax, ebx
    call WriteDec
    call Crlf
    ret
HexInput ENDP

main ENDP
END main

; ./run.sh Ass4