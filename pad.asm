#include p18f87k22.inc
    
LCD_cnt_l   res 1   ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h   res 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms  res 1   ; reserve 1 byte for ms counter
LCD_tmp	    res 1   ; reserve 1 byte for temporary use
LCD_counter res 1   ; reserve 1 byte for counting through nessage
pad_row res 1
pad_column res 1

pad code

pad_setup
    bsf	    PADCFG1,RDPU,banked
    clrf    LATE
    movlw   0x0F
    movwf   TRISE, A
    movlw   .10
    call    LCD_delay_x4us
    
pad_read
    movlw   0x0F
    movwf   TRISE, A
    movlw   .10
    call    LCD_delay_x4us
    movwf   PORTE, pad_row
    
    movlw   0xF0
    movwf   TRISE, A
    movlw   .10
    call    LCD_delay_x4us
    movwf   PORTE, pad_column
    
    iorwf   
    
    
    
    
    
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