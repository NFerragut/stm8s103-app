;-------------------------------------------------------------------------------
; bitWrite() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _bitWrite

    xref _bitClear
    xref _bitSet


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _bitWrite()
; X = Address of the value whose bit will be written
; SP3.b = which bit to write (0-31)
; SP4.b = new value for bit (0 or 1)
_bitWrite:
    ld a,(3,sp)         ; A = bit number
    tnz (4,sp)          ; if (value == 0) goto bwClear
    jreq bwClear
    jp _bitSet          ; call bitSet(X, A)
bwClear:
    jp _bitClear        ; call bitClear(X, A)


;-------------------------------------------------------------------------------

    end
