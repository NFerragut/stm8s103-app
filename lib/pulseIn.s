;-------------------------------------------------------------------------------
; pulseIn() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _pulseIn

    xref c_lgursh
    xref c_lreg
    xref c_ltor
    xref c_ludv
    xref c_lumd
    xref convertToMicros
    xref getMicroTime
    xref getPinData


;-------------------------------------------------------------------------------
; Private Flash-Based Constant Definitions

    switch .text

LONG250:                dc.l 250


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _pulseIn() function
; XH = digital pin to read
; XL = pulse type (HIGH or LOW)
; SP3 = timeout
_pulseIn:
    pushw x             ; SP1=pNum, SP2=pulse, SP5=timeout
    subw sp,#15         ; setup stack frame
NOW:                    equ 1
TEMP:                   equ 5
T0:                     equ 5
START:                  equ 9
PORT:                   equ 13
STATE:                  equ 15
MASK:                   equ 16
HILO:                   equ 17
TIMEOUT:                equ 20

    tnz (TIMEOUT,sp)
    jrmi piTimeout
    clr (STATE,sp)      ; state = 0
    ld a,xh             ; X = address of pin data
    call getPinData
    jreq piTimeout      ; if (pin is invalid) goto piTimeout
    ld (MASK,sp),a      ; SP1=end, SP5=pPort, SP7=state, SP8=pMask, SP9=pulse, SP12=timeout
    tnz (HILO,sp)       ; if (HILO != 0) HILO = MASK
    jreq piLowPulse
    ld (HILO,sp),a
piLowPulse:
    ldw x,(x)           ; X = address of pin's Input Data Register (IDR)
    incw x
    ldw (PORT,sp),x     ; save GPIO_IDR
    ldw x,sp            ; TIMEOUT /= 4
    addw x,#TIMEOUT

;    pushw x
    ld a,#2
    call c_lgursh
    call c_ltor         ; TEMP = TIMEOUT % 250
    ldw x,#LONG250
    call c_lumd
    ld a,c_lreg+3
    ld (TEMP,sp),a
    ldw x,sp            ; c_lreg = TIMEOUT / 250
    addw x,#TIMEOUT
    call c_ltor
    ldw x,#LONG250
    call c_ludv
    ld a,c_lreg+1       ; (TIMEOUT).ms = c_lreg
    ld (TIMEOUT,sp),a
    ld a,c_lreg+2
    ld (TIMEOUT+1,sp),a
    ld a,c_lreg+3
    ld (TIMEOUT+2,sp),a
    ld a,(TEMP,sp)      ; (TIMEOUT).us = TEMP
    ld (TIMEOUT+3,sp),a
;    popw x

    ldw x,sp            ; T0 = current time
    addw x,#T0
    call getMicroTime
piWait:
    ldw x,sp            ; NOW = current time
    incw x
    call getMicroTime
    ldw x,(NOW,sp)      ; if ((NOW - T0) < TIMEOUT) goto piRead
    subw x,(T0,sp)
    cpw x,(TIMEOUT,sp)
    jrmi piRead
    ldw x,(NOW+2,sp)
    subw x,(T0+2,sp)
    cpw x,(TIMEOUT+2,sp)
    jrmi piRead
piTimeout:
    clrw x              ; return 0
    ldw c_lreg,x
    ldw c_lreg+2,x
    addw sp,#17
    ret

piRead:
    ldw x,(PORT,sp)     ; if (pin != desired level) goto piWait
    ld a,(x)
    and a,(MASK,sp)
    xor a,(HILO,sp)
    jreq piWait

    ; 1st arrival here confirms pre-pulse level
    ; 2nd arrival here is start of pulse
    ; 3rd arrival here is end of pulse
    ld a,(HILO,sp)      ; toggle pulse polarity
    xor a,(MASK,sp)
    ld (HILO,sp),a
    inc (STATE,sp)      ; advance state
    ld a,(STATE,sp)     ; jump based on state
    cp a,#2
    jrult piWait        ; if (state == 1) goto piWait
    jrugt piStop        ; if (state == 3) goto piStop
    ldw x,(NOW,sp)      ; START = NOW
    ldw (START,sp),x
    ldw x,(NOW+2,sp)
    ldw (START+2,sp),x
    jra piWait          ; goto piWait

piStop:
    ld a,(NOW+3,sp)     ; NOW -= START
    sub a,(START+3,sp)
    jrnc piNoCarry
    sub a,#6
    scf
piNoCarry:
    ld (NOW+3,sp),a
    ld a,(NOW+2,sp)
    sbc a,(START+2,sp)
    ld (NOW+2,sp),a
    ld a,(NOW+1,sp)
    sbc a,(START+1,sp)
    ld (NOW+1,sp),a
    ld a,(NOW,sp)
    sbc a,(START,sp)
    ld (NOW,sp),a
    ldw x,sp
    incw x
    call convertToMicros
    addw sp,#17
    ret


;-------------------------------------------------------------------------------

    end
