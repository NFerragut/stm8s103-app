;-------------------------------------------------------------------------------
; serialPeek() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialPeek

    xref rxBufCnt
    xref uartRxPeek


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialPeek() function
; Return X = The next byte in the UART Rx buffer
; Return X = -1 if there is no data in the UART Rx buffer
_serialPeek:
    clrw x              ; if (no received data) return -1
    ld a,rxBufCnt
    jrne spByte
    decw x
    ret
spByte:
    call uartRxPeek     ; A = next byte in serial RX queue
    ld xl,a             ; X = A
    ret


;-------------------------------------------------------------------------------

    end
