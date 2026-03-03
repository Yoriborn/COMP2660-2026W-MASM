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
                 
.code
main PROC
	call DumpRegs
	push 32
	call DumpRegs

	ret
main ENDP
END main
; ./run.sh Ass3