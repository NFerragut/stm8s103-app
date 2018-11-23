;-------------------------------------------------------------------------------
; serialWriteBuffer() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialWriteBuffer

    xref uart1TxByte
    xref txAddr
    xref txSize


;-------------------------------------------------------------------------------
; Private Constant Declarations

TC:                     equ 6       ; UART1_SR: Transmission Complete
TIEN:                   equ 7       ; UART1_CR2: Transmit Interrupt ENable
UART1_SR:               equ $5230   ; UART1 Status Register
UART1_CR2:              equ $5235   ; UART1 Control Register 2


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialWriteBuffer() function
; X = Address of data to write to UART1
; SP3 = Length of data to write to UART1
; return X = # of bytes written to UART1
_serialWriteBuffer:
    ldw y,(3,sp)        ; Y = # of bytes to send
    jreq swbReturn0
swbFlush:
    ; wait for all previously queued serial data to be sent
    btjf UART1_SR,#TC,swbFlush
    ldw txAddr,x        ; txAddr = buffer
    ldw txSize,y        ; txSize = length
    call uart1TxByte    ; send the first byte
    jreq swbReturn1     ; if (more bytes) enable UART1 Tx Interrupt
    bset UART1_CR2,#TIEN
swbReturn1:
    clrw x              ; return 1
    incw x
    ret
swbReturn0:
    clrw x              ; return 0
    ret


;-------------------------------------------------------------------------------

    end
