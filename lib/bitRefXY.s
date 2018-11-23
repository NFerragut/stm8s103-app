;-------------------------------------------------------------------------------
; bitRefXY() assembly function


;-------------------------------------------------------------------------------
; Declare external references

    xdef bitRefXY
    xdef MASK_OR


;-------------------------------------------------------------------------------
; Private Flash-Based Constant Definitions

    switch .text

MASK_OR:
    dc.b $01
    dc.b $02
    dc.b $04
    dc.b $08
    dc.b $10
    dc.b $20
    dc.b $40
    dc.b $80


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; bitRefXY()
; X = address of a long value
; A = bit number (0-31)
; Returns X = address of byte with the bit
; Returns Y = bit number
bitRefXY:
    cp a,#$20           ; if (A > 31) return mask of 0
    jrult brxyBitOk
    clr a
    ret
brxyBitOk:
    bcp a,#$10          ; X = address of byte with bit
    jrne brxyChkBit
    incw x
    incw x
brxyChkBit:
    bcp a,#$08
    jrne brxyGetBitNum
    incw x
brxyGetBitNum:
    pushw x             ; A = mask for bit in byte
    clrw x
    and a,#7
    ld xl,a
    ld a,(MASK_OR,x)
    popw x
    ret


;-------------------------------------------------------------------------------

    end
