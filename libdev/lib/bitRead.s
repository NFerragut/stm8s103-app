;-------------------------------------------------------------------------------
; bitRead() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _bitRead

    xref bitRefXY


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _bitRead()
; SP3.l = The value whose bit will be read
; SP7.b = Which bit to read
; Returns A = 0 if the bit was clear, 1 if the bit was set
_bitRead:
    ldw x,sp            ; X = address of the value to read
    addw x,#3
    ld a,(7,sp)         ; A = bit number
    call bitRefXY       ; X = address of byte with the bit, A = bit mask
    and a,(x)           ; read bit
    jreq brZero         ; if (bit == 0) goto brZero
    ld a,#1             ; return 1
brZero:
    ret


;-------------------------------------------------------------------------------

    end
