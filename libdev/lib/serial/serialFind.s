;-------------------------------------------------------------------------------
; serialFind() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialFind

    xref rxBufCnt
    xref serialTimerCheck
    xref serialTimerStart
    xref uartRxByte


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialFind() function
; X = address of target string to find in the serial Rx stream
_serialFind:
    pushw x             ; SP1=START, SP5=TARGET
    subw sp,#4
    call serialTimerStart   ; START = ms
sfNext:
    tnz rxBufCnt        ; if (no bytes in RX queue) goto sfWait
    jreq sfWait
    call uartRxByte     ; read the next byte from the serial RX queue
    xor a,(x)           ; if (byte does not match target) goto sfNoFind
    jrne sfNoFind
    incw x              ; advance to next target character
    tnz (x)             ; if (not end of target) goto sfWait
    jrne sfWait
    inc a               ; found target -- return true
    jra sfDone
sfNoFind:
    ldw x,(5,sp)        ; restart looking for target
sfWait:
    call serialTimerCheck   ; if (no timeout) goto sfNext
    jrult sfNext
    clr a               ; timeout -- return false
sfDone:
    addw sp,#6
    ret


;-------------------------------------------------------------------------------

    end
