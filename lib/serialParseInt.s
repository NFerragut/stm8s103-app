;-------------------------------------------------------------------------------
; serialParseInt() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialParseInt

    xref c_ladc
    xref c_lneg
    xref c_lmul
    xref c_lreg
    xref rxBufCnt
    xref serialTimerCheck
    xref serialTimerStart
    xref uart1RxByte
    xref uart1RxPeek
    xref uart1RxPop


;-------------------------------------------------------------------------------
; Private Flash-Based Constant Definitions

    switch .text

LONG10:                 dc.l 10


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialParseInt() function
; A = character to skip
_serialParseInt:
    push a              ; setup the stack frame
    push #0             ; NEG = false
    subw sp,#4
START:                  equ 1
NEG:                    equ 5
SKIP:                   equ 6
    call serialTimerStart   ; START = ms
    clrw x              ; c_lreg = 0
    ldw c_lreg,x
    ldw c_lreg+2,x
spiStart:
    tnz rxBufCnt        ; if (no bytes in RX queue) goto spiWaitStart
    jreq spiWaitStart
    call uart1RxByte    ; read the next byte in the serial RX queue
    cp a,#$39           ; if (not 0-9) goto spiChkMinus
    jrugt spiChkMinus
    cp a,#$30
    jrult spiChkMinus
    and a,#$0f          ; save first digit
    ld c_lreg+3,a
    jra spiWait

spiChkMinus:
    clr (NEG,sp)        ; NEG = false (positive number)
    cp a,#$2d           ; if (not dash) goto spiWaitStart
    jrne spiWaitStart
    inc (NEG,sp)        ; NEG = true (negative number)
spiWaitStart:
    call serialTimerCheck   ; if (no timeout) goto spiStart
    jrult spiStart
    jra spiDone

spiNext:
    tnz rxBufCnt        ; if (no bytes in RX queue) goto spiWait
    jreq spiWait
    call uart1RxPeek    ; peek at the next byte in the serial RX queue
    cp a,(SKIP,sp)      ; if (skip char) goto spiUsed
    jreq spiUsed
spiChkDigit:
    cp a,#$39           ; if (not 0-9) goto spiDone
    jrugt spiDone
    cp a,#$30
    jrult spiDone
    push a              ; c_lreg = 10 * c_lreg + digit(A)
    ldw x,#LONG10
    call c_lmul
    pop a
    and a,#$0f
    call c_ladc
spiUsed:
    call uart1RxPop     ; remove the used byte from the RX queue
spiWait:
    call serialTimerCheck   ; if (no timeout) goto spiNext
    jrult spiNext
spiDone:
    tnz (NEG,sp)        ; if (negative) negate NUM
    jreq spiNoNeg
    call c_lneg
spiNoNeg:
    addw sp,#6
    ret


;-------------------------------------------------------------------------------

    end
