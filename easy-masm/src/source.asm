TITLE

; Name: 
; ID: 
; Date: 
; Description: 

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
                 
.code
main PROC
	

	exit
	call DumpRegs
main ENDP
END main
; ./run.sh Ass3