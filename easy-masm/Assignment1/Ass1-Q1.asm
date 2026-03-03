TITLE 

; Name: 
; ID: 110014918
; Date: Feb 2nd, 2026
; Description: Assignment 1, Question 1

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data 
; data declarations here
    Var_A SDWORD (-543210)
    Var_B SWORD (-3210)

    Msg_C BYTE "What is the value of C? ", 0 ; 0dh = \r 
                                             ; 0da = \n
    Var_C SDWORD ? ; -43210

    Msg_D BYTE "What is the value of D? ", 0 ; 0dh = \r 
                                             ; 0da = \n
    Var_D SBYTE ? ; -10

    Var_Z SDWORD ?
    Var_Z1 SDWORD ?
    Var_Z2 SDWORD ?

    Msg_Display BYTE "Z = (A - B) - (C - D)", 0
    Msg_Space BYTE "   ;   ", 0

    Msg_Z BYTE "Z = ", 0
    Msg_Binary BYTE "Binary = ", 0
    Msg_Decimal BYTE "Decimal = ", 0
    Msg_Hexa BYTE "Hexadecimal = ", 0
    
    inputBuffer BYTE 16 DUP(0)

.code
main PROC 
; program syntax here
;([operand] [destination], [source])

    mov edx, OFFSET Msg_C ; WriteString expects the memory address of the string to be in `edx`
    call WriteString
    call ReadInt ; Loads the console input into register `eax`
    mov Var_C, eax
    call WriteInt ; Expects the value to print to be in the `eax` register
 
    mov edx, OFFSET Msg_D
    call Crlf 
    call WriteString
    call ReadInt
    mov Var_D,  al
    call WriteInt
    
    call Crlf
    mov edx, OFFSET Msg_Display
    call WriteString 
    call Crlf
    
    mov eax, Var_A
    call WriteInt
    mov edx, OFFSET Msg_Space
    call WriteString

    movsx eax, Var_B     ; movzx puts zeros in all unused portions of the register
                         ; movsx does the same things as movzx, but keeps negative integers as negatives.
    call WriteInt
    mov edx, OFFSET Msg_Space
    call WriteString

    mov eax, Var_C
    call WriteInt
    mov edx, OFFSET Msg_Space
    call WriteString

    movsx eax, Var_D
    call WriteInt
    call Crlf ; Empty line

    ; 1. Z = -(-A - B) - (-C - D)
    mov eax, Var_A
    imul eax, -1 ; imul = signed, mul = unsigned
    movsx ebx, Var_B
    sub eax, ebx
    mov Var_Z1, eax

    ; 2. Z = -(Var_Z1) - (-C - D)
    mov eax, Var_C
    imul eax, -1
    movsx ebx, Var_D
    sub eax, ebx
    mov Var_Z2, eax

    ; 3. Z = -(Var_Z1) - (Var_Z2)
    mov eax, Var_Z1
    imul eax, -1
    mov ebx, Var_Z2
    sub eax, ebx
    mov Var_Z, eax 

    ; Print all values of Z
    call Crlf 
    mov edx, OFFSET Msg_Z 
    call WriteString 
    mov eax, Var_Z
    call WriteInt

    call Crlf 
    mov edx, OFFSET Msg_Binary
    call WriteString
    call WriteBin

    call Crlf 
    mov edx, OFFSET Msg_Decimal
    call WriteString
    call WriteDec

    call Crlf 
    mov edx, OFFSET Msg_Hexa
    call WriteString
    call WriteHex

    call Crlf 
    call DumpRegs ; displays registers in console
    exit

main ENDP
END main
; ./run.sh Ass1-Q1