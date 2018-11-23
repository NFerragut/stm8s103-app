;-------------------------------------------------------------------------------
; serialTimerCheck() assembly function


;-------------------------------------------------------------------------------
; Declare external references

    xdef serialTimerCheck

    xref _millis
    xref c_lcmp
    xref c_lsub
    xref ms
    xref rxTimeout


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; serialTimerCheck() assembly function
; SP3 = start time to use
; returns X unchanged
; returns CC based on comparison of (ms - start) and (rxTimeout)
serialTimerCheck:
    pushw x             ; SP1=X, SP5=START
    call _millis        ; c_lreg = ms - start
    ldw x,sp
    addw x,#5
    call c_lsub
    ldw x,#rxTimeout    ; compare c_lreg with rxTimeout
    call c_lcmp
    popw x              ; restore X register
    ret


;-------------------------------------------------------------------------------

    end
