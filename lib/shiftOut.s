;-------------------------------------------------------------------------------
; shiftOut() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _shiftOut

    xref getPinData


;-------------------------------------------------------------------------------
; Private Constant Declarations

BIT_COUNT:              equ 8       ; number of bits to shift out


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _shiftOut() function
; XH = data pin
; XL = clock pin
; SP3 = bitOrder (0 = LSB first, otherwise MSB first)
; SP4 = value to shift out
_shiftOut:
    push #BIT_COUNT
    pushw x             ; setup stack frame
    subw sp,#4
D_PORT:                 equ 1
C_PORT:                 equ 3
D_MASK:                 equ 5
C_MASK:                 equ 6
COUNT:                  equ 7
ORDER:                  equ 10
VALUE:                  equ 11

    ld a,xh             ; D_MASK = data pin mask
    call getPinData
    jreq soDone
    ld (D_MASK,sp),a
    ldw x,(x)           ; D_PORT = data pin port
    ldw (D_PORT,sp),x
    ld a,(C_MASK,sp)    ; C_MASK = clock pin mask
    call getPinData
    jreq soDone
    ld (C_MASK,sp),a
    ldw x,(x)           ; C_PORT = clock pin port
    ldw (C_PORT,sp),x

soNextBit:
    ldw x,(D_PORT,sp)
    ld a,(D_MASK,sp)
    tnz (ORDER,sp)
    jreq soLsb
    sll (VALUE,sp)
    jrc soSet
    jrt soClear
soLsb:
    srl (VALUE,sp)
    jrnc soClear
soSet:
    or a,(x)
    jrt soWrite
soClear:
    cpl a
    and a,(x)
soWrite:
    ld (x),a
    tnzw x              ; very short delay
    ldw x,(C_PORT,sp)   ; toggle clock pin
    ld a,(x)
    xor a,(C_MASK,sp)
    ld (x),a
    tnzw x              ; very short delay
    ldw x,(C_PORT,sp)   ; toggle clock pin
    ld a,(x)
    xor a,(C_MASK,sp)
    ld (x),a
    dec (COUNT,sp)
    jrne soNextBit
soDone:
    addw sp,#7
    ret


;-------------------------------------------------------------------------------

    end
