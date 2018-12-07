;-------------------------------------------------------------------------------
; getchar() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _getchar

    xref rxBufCnt
    xref uartRxByte


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _getchar() function
; blocking function to work with other existing library functions
; pulls data from the RX queue
; Return A = The UART received byte
_getchar:
    tnz rxBufCnt        ; wait for a received character
    jreq _getchar
    call uartRxByte     ; read next byte in RX queue
    ret


;-------------------------------------------------------------------------------

    end
