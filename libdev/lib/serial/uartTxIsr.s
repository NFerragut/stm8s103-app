;-------------------------------------------------------------------------------
; uartTxIsr() interrupt service routine

    include "uartConfig.i"


;-------------------------------------------------------------------------------
; Declare external references

    xdef _uartTxIsr

    xref uartTxByte
    xref txSize


;-------------------------------------------------------------------------------
; Private Constant Declarations

TIEN:                   equ 7       ; UART_CR2: Transmit Interrupt ENable
UART_CR2:               equ $5235   ; UART Control Register 2


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _uartTxIsr() interrupt service routine
_uartTxIsr:
    ldw x,txSize        ; if (txSize == 0) goto utiDisable
    jreq utiDisable
    call uartTxByte     ; send next byte
    jrne utiDone        ; if (txSize > 0) goto utiDone
utiDisable:
    bres UART_CR2,#TIEN ; disable UART Tx interrupt
utiDone:
    iret


;-------------------------------------------------------------------------------

    end
