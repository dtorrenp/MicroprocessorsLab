#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	org 0x100		    ; Main code starts here at address 0x100
	
start	
	movlw 0x04
	movwf 0x05
	movlw 0x07
	movwf 0x06
	
	movlw 0x00 
	movwf TRISD, A		    ; all bits out on Port D
	movwf TRISE, A		    ; all bits out on Port E
	movwf TRISC, A
	movwf TRISF, A
	
increase 
	incf  0x05
	incf  0x06
	
ClockOnWrite	
	movlw 0x00		    ; Enable Port E output
	movwf TRISE, A	
	
	movlw 0x0A		    ; Diable memory outputs
	movwf PORTD		  	    
	movff 0x05, PORTE	    ; Set data pattern on Port E
	movlw 0x0B		    ; Clock in Memory 1
	movwf PORTD
	
	call delayset
	
	movlw 0x0A		    ; Diable memory outputs
	movwf PORTD
	
	call delayset
	
	movff 0x06, PORTE	    ; Set data pattern on Port E
	movlw 0x0E		    ; Clock in Memory 2
	movwf PORTD
	
clock_offRead
	movlw 0xFF		    ; Enable Port E input
	movwf TRISE, A	
	
	movlw  0x08		    ; Enable memory outputs
	movwf PORTD
	
	call delayset
	
	movff PORTE,PORTC	    ; Show read data
	
	movlw  0x02		    ; Enable memory outputs
	movwf PORTD
	
	call delayset
	
	movff PORTE,PORTF	    ; Show read data

	bra increase
	
delayset    movlw 0x02
	movwf 0x09
delay	decfsz 0x09
	bra delay
	return
	end
	