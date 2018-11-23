;-------------------------------------------------------------------------------
; getMicroTime() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef getMicroTime

    xref ms


;-------------------------------------------------------------------------------
; Private Constant Declarations

TIM4_CNTR:              equ $5346   ; TIM4 Counter


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; getMicroTime() function
; X = address of long to put time
; First 3 bytes are milliseconds
; 4th byte is remaining microseconds / 4
getMicroTime:
    push cc
gmtRetry:
    ld a,TIM4_CNTR      ; read TIM4_CNTR
    sim                 ; disable interrupts
    cp a,TIM4_CNTR      ; if (TIM4_CNTR has not changed) goto gmtCopy
    jreq gmtCopy
    ld a,TIM4_CNTR      ; if (TIM4_CNTR != 0) goto gmtCopy
    jrne gmtCopy
    rim                 ; enable interrupts
    jrt gmtRetry        ; retry reading time
gmtCopy:
    ld (3,x),a          ; X.us = TIM4_CNTR
    ld a,ms+3           ; X.ms = ms lower 3 bytes
    ld (2,x),a
    ld a,ms+2
    ld (1,x),a
    ld a,ms+1
    ld (x),a
    pop cc              ; restore interrupts
    ret


;-------------------------------------------------------------------------------

    end
