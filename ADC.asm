#include p18f87k22.inc

    global  ADC_Setup, ADC_Read, eight_bit_by_sixteen,add_check_setup
    
acs0	udata_acs   ; reserve data space in access ram
input_one_lower	    res 1   ; reserve one byte 
input_one_upper	    res 1   ; reserve one byte 
input_two_lower	    res 1   ; reserve one byte
input_two_upper	    res 1   ; reserve one byte 
result_lower	    res 1
result_mid		    res 1
result_upper	    res 1
;acs_ovr access_ovr
lowest_low res 1
highest_low res 1
lowest_high res 1
highest_high res 1
 
ADC    code
    
add_check_setup
    movlw   0x00
    movwf   PORTH
    movwf   PORTD
    movwf   PORTJ
    
    movlw	0xF2
    movwf	input_two_lower
    movlw	0x35
    movwf	input_one_lower
    movlw	0xA5
    movwf	input_one_upper
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
    
    movff   result_upper, PORTH
    movff   result_mid, PORTD
    movff   result_lower, PORTJ
    return
;sixteen_bit_by_sixteen
    
;eight_bit_by_twentyfour
    
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