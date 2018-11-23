;-------------------------------------------------------------------------------
; uart1RxPop() assembly function

    include "uart1Config.i"


;-------------------------------------------------------------------------------
; Declare external references

    xdef uart1RxPop

    xref rxBufCnt
    xref rxBufRd


;-------------------------------------------------------------------------------
; Private Constant Declarations

RIEN:                   equ 5       ; UART1_CR2: Receiver Interrupt ENable
RX_BUF_SZ:              equ (1 << RX_BUF_BITS)
RX_MASK:                equ (RX_BUF_SZ - 1)
UART1_CR2:              equ $5235


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; uart1RxPop() assembly function
; advance read pointer / discard data
; assumes data is available (rxBufCnt > 0)
; return A unchanged
; return X unchanged
; return CC.Z == 1 if that was the last byte
uart1RxPop:
    push a
    ld a,rxBufRd        ; rxBufRd = (rxBufRd + 1) & RX_MASK
    inc a
    and a,#RX_MASK
    ld rxBufRd,a
    dec rxBufCnt        ; rxBufCnt -= 1
    bset UART1_CR2,#RIEN; enable UART1 Rx Interrupt
    pop a
    ret


;-------------------------------------------------------------------------------

    end
