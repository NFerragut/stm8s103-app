;-------------------------------------------------------------------------------
; uartRxIsr() interrupt service routine

    include "uartConfig.i"


;-------------------------------------------------------------------------------
; Declare external references

    xdef _uartRxIsr
    xdef rxBuf
    xdef rxBufCnt
    xdef rxBufWr


;-------------------------------------------------------------------------------
; Private Constant Declarations

RIEN:                   equ 5       ; UART_CR2: Receiver Interrupt ENable
RX_BUF_SZ:              equ (1 << RX_BUF_BITS)
RX_MASK:                equ (RX_BUF_SZ - 1)
UART_DR:                equ $5231   ; UART Data Register
UART_CR2:               equ $5235   ; UART Control Register 2


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

; _uartRxIsr() interrupt service routine
_uartRxIsr:
    ld a,rxBufCnt       ; if (rxBufCnt >= RX_BUF_SZ) goto uriDisable
    cp a,#RX_BUF_SZ
    jruge uriDisable
    clrw x              ; rxBuf[rxBufWr] = UART_DR
    ld a,rxBufWr
    ld xl,a
    ld a,UART_DR
    ld (rxBuf,x),a
    ld a,xl             ; rxBufWr = (rxBufWr + 1) & RX_MASK
    inc a
    and a,#RX_MASK
    ld rxBufWr,a
    inc rxBufCnt        ; rxBufCnt += 1
    iret
uriDisable:
    bres UART_CR2,#RIEN ; disable UART Rx interrupt
    iret


;-------------------------------------------------------------------------------

    end
