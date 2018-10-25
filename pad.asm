#include p18f87k22.inc
    
    global Pad_Setup, Pad_Read
    
acs0    udata_acs   ; named variables in access ram
PAD_cnt_l   res 1   ; reserve 1 byte for variable PAD_cnt_l
PAD_cnt_h   res 1   ; reserve 1 byte for variable PAD_cnt_h
PAD_cnt_ms  res 1   ; reserve 1 byte for ms counter
PAD_tmp	    res 1   ; reserve 1 byte for temporary use
PAD_counter res 1   ; reserve 1 byte for counting through nessage
pad_row res 1
pad_column res 1
pad_final res 1

pad	    code

Pad_Setup
    banksel PADCFG1
    bsf	    PADCFG1,REPU, BANKED
    clrf    LATE
    movlw   0x0F
    movwf   TRISE, A
    movlw   .10
    call    PAD_delay_x4us
    movlw   0x00
    movwf   TRISD, A
    return
    
Pad_Read
    movlw   0x0F
    movwf   TRISE, A
    movlw   .10
    call    PAD_delay_x4us
    movff   PORTE, pad_row
    movlw   b'00001111'		    
    cpfslt  pad_row			;if no button is pressed reads again
    retlw   0xFF
    
    movlw   b'00000111'		    
    cpfseq  pad_row			;if no button is pressed reads again
    bra	    second_row
    bra	    Pad_column
    
second_row    
    movlw   b'00001011'		    
    cpfseq  pad_row			;if no button is pressed reads again
    bra	    third_row
    bra	    Pad_column
    
third_row
    movlw   b'00001101'		    
    cpfseq  pad_row			;if no button is pressed reads again
    bra	    fourth_row
    bra	    Pad_column
  
fourth_row
    movlw   b'00001110'		    
    cpfseq  pad_row			;if no button is pressed reads again
    retlw   0xFF
    
    
Pad_column
    movlw   0xF0
    movwf   TRISE, A
    movlw   .10
    call    PAD_delay_x4us
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
    retlw   0xFF
    bra	    determine_output
    
determine_output
    movf    pad_row,W
    addwf   pad_column, W
    movwf   pad_final
    movff   pad_final, PORTD
    return

    
PAD_delay_x4us			; delay given in chunks of 4 microsecond in W
    movwf	PAD_cnt_l	; now need to multiply by 16
    swapf   PAD_cnt_l,F		; swap nibbles
    movlw	0x0f	    
    andwf	PAD_cnt_l,W	; move low nibble to W
    movwf	PAD_cnt_h	; then to PAD_cnt_h
    movlw	0xf0	    
    andwf	PAD_cnt_l,F	; keep high nibble in PAD_cnt_l
    call	PAD_delay
    return

PAD_delay			; delay routine	4 instruction loop == 250ns	    
    movlw 	0x00		; W=0
PADlp1	
    decf 	PAD_cnt_l,F	; no carry when 0x00 -> 0xff
    subwfb 	PAD_cnt_h,F	; no carry when 0x00 -> 0xff
    bc 	PADlp1			; carry, then loop again
    return			; carry reset so return
    
    end