;-------------------------------------------------------------------------------
; noTone() function
; Stops the generation of a square wave


;-------------------------------------------------------------------------------
; Declare external references

    xdef _noTone

    xref tonePin


;-------------------------------------------------------------------------------
; Private Constant Declarations

TIM1_IER:               equ $5254   ; Address of TIM1 Interrupt Enable Register


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _noTone() function
; A = pin related to the current tone generation
_noTone:
    btjf TIM1_IER,#0,ntDone
    xor a,tonePin       ; if (tone is disabled) return
    and a,#$7f
    jrne ntDone         ; if (pin is not active tone pin) return
    bres TIM1_IER,#0    ; disable the tone interrupt
ntDone:
    ret


;-------------------------------------------------------------------------------

    end
