TITLE

; Name: Tanver Alam
; ID: 110014918
; Date: Feb 2nd, 2026
; Description: Assignment 1, Question 3

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
; data declarations here

    Msg0 BYTE "Enter a value: ", 0 ; FEDCBA98
    Msg1 BYTE "bigEndian = ", 0
    Msg2 BYTE "littleEndian = ", 0

    Msg_h BYTE "h, ", 0

    bigEndian BYTE ?, ?, ?, ? ; 12, 34, 56, 78
    littleEndian DWORD 12345678h ; 78, 56, 34, 12 | To the machine this is the correct orientation

.code
main PROC
; program syntax here

    ; 0.
    mov edx, OFFSET Msg0
    call WriteString
    call ReadHex
    mov littleEndian, eax
    call Crlf

    ; 1.
    mov edx, OFFSET Msg1
    call WriteString

    movzx eax, BYTE PTR littleEndian + 3 ; Copy over data from littleEndian into EAX.
    mov BYTE PTR bigEndian, al ; Copy over data from AL into bigEndian.
                               ; EAX and AL are of the same set, 
                               ; EAX = full 32 bits & AL = first 8 bits.
    mov ebx, TYPE bigEndian ; Move the amount of bytes in the printed data type.
    call WriteHexB
    mov edx, OFFSET Msg_h
    call WriteString
    mov eax, DWORD PTR bigEndian

    movzx eax, BYTE PTR littleEndian + 2
    mov BYTE PTR bigEndian + 1, al
    mov ebx, TYPE bigEndian
    call WriteHexB
    mov edx, OFFSET Msg_h
    call WriteString
    mov eax, DWORD PTR bigEndian

    movzx eax, BYTE PTR littleEndian + 1
    mov BYTE PTR bigEndian + 2, al
    mov ebx, TYPE bigEndian
    call WriteHexB
    mov edx, OFFSET Msg_h
    call WriteString
    mov eax, DWORD PTR bigEndian

    movzx eax, BYTE PTR littleEndian
    mov BYTE PTR bigEndian + 3, al
    mov ebx, TYPE bigEndian
    call WriteHexB
    mov al, 'h'
    call WriteChar
    call Crlf

    ; 2. 
    mov edx, OFFSET Msg2
    call WriteString
    mov eax, littleEndian
    call WriteHex
    mov al, 'h'
    call WriteChar

    call Crlf
    call DumpRegs
    exit

main ENDP
END main
; ./run.sh Ass1-Q3