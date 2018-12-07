;-------------------------------------------------------------------------------
; millis() function
; Get the number of milliseconds since the last microcontroller reset.


;-------------------------------------------------------------------------------
; Declare external references

    xdef _millis

    xref c_lreg
    xref ms


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

    ; _millis() function
    ; return c_lreg = # of milliseconds since reset
_millis:
    push cc             ; Save interrupt enable flags
    sim                 ; Disable interrupts
    ldw x,ms            ; Copy milliseconds into long register
    ldw c_lreg,x
    ldw x,ms+2
    pop cc              ; Restore interrupt enable flags
    ldw c_lreg+2,x
    ret


;-------------------------------------------------------------------------------

    end
