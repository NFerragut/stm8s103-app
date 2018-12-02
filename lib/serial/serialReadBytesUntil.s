;-------------------------------------------------------------------------------
; serialReadBytesUntil() function

    include "uartConfig.i"


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialReadBytesUntil

    xref _serialRead
    xref rxBuf
    xref rxBufCnt
    xref rxBufRd
    xref serialTimerCheck
    xref serialTimerStart
    xref uartRxPeek
    xref uartRxPop


;-------------------------------------------------------------------------------
; Private Constant Declarations

RX_BUF_SZ:              equ (1 << RX_BUF_BITS)
RX_MASK:                equ (RX_BUF_SZ - 1)


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialReadBytesUntil() function
; A = the character to search for
; SP3 = pointer to array for received serial bytes
; SP5 = maximum number of bytes to write to the buffer
; Return X = The number of bytes that were written in the buffer
_serialReadBytesUntil:
    push a
    subw sp,#4          ; setup stack frame
START:                  equ 1
EOS:                    equ 5
ADDR:                   equ 8
SIZE:                   equ 10
    ldw x,(SIZE,sp)     ; if (SIZE == 0) return 0
    jreq srbuDone
    call serialTimerStart   ; START = ms
    ldw y,(ADDR,sp)     ; Y = pointer to the array for received serial bytes
    clrw x              ; X = 0 bytes written so far
srbuNext:
    tnz rxBufCnt        ; if (no bytes in RX queue) goto srbuWait
    jreq srbuWait
    call uartRxPeek     ; check the next byte in the serial RX queue
    cp a,(EOS,sp)       ; if (char == EOS) goto srbuDone
    jreq srbuDone
    call uartRxPop
    ld (y),a            ; write the byte to the buffer
    incw y              ; move to next address in the buffer
    incw x              ; another byte written
    cpw x,(SIZE,sp)     ; if (bytes read >= buffer size) goto srbuDone
    jruge srbuDone
srbuWait:
    call serialTimerCheck   ; if (no timeout) goto srbuNext
    jrult srbuNext
srbuDone:
    addw sp,#5
    ret


;-------------------------------------------------------------------------------

    end
