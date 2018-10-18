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
	movwf TRISJ, A
	
	movlw 0x0F		    ; Set all to high
	movwf PORTD
	
increase 
	incf  0x05
	incf  0x06
	
ClockOnWrite	
	movlw 0x00		    ; Enable Port E output
	movwf TRISE, A	
	
	movff 0x05, PORTE	    ; Set data pattern on Port E
	
	movlw 0x0E		    ; clock one to low
	movwf PORTD		  	    

	movlw 0x0F		    ; Clock one high
	movwf PORTD
	
	movff 0x06, PORTE	    ; Set data pattern on Port E
	
	movlw 0x0B		    ; Clock two to low
	movwf PORTD
	
	movlw 0x0F		    ; Clock one to high
	movwf PORTD
	
clock_offRead
	movlw 0xFF		    ; Enable Port E input
	movwf TRISE, A	
	
	movlw  0x0D		    ; Move memory one OE low
	movwf PORTD
	
	movff PORTE,PORTC	    ; Show read data
	
	movlw  0x0F		    ; raise memory one OE
	movwf PORTD
	
	movlw  0x07		    ; lower memory two OE
	movwf PORTD
	
	movff PORTE,PORTJ	    ; Show read data
	
	movlw  0x0F		    ; raise memory two OE
	movwf PORTD

	bra increase

	
	end
	