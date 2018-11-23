;-------------------------------------------------------------------------------
; toneIsr() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _toneIsr
    xdef tonePinMask
    xdef tonePort



;-------------------------------------------------------------------------------
; Private Constant Declarations

TIM1_SR1:               equ $5255   ; Address of TIM1 Status Register 1


;-------------------------------------------------------------------------------
; Private variable Definitions

    switch .bsct

tonePinMask:            ds.b 1
tonePort:               ds.w 1


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _toneIsr() interrupt service routine
_toneIsr:
    ldw x,tonePort      ; toggle port pin for the tone
    ld a,(x)
    xor a,tonePinMask
    ld (x),a
    bres TIM1_SR1,#0
    iret


;-------------------------------------------------------------------------------

    end
