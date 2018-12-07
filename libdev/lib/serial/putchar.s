;-------------------------------------------------------------------------------
; putchar() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _putchar


;-------------------------------------------------------------------------------
; Private Constant Declarations

REN:                    equ 2       ; UART_CR2: Transmitter ENable
TC:                     equ 6       ; UART_SR: Transmission Complete
TEN:                    equ 3       ; UART_CR2: Transmitter ENable
UART_SR:                equ $5230   ; UART Status Register
UART_DR:                equ $5231   ; UART Data Register
UART_CR2:               equ $5235   ; UART Control Register 2


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _putchar() function
; blocking function to work with other existing library functions
; A = byte to be written to UART
; return X = byte that was written or -1 if the UART is not configured
_putchar:
    clrw x              ; if (UART not configured) return -1
    btjf UART_CR2,#REN,pcEof
pcWait:
    ; wait for all queued serial data to be sent
    btjf UART_SR,#TC,pcWait
    ld UART_DR,a        ; send the byte
    bset UART_CR2,#TEN  ; enable transmitter in case this is the first tx byte
    ld xl,a
    ret
pcEof:
    decw x
    ret


;-------------------------------------------------------------------------------

    end
