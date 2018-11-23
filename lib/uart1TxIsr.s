;-------------------------------------------------------------------------------
; uart1TxIsr() interrupt service routine

    include "uart1Config.i"


;-------------------------------------------------------------------------------
; Declare external references

    xdef _uart1TxIsr

    xref uart1TxByte
    xref txSize


;-------------------------------------------------------------------------------
; Private Constant Declarations

TIEN:                   equ 7       ; UART1_CR2: Transmit Interrupt ENable
UART1_CR2:              equ $5235   ; UART1 Control Register 2


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _uart1TxIsr() interrupt service routine
_uart1TxIsr:
    ldw x,txSize        ; if (txSize == 0) goto utiDisable
    jreq utiDisable
    call uart1TxByte    ; send next byte
    jrne utiDone        ; if (txSize > 0) goto utiDone
utiDisable:
    bres UART1_CR2,#TIEN; disable UART1 Tx interrupt
utiDone:
    iret


;-------------------------------------------------------------------------------

    end
