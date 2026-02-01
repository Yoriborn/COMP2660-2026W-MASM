TITLE

; Name: 
; Date: 
; ID: 
; Description: 

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
	; data declarations go here
	; problem i
	myArray WORD 1, 2, 3, 4, 5 ; 0x1000
	myArraySize DWORD SIZEOF myArray ; Count the bytes used in myArray (SIZEOF returns bytes used)
	myArrayElements DWORD LENGTHOF myArray ; Counts the elements in myArray (LENGTHOF returns elements used by the datatype (WORD is 16 bits))

	; problem ii
	myByte1 BYTE "v"
	myByte2 BYTE ? ; ? = save space

	; problem iii
	myArray2 DWORD 10 DUP (-76)
.code
main PROC
	; problem i
	mov ecx, myArrayElements

	; problem ii ([operand] [destination], [source])
	movzx eax, myByte1 
	call WriteChar

	SUB eax, 20h 
	call WriteChar
	mov myByte2, al

	; problem iv (part A)
	mov eax, (11112222h)
	mov (myArray2 + 4), eax  
	
	; problem iv (part B)
	mov bx, WORD PTR myArray2 + 6

	call DumpRegs ; displays registers in console
	exit

main ENDP
END main
