;-------------------------------------------------------------------------------
; analogWrite() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _analogWrite

    xref _pinMode
    xref getPinData
    xref getTimerData


;-------------------------------------------------------------------------------
; Private Constant Declarations

DP_MASK:                equ 2       ; DIGITAL_PINS offset: port pin mask
DP_PORT:                equ 0       ; DIGITAL_PINS offset: GPIO peripheral port
DP_TMR:                 equ 3       ; DIGITAL_PINS offset: timer channel
GPIO_DDR:               equ 2       ; Offset for Data Direction Register
OUTPUT_MASK:            equ 4       ; Mask for output pin mode value
TIM1_ARRH:              equ $5262   ; Timer 1 auto-reload high register
TIM1_ARRL:              equ $5263   ; Timer 1 auto-reload low register
TIM2_ARRH:              equ $530f   ; Timer 2 auto-reload high register
TIM2_ARRL:              equ $5310   ; Timer 2 auto-reload low register
TP_TIM:                 equ 0       ; TIMER_PINS offset: auto-reload register
TP_CCR:                 equ 1       ; TIMER_PINS offset: timer channel capt/comp
TP_CCER:                equ 3       ; TIMER_PINS offset: capt/comp enable
TP_MASK:                equ 5       ; TIMER_PINS offset: capt/comp enable mask


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _analogWrite()
; XH = Digital pin number
; XL = Duty cycle (0 = 0%, 255 = 100%)
_analogWrite:
    pushw x             ; SP1=pNum, SP2=duty
    ld a,xh             ; get pin data
    call getPinData     ; if (pin is invalid) return
    jreq awDone
    ld a,(DP_TMR,x)     ; if (pin has no PWM) return
    jreq awDone
    pushw x             ; Y = timer data
    call getTimerData
    ldw y,x
    popw x
    jreq awDone         ; if (no timer data) return
    ld a,(DP_MASK,x)    ; if (pin is already output) goto awTimer
    ldw x,(DP_PORT,x)
    and a,(GPIO_DDR,x)
    jrne awTimer
    ldw x,(1,sp)        ; call pinMode(pNum, OUTPUT)
    ld a,#OUTPUT_MASK
    ld xl,a
    call _pinMode
awTimer:
    tnz (TP_TIM,y)      ; if (using TIM2) goto awT2Arr
    jrne awT2Arr
    mov TIM1_ARRH,#$0f  ; TIM1_ARR = $0ff0 - 1 = $0fef
    mov TIM1_ARRL,#$ef
    jrt awCcr
awT2Arr:
    mov TIM2_ARRH,#$0f  ; TIM2_ARR = $0ff0 - 1 = $0fef
    mov TIM2_ARRL,#$ef
awCcr:
    ldw x,y             ; set capture/compare duty cycle
    ldw x,(TP_CCR,x)    ;   CCR = 16 * duty
    ld a,(2,sp)
    swap a
    push a
    and a,#$0f
    ld (x),a
    pop a
    and a,#$f0
    ld (1,x),a
    ldw x,y             ; enable timer output pin
    ldw x,(TP_CCER,x)   ;   CCER = (CCER & ~MASK) | ($11 & MASK)
    ld a,(x)
    xor a,#$11
    and a,(TP_MASK,y)
    xor a,(x)
    ld (x),a
awDone: 
    popw x
    ret


;-------------------------------------------------------------------------------

    end
