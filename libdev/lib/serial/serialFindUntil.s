;-------------------------------------------------------------------------------
; serialFindUntil() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialFindUntil

    xref rxBufCnt
    xref serialTimerCheck
    xref serialTimerStart
    xref uartRxByte


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialFindUntil() function
; X = address of target string to find in the serial Rx stream
; SP3 = address of terminator string to stop search
_serialFindUntil:
    pushw x             ; SP1=START, SP5=TARGET, SP9=END
    subw sp,#4
    call serialTimerStart   ; START = ms
    ldw y,(9,sp)
sfuNext:
    tnz rxBufCnt        ; if (no bytes in RX queue) goto sfWait
    jreq sfuWait
    call uartRxByte     ; read the next byte from the serial RX queue
    cp a,(x)            ; if (byte does not match target) goto sfuNoFind
    jrne sfuNoFind
    incw x              ; advance to next target character
    tnz (x)             ; if (not end of target) goto sfuCheckEnd
    jrne sfuCheckEnd
    clr a               ; found target -- return true
    inc a
    jra sfuDone
sfuNoFind:
    ldw x,(5,sp)        ; restart looking for target
sfuCheckEnd:
    exgw x,y            ; switch to looking for terminator
    cp a,(x)            ; if (byte does not match term) goto sfuNoEnd
    jrne sfuNoEnd
    incw x              ; advance to next terminator character
    tnz (x)             ; if (not end of terminator) goto sfuEnding
    jrne sfuEnding
    clr a               ; found terminator -- return false
    jra sfuDone
sfuNoEnd:
    ldw x,(9,sp)        ; restart looking for terminator
sfuEnding:
    exgw x,y            ; switch back to looking for target
sfuWait:
    call serialTimerCheck   ; if (no timeout) goto sfNext
    jrult sfuNext
    clr a               ; timeout -- return false
sfuDone:
    addw sp,#6
    ret


;-------------------------------------------------------------------------------

    end
