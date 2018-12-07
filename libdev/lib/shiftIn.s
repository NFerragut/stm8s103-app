;-------------------------------------------------------------------------------
; shiftIn() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _shiftIn

    xref getPinData


;-------------------------------------------------------------------------------
; Private Constant Declarations

BIT_COUNT:              equ 8       ; number of bits to shift out


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _shiftIn() function
; XH = data pin
; XL = clock pin
; SP3 = bitOrder (0 = LSB first, otherwise MSB first)
; Returns A = value shifted in from device
_shiftIn:
    push #0
    push #BIT_COUNT
    pushw x             ; setup stack frame
    subw sp,#4
D_PORT:                 equ 1
C_PORT:                 equ 3
D_MASK:                 equ 5
C_MASK:                 equ 6
COUNT:                  equ 7
VALUE:                  equ 8
ORDER:                  equ 11

    ld a,xh             ; D_MASK = data pin mask
    call getPinData
    jreq siDone
    ld (D_MASK,sp),a
    ldw x,(x)           ; D_PORT = data pin port
    incw x
    ldw (D_PORT,sp),x
    ld a,(C_MASK,sp)    ; C_MASK = clock pin mask
    call getPinData
    jreq siDone
    ld (C_MASK,sp),a
    ldw x,(x)           ; C_PORT = clock pin port
    ldw (C_PORT,sp),x

siNextBit:
    ldw x,(C_PORT,sp)   ; toggle clock pin
    ld a,(x)
    xor a,(C_MASK,sp)
    ld (x),a
    ldw x,(D_PORT,sp)   ; carry = data pin
    ld a,(x)
    and a,(D_MASK,sp)
    rcf
    jreq siClock
    scf
siClock:
    ldw x,(C_PORT,sp)   ; toggle clock pin
    ld a,(x)
    xor a,(C_MASK,sp)
    ld (x),a
    tnz (ORDER,sp)      ; shift carry into VALUE
    jreq siLsb
    rlc (VALUE,sp)
    jrt siCount
siLsb:
    rrc (VALUE,sp)
siCount:
    dec (COUNT,sp)
    jrne siNextBit
siDone:
    addw sp,#7
    pop a
    ret


;-------------------------------------------------------------------------------

    end
