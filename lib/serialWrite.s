;-------------------------------------------------------------------------------
; serialWrite() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialWrite


;-------------------------------------------------------------------------------
; Private Constant Declarations

TC:                     equ 6       ; UART1_SR: Transmission Complete
TEN:                    equ 3       ; UART1_CR2: Transmitter ENable
UART1_SR:               equ $5230   ; UART1 Status Register
UART1_DR:               equ $5231   ; UART1 Data Register
UART1_CR2:              equ $5235   ; UART1 Control Register 2


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialWrite() function
; A = byte to be written to UART1
; return X = 1
_serialWrite:
    ; wait for all queued serial data to be sent
    btjf UART1_SR,#TC,_serialWrite
    ld UART1_DR,a       ; send the byte
    bset UART1_CR2,#TEN ; enable transmitter in case this is the first tx byte
    clrw x              ; return 1
    incw x
    ret


;-------------------------------------------------------------------------------

    end
