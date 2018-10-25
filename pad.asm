#include p18f87k22.inc
    
LCD_cnt_l   res 1   ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h   res 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms  res 1   ; reserve 1 byte for ms counter
LCD_tmp	    res 1   ; reserve 1 byte for temporary use
LCD_counter res 1   ; reserve 1 byte for counting through nessage
pad_row res 1
pad_column res 1
pad_final res 1

pad code

pad_setup
    bsf	    PADCFG1,RDPU,banked
    clrf    LATE
    movlw   0x0F
    movwf   TRISE, A
    movlw   .10
    call    LCD_delay_x4us
    movlw   0x00
    movwf   TRISD, A
    
pad_read
    movlw   0x0F
    movwf   TRISE, A
    movlw   .10
    call    LCD_delay_x4us
    movff   PORTE, pad_row
    movlw   b'00001111'		    
    cpfslt  pad_row			;if no button is pressed reads again
    bra	    pad_read
    
    movlw   b'00000111'		    
    cpfseq  pad_row			;if no button is pressed reads again
    bra	    second_row
    bra	    pad_column
    
second_row    
    movlw   b'00001011'		    
    cpfseq  pad_row			;if no button is pressed reads again
    bra	    third_row
    bra	    pad_column
    
third_row
    movlw   b'00001101'		    
    cpfseq  pad_row			;if no button is pressed reads again
    bra	    fourth_row
    bra	    pad_column
  
fourth_row
    movlw   b'00001110'		    
    cpfseq  pad_row			;if no button is pressed reads again
    bra	    pad_read
    
    
pad_column
    movlw   0xF0
    movwf   TRISE, A
    movlw   .10
    call    LCD_delay_x4us
    movff   PORTE, pad_column
    
    movlw   b'01110000'		    
    cpfseq  pad_column 			;if no button is pressed reads again
    bra	    second_column 
    bra	    determine_output
    
second_column    
    movlw   b'10110000'		    
    cpfseq  pad_column 			;if no button is pressed reads again
    bra	    third_column 
    bra	    determine_output
    
third_column 
    movlw   b'11010000'		    
    cpfseq  pad_column 			;if no button is pressed reads again
    bra	    fourth_column 
    bra	    determine_output
  
fourth_column 
    movlw   b'11100000'		    
    cpfseq  pad_column 			;if no button is pressed reads again
    bra	    determine_output
    
determine_output
    movff  pad_row,W
    addwf  pad_column,pad_final
    movff  pad_final, PORTD

    
LCD_delay_x4us		    ; delay given in chunks of 4 microsecond in W
	movwf	LCD_cnt_l   ; now need to multiply by 16
	swapf   LCD_cnt_l,F ; swap nibbles
	movlw	0x0f	    
	andwf	LCD_cnt_l,W ; move low nibble to W
	movwf	LCD_cnt_h   ; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	LCD_cnt_l,F ; keep high nibble in LCD_cnt_l
	call	LCD_delay
	return

LCD_delay			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1	decf 	LCD_cnt_l,F	; no carry when 0x00 -> 0xff
	subwfb 	LCD_cnt_h,F	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return