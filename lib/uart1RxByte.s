;-------------------------------------------------------------------------------
; uart1RxByte() assembly function

    include "uart1Config.i"


;-------------------------------------------------------------------------------
; Declare external references

    xdef uart1RxByte
    xdef rxBufRd

    xref rxBuf
    xref rxBufCnt


;-------------------------------------------------------------------------------
; Private Constant Declarations

RIEN:                   equ 5       ; UART1_CR2: Receiver Interrupt ENable
RX_BUF_SZ:              equ (1 << RX_BUF_BITS)
RX_MASK:                equ (RX_BUF_SZ - 1)
UART1_CR2:              equ $5235


;-------------------------------------------------------------------------------
; Private Variable Definitions

    switch .bsct

rxBufRd:                ds.b 1


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; uart1RxByte() assembly function
; assumes data is available (rxBufCnt > 0)
; return X unchanged
; return A = The next byte in the UART1 Rx buffer
; return CC.Z == 1 if that was the last byte
uart1RxByte:
    pushw x
    clrw x              ; X = rxBufRd
    ld a,rxBufRd
    ld xl,a
    inc a               ; rxBufRd = (rxBufRd + 1) & RX_MASK
    and a,#RX_MASK
    ld rxBufRd,a
    ld a,(rxBuf,x)      ; A = rxBuf[rxBufRd]
    dec rxBufCnt
    bset UART1_CR2,#RIEN; enable UART1 Rx Interrupt
    popw x
    ret


;-------------------------------------------------------------------------------

    end
