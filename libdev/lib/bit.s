;-------------------------------------------------------------------------------
; bit() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _bit

    xref _bitSet
    xref c_lreg


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _bit()
; A = bit number
; Returns c_lreg = bit mask
_bit:
    clrw x              ; c_lreg = 0
    ldw c_lreg,x
    ldw c_lreg+2,x
    ldw x,#c_lreg
    push a              ; call bitSet(X, A)
    call _bitSet
    pop a
    ret


;-------------------------------------------------------------------------------

    end
