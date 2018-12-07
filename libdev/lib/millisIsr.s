;-------------------------------------------------------------------------------
; millisIsr() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _millisIsr
    xdef tonePin
    xdef toneStop

    xref ms


;-------------------------------------------------------------------------------
; Private variable Definitions

    switch .bsct

tonePin:                ds.b 1
toneStop:               ds.l 1


;-------------------------------------------------------------------------------
; Private Constant Declarations

TIM1_IER:               equ $5254   ; Address of TIM1 Interrupt Enable Register
TIM4_SR:                equ $5344   ; Address of TIM4 Status Register


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; Timer 4 millisecond interrupt service routine
; Executes every millisecond
_millisIsr:
    bres TIM4_SR,#0     ; clear interrupt bit
    inc ms+3            ; ms += 1
    jrne miChkTone
    inc ms+2
    jrne miChkTone
    inc ms+1
    jrne miChkTone
    inc ms
miChkTone:
    btjf TIM1_IER,#0,miDone ; if no active tone, return
    btjt tonePin,#7,miDone  ; if indefinite tone, return
miChkStop:
    ldw x,toneStop      ; if (toneStop != ms) return
    cpw x,ms
    jrne miDone
    ldw x,toneStop+2
    cpw x,ms+2
    jrne miDone
    bres TIM1_IER,#0    ; disable the tone interrupt
miDone:
    iret


;-------------------------------------------------------------------------------

    end
