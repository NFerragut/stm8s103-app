;-------------------------------------------------------------------------------
; C Startup routine for the STM8S103
; Initializes RAM to zero, but does not support initialized C variables


;-------------------------------------------------------------------------------
; Declare external references

    xref __stack                    ; Starting address of the stack
    xref _init                      ; Function to initialize the micro
    xref _serialAvailable           ; Function to check for serial data

    xref _serialEvent               ; The Arduino-style serialEvent() function
    xref _setup                     ; The Arduino-style setup() function
    xref _loop                      ; The Arduino-style loop() function

    xdef _startup


;-------------------------------------------------------------------------------
; Private Constant Declarations

CFG_GCR:                equ $7f60


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

    ; Startup code (Reset vector)
_startup:
    ldw x,#__stack                  ; Initialize the stack pointer
    ldw sp,x
initNextByte:
    clr (x)                         ; Initialize RAM to zero
    decw x
    jrpl initNextByte

    ; Start the application
_main:
ifndef DEBUG
    mov CFG_GCR,#1                  ; Disable debugging with SWIM pin
endif
    call _init                      ; Initialize the micro
    rim                             ; Enable interrupts
    call _setup                     ; Application-specific program setup
mainLoop:
    call _loop                      ; Application-specific main loop
    call _serialAvailable           ; Check for incoming serial data
    tnzw x
    jreq mainLoop
    call _serialEvent               ; Application-specific serial data handling
    jra mainLoop


;-------------------------------------------------------------------------------
