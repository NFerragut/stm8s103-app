;-------------------------------------------------------------------------------
; pinMode() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _pinMode

    xref getPinData
    xref getPinGpio
    xref getTimerData


;-------------------------------------------------------------------------------
; Private Constant Declarations

DP_TMR:                 equ 3       ; DIGITAL_PINS offset: timer channel | port
GPIO_DDR:               equ 2       ; Offset for Data Direction Register
GPIO_CR1:               equ 3       ; Offset for Control Register 1
GPIO_CR2:               equ 4       ; Offset for Control Register 2
INPUT_PULLUP_MASK:      equ 1       ; Mask for pin mode value
OUTPUT_FAST_MASK:       equ 2       ; Mask for pin mode value
OUTPUT_MASK:            equ 4       ; Mask for pin mode value
OUTPUT_OPENDRAIN_MASK:  equ 1       ; Mask for pin mode value
TD_CCER:                equ 3       ; TIMER_PINS offset: CCERx address
TD_MASK:                equ 5       ; TIMER_PINS offset: CCERx register mask


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _pinMode()
; XH = Pin number
; XL = Pin Mode
_pinMode:
    pushw x             ; SP1=pNum, SP2=pMode
    ld a,xh             ; if (pin is invalid) goto pmDone1
    call getPinData
    jreq pmDone1
    push a              ; SP1=orMask, SP2=pNum, SP3=pMode
    cpl a
    push a              ; SP1=andMask, SP2=orMask, SP3=pNum, SP4=pMode
    ld a,(DP_TMR,x)
    push a              ; SP1=pTmr, SP2=andMask, SP3=orMask, SP4=pNum, SP5=pMode
    ldw x,(x)           ; if (MODE & OUTPUT_MASK) goto pmOutput
    ld a,(5,sp)
    and a,#OUTPUT_MASK
    jrne pmOutput
    ld a,(GPIO_CR2,x)   ; disable pin's external interrupt
    and a,(2,sp)
    ld (GPIO_CR2,x),a
    ld a,(GPIO_DDR,x)   ; set pin as input
    and a,(2,sp)
    ld (GPIO_DDR,x),a
    ld a,(5,sp)         ; if (pMode & INPUT_PULLUP_MASK) goto pmPullUp
    and a,#INPUT_PULLUP_MASK
    jrne pmPullUp
    ld a,(GPIO_CR1,x)   ; disable pull-up input feature
    and a,(2,sp)
    ld (GPIO_CR1,x),a
    jra pmDisablePwm
pmPullUp:
    ld a,(GPIO_CR1,x)   ; enable pull-up input feature
    or a,(3,sp)
    ld (GPIO_CR1,x),a
pmDisablePwm:
    ld a,(1,sp)         ; if (No PWM channel) goto pmDone2
    call getTimerData
    jreq pmDone2
    ld a,(TD_MASK,x)    ; save AND mask for timer channel output
    cpl a
    ld (2,sp),a
    ldw x,(TD_CCER,x)   ; disable timer channel's output pin
    ld a,(x)
    and a,(2,sp)
    ld (x),a
pmDone2:
    addw sp,#3
pmDone1:
    popw x
    ret
pmOutput:
    ld a,(GPIO_DDR,x)   ; set pin as output
    or a,(3,sp)
    ld (GPIO_DDR,x),a
    ld a,(5,sp)         ; if ((MODE & OUTPUT_OPENDRAIN_MASK) == 0) goto pmPushPull
    and a,#OUTPUT_OPENDRAIN_MASK
    jreq pmPushPull
    ld a,(GPIO_CR1,x)   ; set pin as open drain output
    and a,(2,sp)
    ld (GPIO_CR1,x),a
    jra pmSlow
pmPushPull:
    ld a,(GPIO_CR1,x)   ; set pin as push pull output
    or a,(3,sp)
    ld (GPIO_CR1,x),a
    ld a,(5,sp)         ; if ((MODE & OUTPUT_FAST_MASK) == 0) goto pmSlow
    and a,#OUTPUT_FAST_MASK
    jreq pmSlow
    ld a,(GPIO_CR2,x)   ; enable fast output feature
    or a,(3,sp)
    ld (GPIO_CR2,x),a
    jra pmDisablePwm
pmSlow:
    ld a,(GPIO_CR2,x)   ; disable fast output feature
    and a,(2,sp)
    ld (GPIO_CR2,x),a
    jra pmDisablePwm


;-------------------------------------------------------------------------------

    end
