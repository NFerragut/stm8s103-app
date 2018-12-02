;-------------------------------------------------------------------------------
; serialFlush() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialFlush


;-------------------------------------------------------------------------------
; Private Constant Declarations

TC:                     equ 6       ; UART_SR: Transmission Complete
UART_SR:                equ $5230   ; UART Status Register


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialFlush() function
_serialFlush:
    ; wait for all queued serial data to be sent
    btjf UART_SR,#TC,_serialFlush
    ret


;-------------------------------------------------------------------------------

    end
