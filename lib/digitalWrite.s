;-------------------------------------------------------------------------------
; digitalWrite() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _digitalWrite

    xref getPinData


;-------------------------------------------------------------------------------
; Private Constant Declarations

GPIO_ODR:               equ 0       ; GPIO Output Data Register


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _digitalWrite()
; XH = Pin number
; XL = Value to write (HIGH or LOW)
_digitalWrite:
    pushw x             ; save value to write (HIGH or LOW)
    ld a,xh
    call getPinData
    jreq dwDone
    ldw x,(x)
    tnz (2,sp)          ; CC.Z = (Value == 0)
    jrne dwHigh
    cpl a               ; A = new output data register value with LOW bit
    and a,(GPIO_ODR,x)
    jra dwWrite
dwHigh:
    or a,(GPIO_ODR,x)   ; A = new output data register value with HIGH bit
dwWrite:
    ld (GPIO_ODR,x),a   ; write output data register
dwDone:
    popw x
    ret


;-------------------------------------------------------------------------------

    end
