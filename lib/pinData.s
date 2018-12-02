;-------------------------------------------------------------------------------
; getPinData() assembly function
; getPinGpio() assembly function


;-------------------------------------------------------------------------------
; Declare external references

    xdef getPinData
    xdef getPinGpio


;-------------------------------------------------------------------------------
; Private Constant Declarations

GPIO_BASE:              equ $5000   ; Base address for GPIO port registers
UART_CR2:               equ $5235   ; UART Control Register 2


;-------------------------------------------------------------------------------
; Private Flash-Based Constant Definitions

    switch .text

DIGITAL_PINS:
    ; Digital output D0
    dc.w $5000          ; Port A
    dc.b (1<<1)         ; Pin 1
    dc.b 0              ; No PWM output
    ; Digital output D1
    dc.w $5000          ; Port A
    dc.b (1<<2)         ; Pin 2
    dc.b 0              ; No PWM output
    ; Digital output D2, with PWM
    dc.w $5000          ; Port A
    dc.b (1<<3)         ; Pin 3
    dc.b 7              ; 7th PWM output
    ; Digital output D3
    dc.w $5005          ; Port B
    dc.b (1<<5)         ; Pin 5
    dc.b 0              ; No PWM output
    ; Digital output D4
    dc.w $5005          ; Port B
    dc.b (1<<4)         ; Pin 4
    dc.b 0              ; No PWM output
    ; Digital output D5, with PWM
    dc.w $500a          ; Port C
    dc.b (1<<3)         ; Pin 3
    dc.b 3              ; 3rd PWM output
    ; Digital output D6, with PWM, A0
    dc.w $500a          ; Port C
    dc.b (1<<4)         ; Pin 4
    dc.b 4              ; 4th PWM output
    ; Digital output D7
    dc.w $500a          ; Port C
    dc.b (1<<5)         ; Pin 5
    dc.b 0              ; No PWM output
    ; Digital output D8
    dc.w $500a          ; Port C
    dc.b (1<<6)         ; Pin 6
    dc.b 0              ; No PWM output
    ; Digital output D9
    dc.w $500a          ; Port C
    dc.b (1<<7)         ; Pin 7
    dc.b 0              ; No PWM output
    ; Digital output D10
    dc.w $500f          ; Port D
    dc.b (1<<1)         ; Pin 1
    dc.b 0              ; No PWM output
    ; Digital output D11, A1
    dc.w $500f          ; Port D
    dc.b (1<<2)         ; Pin 2
    dc.b 0              ; No PWM output
    ; Digital output D12, A2
    dc.w $500f          ; Port D
    dc.b (1<<3)         ; Pin 3
    dc.b 6              ; 6th PWM output
    ; Digital output D13
    dc.w $500f          ; Port D
    dc.b (1<<4)         ; Pin 4
    dc.b 5              ; 5th PWM output
    ; Digital output D14, A3 (also Tx)
    dc.w $500f          ; Port D
    dc.b (1<<5)         ; Pin 5
    dc.b 0              ; No PWM output
    ; Digital output D15, A4 (also Rx)
    dc.w $500f          ; Port D
    dc.b (1<<6)         ; Pin 6
    dc.b 0              ; No PWM output


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; getPinData()
; A = pin number
; Returns A = pin mask
; Returns CC.Z = 0 and X = Address of DIGITAL_PINS[A]
; Returns CC.Z = 1 and X = 0 if A does not represent a valid digital pin
getPinData:
    clrw x              ; X = 0 (default if pin is invalid)
    cp a,#16            ; if (pin >= 16) return
    jruge gdpdDone
    cp a,#14            ; if (pin >= 14) && (UART is active) return
    jrult gdpdGoodPin
    tnz UART_CR2
    jrne gdpdDone
gdpdGoodPin:
    sla a               ; X = address of DIGITAL_PINS[pin]
    sla a
    ld xl,a
    addw x,#DIGITAL_PINS
    ld a,(2,x)          ; A = pin mask
gdpdDone:
    tnzw x              ; CC.Z = (X == 0)
    ret


;-------------------------------------------------------------------------------

    end
