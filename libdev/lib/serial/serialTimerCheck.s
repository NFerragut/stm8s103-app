;-------------------------------------------------------------------------------
; serialTimerCheck() assembly function


;-------------------------------------------------------------------------------
; Declare external references

    xdef serialTimerCheck

    xref ms
    xref rxTimeout


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; serialTimerCheck() assembly function
; SP3 = start time to use
; returns c_lreg unchanged
; returns X unchanged
; returns CC based on comparison of (ms - start) and (rxTimeout)
serialTimerCheck:
    pushw x             ; SP1=TIME, SP5=X, SP9=START
    subw sp,#4
    push cc             ; Save interrupt enable flags
    sim                 ; Disable interrupts
    ldw x,ms            ; Copy milliseconds into TIME
    ldw (1+1,sp),x
    ldw x,ms+2
    pop cc              ; Restore interrupt enable flags
    ldw (3,sp),x
    ld a,(4,sp)         ; TIME = TIME - START
    sub a,(12,sp)
    ld (4,sp),a
    ld a,(3,sp)
    sbc a,(11,sp)
    ld (3,sp),a
    ld a,(2,sp)
    sbc a,(10,sp)
    ld (2,sp),a
    ld a,(1,sp)
    sbc a,(9,sp)
    cp a,rxTimeout      ; compare TIME and rxTimeout
    jrne stcDone
    ld a,(2,sp)
    cp a,rxTimeout+1
    jrne stcDone
    ld a,(3,sp)
    cp a,rxTimeout+2
    jrne stcDone
    ld a,(4,sp)
    cp a,rxTimeout+3
stcDone:
    addw sp,#4          ; restore X register
    popw x
    ret


;-------------------------------------------------------------------------------

    end
