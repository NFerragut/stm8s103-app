;-------------------------------------------------------------------------------
; serialReadBytes() function

    include "uart1Config.i"


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialReadBytes

    xref rxBuf
    xref rxBufCnt
    xref rxBufRd
    xref serialTimerCheck
    xref serialTimerStart
    xref uart1RxByte


;-------------------------------------------------------------------------------
; Private Constant Declarations

RX_BUF_SZ:              equ (1 << RX_BUF_BITS)
RX_MASK:                equ (RX_BUF_SZ - 1)


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialReadBytes() function
; X = pointer to array for received serial bytes
; SP3 = maximum number of bytes to write to the buffer
; Return X = The number of bytes that were written in the buffer
_serialReadBytes:
    subw sp,#4          ; setup stack frame
START:                  equ 1
SIZE:                   equ 7
    exgw x,y            ; Y = pointer to the array for received serial bytes
    ldw x,(SIZE,sp)     ; if (SIZE == 0) return 0
    jreq srbDone
    call serialTimerStart   ; START = ms
    clrw x              ; X = 0 bytes written so far
srbNext:
    tnz rxBufCnt        ; if (no bytes in RX queue) goto srbWait
    jreq srbWait
    call uart1RxByte    ; read the next byte from the serial RX queue
    ld (y),a            ; write the byte to the buffer
    incw y              ; move to next address in buffer
    incw x              ; another byte written to the buffer
    cpw x,(SIZE,sp)     ; if (bytes written >= buffer size) goto srbDone
    jruge srbDone
srbWait:
    call serialTimerCheck   ; if (no timeout) goto srbNext
    jrult srbNext
srbDone:
    addw sp,#4
    ret


;-------------------------------------------------------------------------------

    end
