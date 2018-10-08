	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw 	0xFF
	movwf	TRISD, ACCESS	    ; Port D all inputs
	movlw 	0x00
	movwf	TRISC, ACCESS	    ; Port C all outputs
	bra 	test
loop	movff 	0x07, PORTC
	incf 	0x07, W, ACCESS
test	movwf	0x07, ACCESS	    ; Test for end of loop condition
	movf	PORTD, W, ACCESS	    ; use Port D to set length of loop
	cpfsgt 	0x07, ACCESS
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start
	
	end
