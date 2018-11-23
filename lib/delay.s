;-------------------------------------------------------------------------------
; delay() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _delay

    xref _millis
    xref c_lcmp
    xref c_lsub
    xref ms


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _delay() function
; sp3.l = # of milliseconds to delay
_delay:
    subw sp,#4
    sim                 ; start = millis()
    ldw x,ms
    ldw (1,sp),x
    ldw x,ms+2
    rim
    ldw (3,sp),x
dWait:
    call _millis        ; c_lreg = millis() - start
    ldw x,sp
    incw x
    call c_lsub
    ldw x,sp            ; if (c_lreg < delay) goto dWait
    addw x,#7
    call c_lcmp
    jrult dWait
dDone:
    addw sp,#4
    ret


;-------------------------------------------------------------------------------

    end
