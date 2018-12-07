;-------------------------------------------------------------------------------
; interrupt vector table


;-------------------------------------------------------------------------------
; Declare external references

    xref _millisIsr
    xref _startup
    xref _toneIsr
    xref _uartRxIsr
    xref _uartTxIsr
    xref _unhandledIsr


;-------------------------------------------------------------------------------
; Vector Table Definitions

vector: section
    switch vector

    dc.w $8200
    dc.w _startup       ; Reset
    dc.w $8200
    dc.w _unhandledIsr  ; Software Interrupt
    dc.w $8200
    dc.w _unhandledIsr  ;  0 External Top Level Interrupt
    dc.w $8200
    dc.w _unhandledIsr  ;  1 Auto Wake-Up From Halt
    dc.w $8200
    dc.w _unhandledIsr  ;  2 Clock Controller
    dc.w $8200
    dc.w _unhandledIsr  ;  3 Port A External Interrupts
    dc.w $8200
    dc.w _unhandledIsr  ;  4 Port B External Interrupts
    dc.w $8200
    dc.w _unhandledIsr  ;  5 Port C External Interrupts
    dc.w $8200
    dc.w _unhandledIsr  ;  6 Port D External Interrupts
    dc.w $8200
    dc.w _unhandledIsr  ;  7 Port E External Interrupts
    dc.w $8200
    dc.w _unhandledIsr
    dc.w $8200
    dc.w _unhandledIsr
    dc.w $8200
    dc.w _unhandledIsr  ; 10 End of SPI Transfer
    dc.w $8200
    dc.w _toneIsr       ; 11 TIM1 Update/Overflow/Underflow/Trigger/Break
    dc.w $8200
    dc.w _unhandledIsr  ; 12 TIM1 Capture/Compare
    dc.w $8200
    dc.w _unhandledIsr  ; 13 TIM2 Update/Overflow
    dc.w $8200
    dc.w _unhandledIsr  ; 14 TIM2 Capture/Compare
    dc.w $8200
    dc.w _unhandledIsr
    dc.w $8200
    dc.w _unhandledIsr
    dc.w $8200
    dc.w _uartTxIsr     ; 17 UART1 Transmit Complete
    dc.w $8200
    dc.w _uartRxIsr     ; 18 UART1 Receive Register Data Full
    dc.w $8200
    dc.w _unhandledIsr  ; 19 I2C Interrupt
    dc.w $8200
    dc.w _unhandledIsr
    dc.w $8200
    dc.w _unhandledIsr
    dc.w $8200
    dc.w _unhandledIsr  ; 22 ADC1 End of Conversion/Analog Watchdog
    dc.w $8200
    dc.w _millisIsr     ; 23 TIM4 Update/Overflow
    dc.w $8200
    dc.w _unhandledIsr  ; 24 Flash End of Programming/Write Protected


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

_unhandledIsr:
    iret


;-------------------------------------------------------------------------------

    end
