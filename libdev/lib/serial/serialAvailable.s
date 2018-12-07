;-------------------------------------------------------------------------------
; serialAvailable() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialAvailable

    xref rxBufCnt


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialAvailable() function
; return X = The number of bytes available to read
_serialAvailable:
    clrw x              ; X = # of bytes in buffer
    ld a,rxBufCnt
    ld xl,a
    ret


;-------------------------------------------------------------------------------

    end
