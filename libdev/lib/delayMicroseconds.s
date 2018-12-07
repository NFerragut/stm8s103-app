;-------------------------------------------------------------------------------
; delayMicroseconds() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _delayMicroseconds


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _delayMicroseconds() function
; X = # of microseconds to delay
_delayMicroseconds:
    tnzw x              ; if (microseconds left == 0) return
    jreq dmDone
    decw x              ; first microsecond is call overhead
    jreq dmDone
dmNext:
    tnzw x              ; wait 1 microsecond
    callr dmDone
    nop
    tnzw x
    decw x              ; decrement microsecond counter
    jrne dmNext         ; if (microseconds left == 0) return
dmDone:
    ret


;-------------------------------------------------------------------------------

    end
