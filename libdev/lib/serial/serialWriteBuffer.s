;-------------------------------------------------------------------------------
; serialWriteBuffer() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialWriteBuffer

    xref uartTxByte
    xref txAddr
    xref txSize


;-------------------------------------------------------------------------------
; Private Constant Declarations

TC:                     equ 6       ; UART_SR: Transmission Complete
TIEN:                   equ 7       ; UART_CR2: Transmit Interrupt ENable
UART_SR:                equ $5230   ; UART Status Register
UART_CR2:               equ $5235   ; UART Control Register 2


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialWriteBuffer() function
; X = Address of data to write to UART
; SP3 = Length of data to write to UART
; return X = # of bytes written to UART
_serialWriteBuffer:
    ldw y,(3,sp)        ; Y = # of bytes to send
    jreq swbReturn0
swbFlush:
    ; wait for all previously queued serial data to be sent
    btjf UART_SR,#TC,swbFlush
    ldw txAddr,x        ; txAddr = buffer
    ldw txSize,y        ; txSize = length
    call uartTxByte     ; send the first byte
    jreq swbReturn1     ; if (more bytes) enable UART Tx Interrupt
    bset UART_CR2,#TIEN
swbReturn1:
    clrw x              ; return 1
    incw x
    ret
swbReturn0:
    clrw x              ; return 0
    ret


;-------------------------------------------------------------------------------

    end
