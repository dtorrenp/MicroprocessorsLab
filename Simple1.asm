#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	org 0x100		    ; Main code starts here at address 0x100
	
start	movlw 0xFD
	movwf 0x03
	movlw 0x02
	movwf 0x04
	movlw 0x00 
	movwf TRISF, A		    ; all bits out
	movwf TRISH, A		    ; all bits out
	
increase movff 0x03, PORTF
	incf  0x03
	
clock_on movlw  0x03
	movwf PORTH
	
clock_off movlw  0x02
	movwf PORTH
	
	bra increase
	
	end
