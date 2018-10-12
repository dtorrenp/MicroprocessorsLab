#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	org 0x100		    ; Main code starts here at address 0x100

	; ******* Programme FLASH read Setup Code ****
setup	bcf EECON1, CFGS	    ; point to Flash program memory
	bsf EECON1, EEPGD	    ; access Flash program memory
	goto start
	
	; ******* My data and where to put it in RAM *
myTable data "This is just some data"
	constant myArray=0x400	    ; Address in RAM for data
	constant counter=0x10	    ; Address of counter variable
	
	
initial movlw 0x00
	movwf 0x03
	movlw 0xFF
	movwf 0x07
	lfsr FSR0, 0x004
	lfsr FSR1, 0x004

write_loop   movff 0x03, FSR0
	incf  0x03
	incf FSR0
	decfsz 0x07
	bra write_loop
		
read    movff FSR1, 0x05
	incf FSR1
	cpfseq FSR
	goto 0x0
	
	
	end


