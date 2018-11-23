;-------------------------------------------------------------------------------
; bitSet() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _bitSet

    xref bitRefXY


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _bitSet()
; X = Address of the value whose bit will be set
; SP3.b = Which bit to set (0-31)
; Sets the specified bit
_bitSet:
    call bitRefXY       ; X = address of byte with bit, A = bit mask
    or a,(x)            ; set bit
    ld (x),a
    ret


;-------------------------------------------------------------------------------

    end
