;-------------------------------------------------------------------------------
; bitClear() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _bitClear

    xref bitRefXY


;-------------------------------------------------------------------------------
; Private Flash-Based Constant Definitions

    switch .text


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _bitClear()
; X = Address of the value whose bit will be cleared
; SP3.b = Which bit to clear (0-31)
; Clears the specified bit
_bitClear:
    call bitRefXY       ; X = address of byte with bit, A = bit mask
    cpl a
    and a,(x)
    ld (x),a
    ret


;-------------------------------------------------------------------------------

    end
