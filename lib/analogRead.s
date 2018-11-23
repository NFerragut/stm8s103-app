;-------------------------------------------------------------------------------
; analogRead() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _analogRead

    xref MASK_OR


;-------------------------------------------------------------------------------
; Private Constant Declarations

ADC1_CSR:               equ $5400   ; ADC1 Control/Status Register
ADC1_CR1:               equ $5401   ; ADC1 Configuration Register 1
ADC1_CR2:               equ $5402   ; ADC1 Configuration Register 2
ADC1_DRH:               equ $5404   ; ADC1 Data Register (high byte)
ADC1_DRL:               equ $5405   ; ADC1 Data Register (low byte)
ADC1_TDRL:              equ $5407   ; ADC1 Trigger Disable Register Low
UART1_CR2:              equ $5235   ; UART1 Control Register 2


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _analogRead()
; A = Analog pin number (0-4)
; Returns X = Result of 10-bit conversion
_analogRead:
    clrw x
    cp a,#5             ; if (pin >= 5) goto arDone
    jruge arDone
    cp a,#3             ; if (pin < 3) goto arChannel
    jrult arChannel
    tnz UART1_CR2       ; if (UART1 is enabled) goto arDone
    jrne arDone
arChannel:
    add a,#2            ; ADC channel = Analog pin number + 2
    push a
    ld xl,a             ; turn on ADC
    ld a,(MASK_OR,x)
    ld ADC1_TDRL,a
    mov ADC1_CR2,#$08
    mov ADC1_CR1,#$71
    pop a               ; select ADC channel
    ld ADC1_CSR,a
    bset ADC1_CR1,#0    ; do ADC conversion
arWait:
    btjf ADC1_CSR,#7,arWait
    bres ADC1_CSR,#7
    ld a,ADC1_DRL       ; read ADC result
    ld xl,a
    ld a,ADC1_DRH
    ld xh,a
    mov ADC1_CR1,#$70   ; turn off ADC
    clr ADC1_TDRL
arDone:
    ret


;-------------------------------------------------------------------------------

    end
