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

RXNE:                   equ 5       ; UART1_SR: read (RX) data register Not Empty
TC:                     equ 6       ; UART1_SR: Transmission Complete
TXE:                    equ 7       ; UART1_SR: transmit (TX) data register Empty
UART1_SR:               equ $5230   ; UART1 Status Register
UART1_DR:               equ $5231   ; UART1 Status Register
UART1_CR2:              equ $5235   ; UART1 Control Register 2


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialEnd()
_serialEnd:
    ; disable all UART2 interrupts, but leave receiver and transmitter enabled
    mov UART1_CR2,#$0C
seWait:
    ; wait for any outgoing byte to finish transmitting
    btjf UART1_SR,#TC,seWait
    clr UART1_CR2       ; disable UART1
    clr txSize          ; clear buffer variables
    clr txSize+1
    clr rxBufCnt
    clr rxBufWr
    clr rxBufRd
;seRead:
;    ld a,UART1_DR       ; set UART1_SR.RXNE = 0
;    btjt UART1_SR,#RXNE,seRead
    ret


;-------------------------------------------------------------------------------

    end
