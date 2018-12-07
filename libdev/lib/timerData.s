;-------------------------------------------------------------------------------
; getTimerData() assembly function


;-------------------------------------------------------------------------------
; Declare external references

    xdef getTimerData


;-------------------------------------------------------------------------------
; Private Constant Declarations

TIM1_CCER1:             equ $525c   ; TIM1 Capture/Compare Mode 1
TIM1_CCER2:             equ $525d   ; TIM1 Capture/Compare Mode 2
TIM1_CCR1:              equ $5265   ; TIM1 Capture/Compare Value 1
TIM1_CCR2:              equ $5267   ; TIM1 Capture/Compare Value 2
TIM1_CCR3:              equ $5269   ; TIM1 Capture/Compare Value 3
TIM1_CCR4:              equ $526b   ; TIM1 Capture/Compare Value 4
TIM2_CCER1:             equ $530a   ; TIM2 Capture/Compare Mode 1
TIM2_CCER2:             equ $530b   ; TIM2 Capture/Compare Mode 2
TIM2_CCR1:              equ $5311   ; TIM2 Capture/Compare Value 1
TIM2_CCR2:              equ $5313   ; TIM2 Capture/Compare Value 2
TIM2_CCR3:              equ $5315   ; TIM2 Capture/Compare Value 3
TP_SIZE:                equ 6       ; sizeof(TIMER_PINS[0])
USE_TIM1:               equ 0       ; Indicates that pin uses TIM1
USE_TIM2:               equ 1       ; Indicates that pin uses TIM2


;-------------------------------------------------------------------------------
; Private Flash-Based Constant Definitions

    switch .text

TIMER_PINS:
    dc.b USE_TIM1       ; 1st PWM output (TIM1 CH1)
    dc.w TIM1_CCR1
    dc.w TIM1_CCER1
    dc.b 0x03
    dc.b USE_TIM1       ; 2nd PWM output (TIM1 CH2)
    dc.w TIM1_CCR2
    dc.w TIM1_CCER1
    dc.b 0x30
    dc.b USE_TIM1       ; 3rd PWM output (TIM1 CH3)
    dc.w TIM1_CCR3
    dc.w TIM1_CCER2
    dc.b 0x03
    dc.b USE_TIM1       ; 4th PWM output (TIM1 CH4)
    dc.w TIM1_CCR4
    dc.w TIM1_CCER2
    dc.b 0x30
    dc.b USE_TIM2       ; 5th PWM output (TIM2 CH1)
    dc.w TIM2_CCR1
    dc.w TIM2_CCER1
    dc.b 0x03
    dc.b USE_TIM2       ; 6th PWM output (TIM2 CH2)
    dc.w TIM2_CCR2
    dc.w TIM2_CCER1
    dc.b 0x30
    dc.b USE_TIM2       ; 7th PWM output (TIM2 CH3)
    dc.w TIM2_CCR3
    dc.w TIM2_CCER2
    dc.b 0x03


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; getTimerData()
; A = timer channel (1-7)
; Returns CC.Z = 0 and X = Address of TIMER_PINS[A]
; Returns CC.Z = 1 and X = 0 if A does not represent a valid timer pin
getTimerData:
    clrw x              ; X = 0 (default if timer is invalid)
    cp a,#8             ; if (timer >= 8) return
    jruge gptDone
    ld xl,a             ; X = address of TIMER_PINS[timer - 1]
    ld a,#TP_SIZE
    mul x,a
    addw x,#TIMER_PINS-TP_SIZE
gptDone:
    tnzw x              ; CC.Z = (X == 0)
    ret


;-------------------------------------------------------------------------------

    end
