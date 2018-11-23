;-------------------------------------------------------------------------------
; uart1RxPeek() assembly function


;-------------------------------------------------------------------------------
; Declare external references

    xdef uart1RxPeek

    xref rxBuf
    xref rxBufRd


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; uart1RxPeek() assembly function
; assumes data is available (rxBufCnt > 0)
; return A = The next byte in the UART1 Rx buffer
; return X unchanged
uart1RxPeek:
    pushw x
    clrw x              ; X = rxBufRd
    ld a,rxBufRd
    ld xl,a
    ld a,(rxBuf,x)      ; A = rxBuf[rxBufRd]
    popw x
    ret


;-------------------------------------------------------------------------------

    end
