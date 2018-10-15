#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	org 0x100		    ; Main code starts here at address 0x100
	
start	movlw 0x00
	movwf 0x03
	movlw 0x00 
	movwf TRISD, A		    ; all bits out on Port F
	movwf TRISE, A		    ; all bits out on Port H
	
increase movff 0x03, PORTD
	incf  0x03
	
clock_on movlw  0x01
	movwf PORTE
	
clock_off movlw  0x00
	movwf PORTE
	
	bra increase
	
	end
	