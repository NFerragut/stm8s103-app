;-------------------------------------------------------------------------------
; convertToMicros() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef convertToMicros
    xdef LONG1000

    xref c_ladd
    xref c_lmul
    xref c_lreg


;-------------------------------------------------------------------------------
; Private Flash-Based Constant Definitions

    switch .text

LONG1000:               dc.l 1000


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; convertToMicros() function
; X = address of long time to convert to microseconds
;     X can point to c_lreg
; First 3 bytes of time are milliseconds
; 4th byte of time is remaining microseconds / 4
; return c_lreg = microseconds
convertToMicros:
    ld a,(3,x)          ; save (X).us
    push a
    ld a,(2,x)          ; c_lreg = 1000 * (X).ms
    ld c_lreg+3,a
    ld a,(1,x)
    ld c_lreg+2,a
    ld a,(x)
    ld c_lreg+1,a
    clr c_lreg
    ldw x,#LONG1000
    call c_lmul
    pop a               ; SP1.l = 4 * (X).us
    ld xl,a
    ld a,#4
    mul x,a
    pushw x
    clrw x
    pushw x
    ldw x,sp
    incw x
    call c_ladd         ; c_lreg += (X).l
    addw sp,#4
    ret


;-------------------------------------------------------------------------------

    end
