;-------------------------------------------------------------------------------
; micros() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _micros

    xref c_lreg
    xref convertToMicros
    xref getMicroTime


;-------------------------------------------------------------------------------
; Private Constant Declarations

TIM4_CNTR:              equ $5346   ; TIM4 Counter


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

    ; _micros() function
    ; return c_lreg = # of microseconds since reset
_micros:
    ldw x,#c_lreg
    call getMicroTime
    jp convertToMicros


;-------------------------------------------------------------------------------

    end
