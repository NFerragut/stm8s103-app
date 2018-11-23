;-------------------------------------------------------------------------------
; uart1TxByte() assembly function


;-------------------------------------------------------------------------------
; Declare external references

    xdef uart1TxByte
    xdef txAddr
    xdef txSize


;-------------------------------------------------------------------------------
; Private Constant Declarations

TEN:                    equ 3       ; UART1_CR2: Transmitter ENable
UART1_DR:               equ $5231   ; UART1 Data Register
UART1_CR2:              equ $5235   ; UART1 Control Register 2


;-------------------------------------------------------------------------------
; Private Variable Definitions

    switch .bsct

txAddr:                 ds.w 1
txSize:                 ds.w 1


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; uart1TxByte() assembly function
; return CC.Z = (txSize == 0)
uart1TxByte:
    ld a,[txAddr.w]     ; UART1_DR = (txAddr)
    ld UART1_DR,a
    bset UART1_CR2,#TEN ; enable transmitter in case this is the first tx byte
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
