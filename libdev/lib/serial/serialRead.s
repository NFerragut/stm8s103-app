;-------------------------------------------------------------------------------
; serialRead() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialRead

    xref rxBufCnt
    xref uartRxByte


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialRead() function
; Return X = The next byte in the UART Rx buffer
; Return X = -1 if there is no data in the UART Rx buffer
_serialRead:
    clrw x              ; if (no received data) return -1
    ld a,rxBufCnt
    jrne srByte
    decw x
    ret
srByte:
    call uartRxByte     ; A = next byte in serial RX queue
    ld xl,a             ; X = A
    ret


;-------------------------------------------------------------------------------

    end
