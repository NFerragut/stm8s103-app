;-------------------------------------------------------------------------------
; uartRxPeek() assembly function


;-------------------------------------------------------------------------------
; Declare external references

    xdef uartRxPeek

    xref rxBuf
    xref rxBufRd


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; uartRxPeek() assembly function
; assumes data is available (rxBufCnt > 0)
; return A = The next byte in the UART Rx buffer
; return X unchanged
uartRxPeek:
    pushw x
    clrw x              ; X = rxBufRd
    ld a,rxBufRd
    ld xl,a
    ld a,(rxBuf,x)      ; A = rxBuf[rxBufRd]
    popw x
    ret


;-------------------------------------------------------------------------------

    end
