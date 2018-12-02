;-------------------------------------------------------------------------------
; uartTxByte() assembly function


;-------------------------------------------------------------------------------
; Declare external references

    xdef uartTxByte
    xdef txAddr
    xdef txSize


;-------------------------------------------------------------------------------
; Private Constant Declarations

TEN:                    equ 3       ; UART_CR2: Transmitter ENable
UART_DR:               equ $5231    ; UART Data Register
UART_CR2:              equ $5235    ; UART Control Register 2


;-------------------------------------------------------------------------------
; Private Variable Definitions

    switch .bsct

txAddr:                 ds.w 1
txSize:                 ds.w 1


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; uartTxByte() assembly function
; return CC.Z = (txSize == 0)
uartTxByte:
    ld a,[txAddr.w]     ; UART_DR = (txAddr)
    ld UART_DR,a
    bset UART_CR2,#TEN  ; enable transmitter in case this is the first tx byte
    inc txAddr+1        ; txAddr += 1
    jrne utbUpdSz
    inc txAddr
utbUpdSz:
    ldw x,txSize        ; txSize -= 1
    decw x
    ldw txSize,x
    ret


;-------------------------------------------------------------------------------

    end
