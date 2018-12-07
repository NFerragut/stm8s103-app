;-------------------------------------------------------------------------------
; tone() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _tone

    xref _millis
    xref c_fadd
    xref c_fdiv
    xref c_ftol
    xref c_lgadd
    xref c_lreg
    xref c_ltor
    xref getPinData
    xref tonePin
    xref tonePinMask
    xref tonePort
    xref toneStop


;-------------------------------------------------------------------------------
; Private Constant Declarations

RELOAD_MIN:             equ 67      ; Minimum value for TIM1_ARR
TIM1_ARRH:              equ $5262   ; Address of TIM1 Auto-Reload Register High
TIM1_ARRL:              equ $5263   ; Address of TIM1 Auto-Reload Register Low
TIM1_EGR:               equ $5257   ; Address of TIM1 Event Generation Register
TIM1_IER:               equ $5254   ; Address of TIM1 Interrupt Enable Register


;-------------------------------------------------------------------------------
; Private Flash-Based Constant Definitions

    switch .text

float0p5:               dc.l $3F000000
float2M:                dc.l $49F42400


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _tone() function
; A = pin on which to generate the tone
; SP3.f = frequency (Hz) of the tone
; SP7.l = duration (ms) of the tone
_tone:
    btjf TIM1_IER,#0,tChkParams
    ld xl,a             ; if (tone is enabled) &&
    xor a,tonePin       ;    (pin != tonePin) return
    and a,#$7F
    jrne tDone
    ld a,xl
tChkParams:
    tnz (3,sp)          ; if (frequency <= 0) return
    jrmi tDone
    jreq tDone
    ld tonePin,a        ; tonePin = pin number
    call getPinData     ; if (pin is invalid) return
    jreq tDone
    ld tonePinMask,a    ; tonePinMask = mask for pin
    ldw x,(x)           ; tonePort = address of pin's output data register
    ldw tonePort,x
    ldw x,#float2M      ; c_lreg.f = 2000000.0
    call c_ltor
    ldw x,sp            ; c_lreg.f /= frequency
    addw x,#3
    call c_fdiv
    ldw x,#float0p5     ; c_lreg.f += 0.5
    call c_fadd
    call c_ftol         ; c_lreg.l = (long)c_lreg.f
    ldw x,c_lreg        ; if (c_lreg <= 0xFFFF) goto tChkMin
    jreq tChkMin
    clrw x              ; X = 0xffff
    decw x
    jra tSetReload
tChkMin:
    ldw x,c_lreg+2      ; else if (c_lreg < RELOAD_MIN) X = RELOAD_MIN
    cpw x,#RELOAD_MIN
    jruge tSetReload
    ldw x,#RELOAD_MIN
tSetReload:
    ld a,xh             ; TIM1.ARR = X
    ld TIM1_ARRH,a
    ld a,xl
    ld TIM1_ARRL,a
    ldw x,(7,sp)        ; if (toneStop != 0) goto tCalcStop
    jrne tCalcStop
    ldw x,(9,sp)
    jrne tCalcStop
    bset tonePin,#7
    jra tStart
tCalcStop:
    ldw x,(7,sp)        ; toneStop = duration
    ldw toneStop,x
    ldw x,(9,sp)
    ldw toneStop+2,x
    call _millis        ; c_lreg = millis()
    ldw x,#toneStop     ; toneStop += c_lreg
    call c_lgadd
tStart:
    bset TIM1_EGR,#0    ; trigger a timer 1 event
    bset TIM1_IER,#0    ; enable TIM1 interrupts
tDone:
    ret


;-------------------------------------------------------------------------------

    end
