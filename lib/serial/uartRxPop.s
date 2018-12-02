;-------------------------------------------------------------------------------
; uartRxPop() assembly function

    include "uartConfig.i"


;-------------------------------------------------------------------------------
; Declare external references

    xdef uartRxPop

    xref rxBufCnt
    xref rxBufRd


;-------------------------------------------------------------------------------
; Private Constant Declarations

RIEN:                   equ 5       ; UART_CR2: Receiver Interrupt ENable
RX_BUF_SZ:              equ (1 << RX_BUF_BITS)
RX_MASK:                equ (RX_BUF_SZ - 1)
UART_CR2:               equ $5235   ; UART Control Register 2


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; uartRxPop() assembly function
; advance read pointer / discard data
; assumes data is available (rxBufCnt > 0)
; return A unchanged
; return X unchanged
; return CC.Z == 1 if that was the last byte
uartRxPop:
    push a
    ld a,rxBufRd        ; rxBufRd = (rxBufRd + 1) & RX_MASK
    inc a
    and a,#RX_MASK
    ld rxBufRd,a
    dec rxBufCnt        ; rxBufCnt -= 1
    bset UART_CR2,#RIEN ; enable UART Rx Interrupt
    pop a
    ret


;-------------------------------------------------------------------------------

    end
