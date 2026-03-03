TITLE

; Name: 
; ID: 110014918
; Date: Mar 2nd, 2026
; Description: Assignment 3

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    StartValid BYTE "What do you want to do now?> ", 0
    StartInvalid BYTE "Invalid entry, please try 1, 2, 3 or -1 to exit!", 0

    ; Ouroboros Data
    Prompt_Stack_YESEmpty BYTE "Stack is empty.", 0
    Prompt_Stack_NOTEmpty BYTE "Stack is NOT empty.", 0
    Prompt_Vector_is BYTE "Vector is ", 0
    Prompt_Stack_is BYTE "Stack is  ", 0
    Prompt_Error_1 BYTE "Error - Stack is empty: Cannot perform StackToArray.", 0
    Prompt_Error_2 BYTE "Error - Array is empty: Cannot perform ArrayToStack.", 0
    Prompt_Space BYTE "   ", 0

    ; Data if 0
    Prompt_0A BYTE "What is the size N of Vector?> ", 0
    Prompt_Too_Large BYTE "N must be lower than 20!", 0
    Size_N DWORD 0 

    Prompt_0B BYTE "What are the ", 0
    Prompt_0C BYTE " values in Vector?> ", 0
    Prompt_0D BYTE "[VECTOR ", 0
    Prompt_0E BYTE "]> ", 0
    Values_N SDWORD 50 DUP(0)  

    Prompt_0F BYTE "Size of Vector is N = ", 0
    Prompt_0G BYTE "Vector = ", 0

    ; Data if 1
    Prompt_1A BYTE " before ArrayToStack.", 0
    Prompt_1B BYTE " after ArrayToStack.", 0

    ; Data if 2
    Prompt_2A BYTE " before StackToArray.", 0
    Prompt_2B BYTE " after StackToArray.", 0

    ; Data if 3
    Prompt_3A BYTE " before StackReverse.", 0
    Prompt_3B BYTE " after StackReverse.", 0

    ; Data if -1
    Prompt_Exit BYTE "I am exiting... Thank you... and Get lost...", 0

    Items_On_Stack DWORD 0
                        
.code
main PROC
Alive_Code:
    call Crlf
    call Crlf

    mov edx, OFFSET StartValid
    call WriteString
    call ReadInt

    cmp eax, 0
    je Create_New_Vector 
    
    cmp eax, 1
    je Fill_Stack_From_Vector ; ArrayToStack

    cmp eax, 2
    je Fill_Vector_From_Stack ; StackToArray

    cmp eax, 3
    je Reverse_Vector_Using_StackStack ; StackReverse

    cmp eax, -1
    je Kill_Code ; Exit

    jmp Invalid

Invalid:
    mov edx, OFFSET StartInvalid
    call WriteString

    call Crlf
    jmp Alive_Code

Create_New_Vector: ;JUMP HERE IF STARTVALID = 0
    call Crlf
    
    ;What is the size N of vector?
    mov edx, OFFSET Prompt_0A
    call WriteString
    call ReadDec
    cmp eax, 20 ; ensure vector size isn't over 20
    ja Over_Max_Size
    mov Size_N, eax

    call Crlf
    
    ; What are the N values in Vector?
    mov edx, OFFSET Prompt_0B
    call WriteString
    mov eax, Size_N
    call WriteDec
    mov edx, OFFSET Prompt_0C
    call WriteString

    call Crlf

    mov ecx, Size_N
    mov edi, OFFSET Values_N 
    mov ebx, 1
Vector_Values:
    ; [VECTOR N + 1]
    mov edx, OFFSET Prompt_0D
    call WriteString
    mov eax, ebx
    call WriteDec
    mov edx, OFFSET Prompt_0E
    call WriteString

    call ReadInt
    mov [edi], eax
    add edi, 4

    inc ebx
    loop Vector_Values

    call Crlf

    ; Size of Vector is N = ...
    mov edx, OFFSET Prompt_0F
    call WriteString
    mov eax, Size_N
    call WriteDec

    call Crlf

    mov edx, OFFSET Prompt_0G
    call WriteString

    call Display_Vectors
    call Display_Stack
    jmp Alive_Code

Over_Max_Size:
    mov edx, OFFSET Prompt_Too_Large
    call WriteString
    call Crlf
    jmp Create_New_Vector

Fill_Stack_From_Vector: ;JUMP HERE IF STARTVALID = 1 (ARRAY_TO_STACK)
    call Crlf

    ; Print State
    ; Vector is [VECTORS] + before ArrayToStack.
    mov edx, OFFSET Prompt_Vector_is
    call WriteString
    call Display_Vectors
    mov edx, OFFSET Prompt_1A
    call WriteString

    call Crlf

    mov ecx, Size_N
    mov edi, OFFSET Values_N ; = 1, 2, 3
Push_Array_toStack:
    mov eax, [edi] ; 3, 2, 1 is the state of the stack
    push eax
    mov DWORD PTR [edi], 0  ; NOTE CHANGED
    add edi, 4
    loop Push_Array_toStack

    ; Update the count of items on the stack
    mov eax, Items_On_Stack
    add eax, Size_N
    mov Items_On_Stack, eax

    ; Print State
    ; Stack is [Stack]  After ArrayToStack.
    mov edx, OFFSET Prompt_Stack_is
    call WriteString
    call Display_Stack
    mov edx, OFFSET Prompt_1B
    call WriteString

    call Crlf
    
    ; Vector is [VECTORS] + after ArrayToStack.
    mov edx, OFFSET Prompt_Vector_is
    call WriteString
    call Display_Vectors
    mov edx, OFFSET Prompt_1B
    call WriteString

    call Crlf

    mov edx, OFFSET Prompt_Stack_NOTEmpty ; NOTE CHANGE
    call WriteString

    call Crlf

    jmp Alive_Code

Fill_Vector_From_Stack: ;JUMP HERE IF STARTVALID = 2 (STACK_TO_ARRAY)
    ; Check Stack <- NOTE CHANGE
    mov eax, Items_On_Stack
    cmp eax, 0
    je Stack_Error

    call Crlf

    ; Print State
    ; Stack is [Stack] before StackToArray.
    mov edx, OFFSET Prompt_Stack_is
    call WriteString
    call Display_Stack
    mov edx, OFFSET Prompt_2A
    call WriteString

    call Crlf

    mov ecx, Size_N
    mov edi, OFFSET Values_N
    ; Start at the END of Values_N
    mov ebx, ecx
    shl ebx, 2 ; Mult by 4` 
    add edi, ebx
    sub edi, 4
Pop_Stack_toArray:
    pop eax
    mov [edi], eax
    sub edi, 4
    loop Pop_Stack_toArray

    ; Update the count of items on the stack
    mov eax, Items_On_Stack
    sub eax, Size_N
    mov Items_On_Stack, eax

    ; Vector is [Vectors] after StacktoArray
    mov edx, OFFSET Prompt_Vector_is
    call WriteString
    call Display_Vectors
    mov edx, OFFSET Prompt_2B
    call WriteString

    call Display_Stack ; NOTE CHANGED

    jmp Alive_Code

Reverse_Vector_Using_StackStack: ;JUMP HERE IF STARTVALID = 3 (STACK_REVERSE)
    call Crlf

    ; Print State
    ; Vector is [VECTORS] before StackReverse.
    mov edx, OFFSET Prompt_Vector_is
    call WriteString
    call Display_Vectors
    mov edx, OFFSET Prompt_3A
    call WriteString

    call Crlf

    mov ecx, Size_N
    mov edi, OFFSET Values_N ; = 1, 2, 3
Reverse_Push:
    mov eax, [edi] ; 3, 2, 1 is the state of the stack
    push eax
    add edi, 4
    loop Reverse_Push

    ; update stack <- NOTE CHANGE
    mov eax, Items_On_Stack
    add eax, Size_N
    mov Items_On_Stack, eax

    mov edx, OFFSET Prompt_Stack_NOTEmpty
    call WriteString

    call Crlf

    mov ecx, Size_N
    mov edi, OFFSET Values_N ; = 1, 2, 3
Reverse_Pop:
    pop eax
    mov [edi], eax
    add edi, 4
    loop Reverse_Pop

    ; update stack <- NOTE CHANGE
    mov eax, Items_On_Stack
    sub eax, Size_N
    mov Items_On_Stack, eax

    ; Print State
    ; Vector is [Vectors] after StackReverse.
    mov edx, OFFSET Prompt_Vector_is
    call WriteString
    call Display_Vectors
    mov edx, OFFSET Prompt_3B
    call WriteString

    call Crlf

    mov edx, OFFSET Prompt_Stack_YESEmpty
    call WriteString

    call Crlf

    jmp Alive_Code

Display_Vectors PROC
	mov ecx, Size_N
	mov edi, OFFSET Values_N
Display_Vectors_Loop:
	; Get value
    mov eax, [edi]
    call WriteDec
	; Print out spacers
	mov edx, OFFSET Prompt_Space
    call WriteString
	; Prepare next value
	add edi, 4

    loop Display_Vectors_Loop
	; call Crlf
    ret
Display_Vectors ENDP

Display_Stack PROC
    ; Check if stack is empty
    mov eax, Items_On_Stack
    cmp eax, 0
    jz Stack_Empty

    ; Otherwise stack is not empty
    mov ecx, Items_On_Stack
    mov edi, esp ; Just read from the stack directly (minus the return address)
    add edi, 4
Display_Stack_Loop:
    ; Get value
    mov eax, [edi]
    call WriteDec
    ; Print out spacers
    mov edx, OFFSET Prompt_Space
    call WriteString
    ; Prepare next value
    add edi, 4
    
    loop Display_Stack_Loop
    ; call Crlf
    mov edi, OFFSET Prompt_Stack_NOTEmpty
    call WriteString
	ret
Stack_Empty:
    call Crlf
    mov edx, OFFSET Prompt_Stack_YESEmpty
    call WriteString
    ret
Display_Stack ENDP

Stack_Error:
    mov edx, OFFSET Prompt_Error_1
    call WriteString

    jmp Alive_Code

Kill_Code: ;JUMP HERE IF STARTVALID = -1
    call Crlf
    
    mov edx, OFFSET Prompt_Exit
    call WriteString
    call Crlf
	exit
main ENDP
END main
; ./run.sh Ass3