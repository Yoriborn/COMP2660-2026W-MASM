TITLE



INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
; date declarations here
    Msg1 BYTE "bigEndian = ", 0
    Msg2 BYTE "littleEndian = ", 0

    Msg_h BYTE "h, ", 0

    bigEndian BYTE 12h, 34h, 0ABh, 0CDh
    littleEndian DWORD ? ; BYTE 0CDh, 0ABh, 34h, 12h

    inputBuffer BYTE 16 DUP(0)

.code
main PROC
; program syntax here
    
    ; 1. bigEndian Data.
    mov edx, OFFSET Msg1
    call WriteString

    movzx eax, bigEndian ; Move the actual data from the array over into EAX.
    mov ebx, TYPE bigEndian ; Move the amount of bytes in the printed data type.
    mov BYTE PTR littleEndian + 3, al ; Copy over data from bigEndian into littleEndian, 
                                      ; AL is a subset of EAX. 
    call WriteHexB
    mov edx, OFFSET Msg_h
    call WriteString

    movzx eax, bigEndian + 1
    mov ebx, TYPE bigEndian 
    mov BYTE PTR littleEndian + 2, al
    call writeHexB
    mov edx, OFFSET Msg_h
    call WriteString

    movzx eax, bigEndian + 2
    mov ebx, TYPE bigEndian
    mov BYTE PTR littleEndian + 1, al
    call WriteHexB
    mov edx, OFFSET Msg_h
    call WriteString

    movzx eax, bigEndian + 3
    mov ebx, TYPE bigEndian
    mov BYTE PTR littleEndian, al
    call WriteHexB
    mov al, 'h'
    call WriteChar
    call Crlf

    ; 2. littleEndian Data.
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
; ./run.sh Ass1-Q2