;-------------------------------------------------------------------------------
; serialWrite() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialWrite


;-------------------------------------------------------------------------------
; Private Constant Declarations

TC:                     equ 6       ; UART_SR: Transmission Complete
TEN:                    equ 3       ; UART_CR2: Transmitter ENable
UART_SR:                equ $5230   ; UART Status Register
UART_DR:                equ $5231   ; UART Data Register
UART_CR2:               equ $5235   ; UART Control Register 2


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialWrite() function
; A = byte to be written to UART
; return X = 1
_serialWrite:
    ; wait for all queued serial data to be sent
    btjf UART_SR,#TC,_serialWrite
    ld UART_DR,a        ; send the byte
    bset UART_CR2,#TEN  ; enable transmitter in case this is the first tx byte
    clrw x              ; return 1
    incw x
    ret


;-------------------------------------------------------------------------------

    end
