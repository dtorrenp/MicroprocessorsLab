#include p18f87k22.inc
    
    global Pad_Setup, Pad_Read
    extern  LCD_clear
    
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
    movlw   0x00
    movwf   TRISH, A
    return
    
Pad_Read
    movlw   0x0F
    movwf   TRISE, A
    movlw   .10
    call    PAD_delay_x4us
    movff   PORTE, pad_row
    movlw   0xF0
    movwf   TRISE, A
    movlw   .10
    call    PAD_delay_x4us
    movff   PORTE, pad_column
    movf    pad_row,W
    iorwf   pad_column, W
    movwf   pad_final
    movff   pad_final, PORTD
    

    movlw   b'11111111'		    
    cpfseq  pad_final			;if no button is pressed reads again
    bra	    oneRoneC
    bra	    Pad_Read

oneRoneC
    movlw   b'01110111'		    
    cpfseq  pad_final			;first row first column
    bra	    twoRoneC
    call    LCD_clear
    retlw   0x20
    
twoRoneC
    movlw   b'10110111'		    
    cpfseq  pad_final			;second row first column
    bra	    threeRoneC
    retlw   0x44
   
threeRoneC
    movlw   b'11010111'		    
    cpfseq  pad_final			;third row first column
    bra	    fourRoneC
    retlw   0x45
    
fourRoneC
    movlw   b'11100111'		    
    cpfseq  pad_final			;fourth row first column
    bra	    oneRtwoC
    retlw   0x46
    
oneRtwoC
    movlw   b'01111011'		    
    cpfseq  pad_final			;first row second column
    bra	    twoRtwoC
    retlw   0x42
    
twoRtwoC
    movlw   b'10111011'			;second row second column
    cpfseq  pad_final			
    bra	    threeRtwoC
    retlw   0x39
    
threeRtwoC
    movlw   b'11011011'			;third row second column
    cpfseq  pad_final			
    bra	    fourRtwoC
    retlw   0x36
    
fourRtwoC
    movlw   b'11101011'		    
    cpfseq  pad_final			;fourth row second column etc
    bra	    oneRthreeC
    retlw   0x33
    
oneRthreeC
    movlw   b'01111101'		    
    cpfseq  pad_final			
    bra	    twoRthreeC
    retlw   0x30
    
twoRthreeC
    movlw   b'10111101'		    
    cpfseq  pad_final			
    bra	    threeRthreeC
    retlw   0x38
    
threeRthreeC
    movlw   b'11011101'		    
    cpfseq  pad_final			
    bra	    fourRthreeC
    retlw   0x35
    
fourRthreeC
    movlw   b'11101101'		    
    cpfseq  pad_final			
    bra	    oneRfourC
    retlw   0x32
    
oneRfourC
    movlw   b'01111110'		    
    cpfseq  pad_final			
    bra	    twoRfourC
    retlw   0x41
    
twoRfourC
    movlw   b'10111110'		    
    cpfseq  pad_final			
    bra	    threeRfourC
    retlw   0x37
    
threeRfourC
    movlw   b'11011110'		    
    cpfseq  pad_final			
    bra	    fourRfourC
    retlw   0x34
    
fourRfourC
    movlw   b'11101110'		    
    cpfseq  pad_final			
    return  0x20
    retlw   0x31
    
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