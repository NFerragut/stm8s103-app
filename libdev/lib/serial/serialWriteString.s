;-------------------------------------------------------------------------------
; serialWriteString() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialWriteString

    xref _serialWriteBuffer


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialWriteString() function
; X = Address of string to write to UART
; return X = # of bytes written to UART
_serialWriteString:
    pushw x             ; save string address
swsFindLen:
    tnz (x)             ; if (char is 0) goto swsEos
    jreq swsEos
    incw x              ; advance to next char
    jrt swsFindLen
swsEos:
    subw x,(1,sp)       ; calculate string length
    exgw x,y
    popw x              ; X = Address of string to write to UART
    pushw y             ; SP1 = # of bytes to write to UART
    call _serialWriteBuffer
    pop a
    pop a
    ret


;-------------------------------------------------------------------------------

    end
