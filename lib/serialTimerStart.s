;-------------------------------------------------------------------------------
; serialTimerStart() assembly function


;-------------------------------------------------------------------------------
; Declare external references

    xdef serialTimerStart
    xdef rxTimeout

    xref ms


;-------------------------------------------------------------------------------
; Private Constant Declarations

DEF_TIMEOUT:            equ 1000    ; default value for rxTimeout


;-------------------------------------------------------------------------------
; Private Variable Definitions

    switch .ubsct

rxTimeout:              ds.l 1


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; serialTimerStart() assembly function
; validates the rxTimeout
; sets start time to current time
; SP3 = start time to set
; returns A,X,Y registers unchanged
serialTimerStart:
    pushw x
    ldw x,rxTimeout     ; if (rxTimeout is negative) goto sstUseDefault
    jrmi sstUseDefault  ; if (rxTimeout is zero) goto sstUseDefault
    jrne sstGetMs       ; otherwise goto sstGetMs
    cpw x,rxTimeout+2
    jrne sstGetMs
sstUseDefault:
    clrw x              ; replace rxTimeout with default value
    ldw rxTimeout,x
    ldw x,#DEF_TIMEOUT
    ldw rxTimeout+2,x
sstGetMs:
    sim                 ; Disable interrupts
    ldw x,ms            ; SP3 = (current) ms
    ldw (5,sp),x
    ldw x,ms+2
    rim                 ; Enable interrupts
    ldw (7,sp),x
    popw x
    ret


;-------------------------------------------------------------------------------

    end
