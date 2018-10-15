#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	org 0x100		    ; Main code starts here at address 0x100
	
start	
	movlw 0x00
	movwf 0x03
	movlw 0x00 
	movwf TRISD, A		    ; all bits out on Port D
	movwf TRISE, A		    ; all bits out on Port E
	
increase 
	movlw 0x01
	movwf TRISE, A
	movff 0x03, PORTE
	incf  0x03
	
ClockOnWrite
	movlw 0x00
	movwf TRISE, A
	movlw 0x01
	movwf PORTD
	
clock_offRead 	
	movlw  0x02
	movwf PORTD
	movlw 0xFF
	movwf TRISE, A
	movff PORTE,0x04
	
	bra increase
	
	end
	