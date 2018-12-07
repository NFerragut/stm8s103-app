;-------------------------------------------------------------------------------
; digitalRead() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _digitalRead

    xref getPinData
    xref getPinGpio


;-------------------------------------------------------------------------------
; Private Constant Declarations

GPIO_IDR:               equ 1       ; Offset for Input Data Register


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _digitalRead()
; A = Pin number
; Returns A = HIGH (1) or LOW (0)
; Returns CC.Z = 1 for LOW or 0 for HIGH
_digitalRead:
    call getPinData     ; if (pin is invalid) goto drLow
    jreq drLow
    ldw x,(x)           ; If ((IDR & mask) == 0) goto drLow
    and a,(GPIO_IDR,x)
    jreq drLow
    ld a,#1
drLow:
    ret


;-------------------------------------------------------------------------------

    end
