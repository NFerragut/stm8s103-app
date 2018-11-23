;-------------------------------------------------------------------------------
; serialBegin() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialBegin

    xref c_ladd
    xref c_lreg
    xref c_ltor
    xref c_ludv


;-------------------------------------------------------------------------------
; Private Constant Declarations

IDLE:                   equ 4       ; UART1_SR: IDLE line detected
MIN_BAUD:               equ 245     ; minimum baud rate supported
UART1_SR:               equ $5230   ; UART1 Status Register
UART1_BRR1:             equ $5232   ; UART1 Baud Rate Register 1
UART1_BRR2:             equ $5233   ; UART1 Baud Rate Register 2
UART1_CR1:              equ $5234   ; UART1 Control Register 1
UART1_CR2:              equ $5235   ; UART1 Control Register 2
UART1_CR3:              equ $5236   ; UART1 Control Register 3


;-------------------------------------------------------------------------------
; Private Flash-Based Constant Definitions

    switch .text

LONG16M:                dc.l 16000000
UART_CNFG:              dc.b 0x00, 0x00         ; SERIAL_8N1
                        dc.b 0x00, 0x20         ; SERIAL_8N2
                        dc.b 0x14, 0x00         ; SERIAL_8E1
                        dc.b 0x16, 0x00         ; SERIAL_8O1


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialBegin()
; SP3 = requested speed (bps)
; SP7 = requested UART1 configuration
_serialBegin:
    clrw x              ; X = offset into UART_CONFIG data
    ld a,(7,sp)
    cp a,#4
    jruge sbDefCfg
    ld xl,a
    slaw x
sbDefCfg:
    ld a,(UART_CNFG,x)  ; UART1_CR1 = UART_CONFIG[X]
    ld UART1_CR1,a
    ld a,(UART_CNFG+1,x); UART1_CR3 = UART_CONFIG[X+1]
    ld UART1_CR3,a
    ldw x,(3,sp)        ; if (speed < MIN_BAUD) speed = MIN_BAUD
    jrne sbDivisor2
    ldw x,#MIN_BAUD
    cpw x,(5,sp)
    jrule sbDivisor
    ldw (5,sp),x
sbDivisor:
    ldw x,(3,sp)        ; c_lreg = speed / 2
sbDivisor2:
    srlw x
    ldw c_lreg,x
    ldw x,(5,sp)
    rrcw x
    ldw c_lreg+2,x
    ldw x,#LONG16M      ; c_lreg += UC_CLOCK_FREQUENCY
    call c_ladd
    ldw x,sp            ; c_lreg /= speed
    addw x,#3
    call c_ludv
    ldw x,c_lreg+2      ; UART1_BRR2 = ((divisor >> 8) & 0xF0) + (divisor & 0x0F)
    swapw x
    srlw x
    srlw x
    srlw x
    srlw x
    ld a,xl
    swap a
    ld UART1_BRR2,a
    ldw x,c_lreg+2      ; UART1_BRR1 = (divisor >> 4) & 0xFF
    srlw x
    srlw x
    srlw x
    srlw x
    ld a,xl
    ld UART1_BRR1,a
    mov UART1_CR2,#$24  ; Enable UART1 receiver
    ret


;-------------------------------------------------------------------------------

    end
