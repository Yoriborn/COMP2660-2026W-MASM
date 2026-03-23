TITLE

; Name: 
; ID: 110014919
; Date: Mar 25th, 2026
; Description: Quiz 2, Exercise-1: Lab-53

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    RX WORD ? ; (A * B) / (C % D)

    Var_A WORD ? ; (A * ?)
    Var_B WORD ? ; (? * B)
    Prompt_A BYTE "Enter value for A: ", 0
    Prompt_B BYTE "Enter value for B: ", 0

    Var_C WORD ? ; (C % ?)
    Var_D WORD ? ; (? % D)
    Prompt_C BYTE "Enter value for C: ", 0
    Prompt_D BYTE "Enter value for D: ", 0

    ; mul = unsigned multiplication.
        ; imul = signed multiplication.

    ; div = unsigned division.
        ; idiv = signed division.

    ; cwd = sign extension for division, extends 16-bits to 32-bits.

.code
main PROC
; [STEP 1]: Get values A to D / AX to DX.
    mov edx, OFFSET Prompt_A
        call WriteString
            call ReadInt
                mov Var_A, AX

    mov edx, OFFSET Prompt_B
        call WriteString
            call ReadInt
                mov Var_B, AX

    mov edx, OFFSET Prompt_C
        call WriteString
            call ReadInt
                mov Var_C, AX

    mov edx, OFFSET Prompt_D
        call WriteString
            call ReadInt
                mov Var_D, AX

    mov AX, Var_A
        mov BX, Var_B
            mov CX, Var_C
                mov DX, Var_D

    call crlf
    
; [STEP 2]: Calculate (A * B).
    imul BX     
    mov BX, AX  ; BX stores the result.

; [STEP 3]: Calculate (C % D).
    mov AX, Var_C
    mov CX, Var_D
    cwd             
    
    idiv CX      
    mov CX, DX  ; CX Stores the result.

    cmp CX, 0
    jz Undefined    ; Jump if (C % D) = 0.
    jnz Defined     ; Jump if (C % D) != 0.
    
Defined:
; [Option 1]: Calculate (A * B) / (C % D).
    call Expression

    mov AX, BX
    cwd             
    
    idiv CX
    mov RX, AX ; RX Stores the result.

    call Result
    movsx eax, RX
    call WriteInt

    call crlf
        call DumpRegs
            exit

Undefined:
; [Option 2]: Undefined handler.
    call Expression
    call Result
    call Error

    call Crlf
        call DumpRegs
            exit

Result PROC
    mov al, 52h             ; ASCII for " R "
    call WriteChar

        mov al, 20h         ; ASCII for " "
        call WriteChar

            mov al, 3Dh     ; ASCII for " = "
            call WriteChar

        mov al, 20h         ; ASCII for " "
        call WriteChar

    ret
Result ENDP

Expression PROC
    call Result

        mov al, 28h     ; ASCII for " ( "
        call WriteChar

            movsx eax, Var_A    
            call WriteDec

                mov al, 20h         ; ASCII for " "
                call WriteChar

                    mov al, 2Ah     ; ASCII for " * "
                    call WriteChar

                mov al, 20h         ; ASCII for " "
                call WriteChar

            movsx eax, Var_B
            call WriteDec

        mov al, 29h     ; ASCII for " ) "
        call WriteChar

        mov al, 2Fh     ; ASCII for " / "
        call WriteChar

        mov al, 28h     ; ASCII for " ( "
        call WriteChar

            movsx eax, Var_C
            call WriteDec

                mov al, 20h         ; ASCII for " "
                call WriteChar

                    mov al, 25h     ; ASCII for " % "
                    call WriteChar

                mov al, 20h         ; ASCII for " "
                call WriteChar

            movsx eax, Var_D
            call WriteDec
            
        mov al, 29h     ; ASCII for " ) "
        call WriteChar

    call crlf
    ret
Expression ENDP

Error PROC
    mov al, 75h     ; ASCII for " u "
    call WriteChar

    mov al, 6Eh     ; ASCII for " n "
    call WriteChar

    mov al, 64h     ; ASCII for " d "
    call WriteChar

    mov al, 65h     ; ASCII for " e "
    call WriteChar

    mov al, 66h     ; ASCII for " f "
    call WriteChar

    mov al, 69h     ; ASCII for " i "
    call WriteChar

    mov al, 6Eh     ; ASCII for " n "
    call WriteChar

    mov al, 65h     ; ASCII for " e "
    call WriteChar

    mov al, 64h     ; ASCII for " d "
    call WriteChar

    ret
ERROR ENDP

main ENDP
END main
; ./run.sh Quiz2-E1