;-------------------------------------------------------------------------------
; uart1RxIsr() interrupt service routine

    include "uart1Config.i"


;-------------------------------------------------------------------------------
; Declare external references

    xdef _uart1RxIsr
    xdef rxBuf
    xdef rxBufCnt
    xdef rxBufWr


;-------------------------------------------------------------------------------
; Private Constant Declarations

RIEN:                   equ 5       ; UART1_CR2: Receiver Interrupt ENable
RX_BUF_SZ:              equ (1 << RX_BUF_BITS)
RX_MASK:                equ (RX_BUF_SZ - 1)
UART1_DR:               equ $5231
UART1_CR2:              equ $5235


;-------------------------------------------------------------------------------
; Private Variable Definitions

    switch .bsct

rxBufCnt:               ds.b 1
rxBufWr:                ds.b 1

    switch .ubsct

rxBuf:                  ds.b RX_BUF_SZ


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _uart1RxIsr() interrupt service routine
_uart1RxIsr:
    ld a,rxBufCnt       ; if (rxBufCnt >= RX_BUF_SZ) goto uriDisable
    cp a,#RX_BUF_SZ
    jruge uriDisable
    clrw x              ; rxBuf[rxBufWr] = UART1_DR
    ld a,rxBufWr
    ld xl,a
    ld a,UART1_DR
    ld (rxBuf,x),a
    ld a,xl             ; rxBufWr = (rxBufWr + 1) & RX_MASK
    inc a
    and a,#RX_MASK
    ld rxBufWr,a
    inc rxBufCnt        ; rxBufCnt += 1
    iret
uriDisable:
    bres UART1_CR2,#RIEN; Disable UART1 Rx Interrupt
    iret


;-------------------------------------------------------------------------------

    end
