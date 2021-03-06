;-------------------------------------------------------------------------------
; C Startup routine for the STM8S103
; Initializes RAM to zero, but does not support initialized C variables


;-------------------------------------------------------------------------------
; Declare external references

    xdef _startup

    xref __stack        ; Starting address of the stack
    xref _loop          ; The Arduino-style loop() function
    xref _serialEvent   ; The Arduino-style serialEvent() function
    xref _setup         ; The Arduino-style setup() function
    xref rxBufCnt       ; The number of bytes in the serial RX queue


;-------------------------------------------------------------------------------
; Private Constant Declarations

CFG_GCR:                equ $7f60
CLK_SWR:                equ $50c4
CLK_CKDIVR:             equ $50c6
TIM1_CR1:               equ $5250
TIM1_EGR:               equ $5257   ; Timer 1 event generation register
TIM1_CCMR1:             equ $5258
TIM1_PSCRL:             equ $5261
TIM1_ARRH:              equ $5262   ; Timer 1 auto-reload high register
TIM1_ARRL:              equ $5263   ; Timer 1 auto-reload low register
TIM1_BKR:               equ $526d   ; Timer 1 break register
TIM2_CR1:               equ $5300
TIM2_EGR:               equ $5306   ; Timer 2 event generation register
TIM2_CCMR1:             equ $5307
TIM2_PSCR:              equ $530e
TIM2_ARRH:              equ $530f   ; Timer 2 auto-reload high register
TIM2_ARRL:              equ $5310   ; Timer 2 auto-reload low register
TIM4_CR1:               equ $5340
TIM4_IER:               equ $5343
TIM4_SR:                equ $5344
TIM4_PSCR:              equ $5347
TIM4_ARR:               equ $5348


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

    ; Startup code (Reset vector)
_startup:
    ; Setup system clock
    mov CLK_SWR,#0xE1   ; Clock @ 16MHz
    clr CLK_CKDIVR

    ldw x,#__stack      ; Initialize the stack pointer
    ldw sp,x
clrNext:
    clr (x)             ; Initialize RAM to zero
    decw x
    jrpl clrNext
ifndef DEBUG
    mov CFG_GCR,#1      ; Disable debugging with SWIM pin
endif

    ; Setup TIM4 to support general application timing
    mov TIM4_ARR,#249   ; Clock TIM4 @ 125kHz
    mov TIM4_PSCR,#6    ; TIM4 will overflow every 1 ms
    bset TIM4_IER,#0
    bres TIM4_SR,#0
    bset TIM4_CR1,#0
    mov TIM1_PSCRL,#3   ; Clock TIM1 @4MHz (close to 16*255kHz)
    mov TIM1_ARRH,#$0f  ; TIM1_ARR = $0ff0 - 1 = $0fef
    mov TIM1_ARRL,#$ef
    mov TIM2_PSCR,#2    ; Clock TIM2 @4MHz (close to 16*255kHz)
    mov TIM2_ARRH,#$0f  ; TIM2_ARR = $0ff0 - 1 = $0fef
    mov TIM2_ARRL,#$ef
    ld a,#$68           ; set TIM1 & TIM2 channels as PWM output channels
    ldw x,#2
    ld (TIM1_CCMR1+1,x),a
pwmNext:
    ld (TIM1_CCMR1,x),a
    ld (TIM2_CCMR1,x),a
    decw x
    jrpl pwmNext
    bset TIM1_BKR,#7    ; TIM1_BKR.MOE = 1
    bset TIM1_EGR,#0    ; TIM1_EGR.UG = 1
    bset TIM1_CR1,#0    ; enable TIM1
    bset TIM2_EGR,#0    ; TIM2_EGR.UG = 1
    bset TIM2_CR1,#0    ; enable TIM2

    ; Start the arduino-style application
_main:
    rim                 ; Enable interrupts
    call _setup         ; Application-specific program setup
mainLoop:
    call _loop          ; Application-specific main loop
    tnz rxBufCnt        ; Check for incoming serial data
    jreq mainLoop
    call _serialEvent   ; Application-specific serial data handling
    jra mainLoop


;-------------------------------------------------------------------------------

    end
