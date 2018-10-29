#include p18f87k22.inc

    global  ADC_Setup, ADC_Read, eight_bit_by_sixteen,add_check_setup,sixteen_bit_by_sixteen,eight_bit_by_twentyfour
    
acs0	udata_acs   ; reserve data space in access ram
input_one_lower	    res 1   ; reserve one byte 
input_one_upper	    res 1   ; reserve one byte 
input_two_lower	    res 1   ; reserve one byte	    
input_two_upper	    res 1   ; reserve one byte 
	    
input_one_super    res 1   ; reserve one byte
input_two_super   res 1   ; reserve one byte
   
result_lower	    res 1
result_mid	    res 1
result_upper	    res 1
result_super	    res 1

ADC    code
    
add_check_setup
    movlw   0x00
    movwf   PORTD
    
    movlw	0xFF
    movwf	input_two_lower
    movlw	0xFF
    movwf	input_two_upper
    
    
    movlw	0xFF
    movwf	input_one_lower
    movlw	0xFF
    movwf	input_one_upper
    movlw	0xFF
    movwf	input_one_super
    return
    
eight_bit_by_sixteen
    movf  input_one_lower,W
    mulwf input_two_lower
    movff PRODL,result_lower
    movff PRODH, result_mid
    
    movf  input_one_upper,W
    mulwf input_two_lower
    movf PRODL,W
    addwf   result_mid,f
    
    movff PRODH, result_upper
    movlw 0x00
    addwfc result_upper,f
    
    movff   result_super, PORTD
    movff   result_upper, PORTD
    movff   result_mid, PORTD
    movff   result_lower, PORTD
    
    return
    
sixteen_bit_by_sixteen
    movf  input_one_lower,W	;moving lower bit one into w
    mulwf input_two_lower	;multiplying lower bytes of both
    movff PRODL,result_lower	;moving lowest byte result into file
    movff PRODH, result_mid	;moving 2nd byte into file
    
    movf  input_one_upper,W	;moving upper byte one into w
    mulwf input_two_lower	;multiply with lower byte two
    movf PRODL,W		;movwe lower result into w
    addwf   result_mid,f	;add lower result byte to 2nd storeed result byte
    movff PRODH, result_upper	;move 3rd byte result into file
    movlw 0x00			
    addwfc result_upper,f	;add any carry bit to 3rd byte result
    
    movf  input_one_upper,W
    mulwf input_two_upper
    movff   PRODH, result_super
    movf   PRODL,W
    addwf   result_upper,f
    movlw 0x00
    addwfc result_super,f
    
    movf  input_one_lower,W 	
    mulwf input_two_upper
    movf   PRODL,W
    addwf   result_mid,f
    movlw 0x00
    addwfc result_upper,f
    movf   PRODH,W
    addwf   result_upper,f
    movlw 0x00
    addwfc result_super,f
    
    movff   result_super, PORTD
    movff   result_upper, PORTD
    movff   result_mid, PORTD
    movff   result_lower, PORTD
    
    return
    
eight_bit_by_twentyfour
    
    movf  input_one_lower,W
    mulwf input_two_lower
    movff PRODL,result_lower
    movff PRODH, result_mid
    
    movf  input_one_upper,W
    mulwf input_two_lower
    movf PRODL,W
    addwf   result_mid,f
    movff PRODH, result_upper
    movlw 0x00
    addwfc result_upper,f
    
    movf  input_one_super,W
    mulwf input_two_lower
    movf PRODL,W
    addwf   result_upper,f
    movff PRODH,result_super
    movlw 0x00
    addwfc result_super,f
    
    movff   result_super, PORTD
    movff   result_upper, PORTD
    movff   result_mid, PORTD
    movff   result_lower, PORTD
    
    return
    
ADC_Setup
    bsf	    TRISA,RA0	    ; use pin A0(==AN0) for input
    bsf	    ANCON0,ANSEL0   ; set A0 to analog
    movlw   0x01	    ; select AN0 for measurement
    movwf   ADCON0	    ; and turn ADC on
    movlw   0x30	    ; Select 4.096V positive reference
    movwf   ADCON1	    ; 0V for -ve reference and -ve input
    movlw   0xF6	    ; Right justified output
    movwf   ADCON2	    ; Fosc/64 clock and acquisition times
    return

ADC_Read
    bsf	    ADCON0,GO	    ; Start conversion
adc_loop
    btfsc   ADCON0,GO	    ; check to see if finished
    bra	    adc_loop
    return



    end