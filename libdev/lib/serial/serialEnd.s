;-------------------------------------------------------------------------------
; serialEnd() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialEnd

    xref rxBufCnt
    xref rxBufRd
    xref rxBufWr
    xref txSize


;-------------------------------------------------------------------------------
; Private Constant Declarations

TC:                     equ 6       ; UART_SR: Transmission Complete
UART_SR:                equ $5230   ; UART Status Register
UART_DR:                equ $5231   ; UART Status Register
UART_CR2:               equ $5235   ; UART Control Register 2


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialEnd()
_serialEnd:
    ; disable all UART2 interrupts, but leave receiver and transmitter enabled
    mov UART_CR2,#$0C
seWait:
    ; wait for any outgoing byte to finish transmitting
    btjf UART_SR,#TC,seWait
    clr UART_CR2        ; disable UART
    clr txSize          ; clear buffer variables
    clr txSize+1
    clr rxBufCnt
    clr rxBufWr
    clr rxBufRd
    ld a,UART_DR        ; read any data that may have been received
    ret


;-------------------------------------------------------------------------------

    end
