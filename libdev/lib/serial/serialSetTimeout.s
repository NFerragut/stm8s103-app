;-------------------------------------------------------------------------------
; serialSetTimeout() function


;-------------------------------------------------------------------------------
; Declare external references

    xdef _serialSetTimeout

    xref rxTimeout


;-------------------------------------------------------------------------------
; Function Definitions

    switch .text

; _serialSetTimeout() function
; SP3 = length of timeout in milliseconds
_serialSetTimeout:
    ldw x,(3,sp)        ; rxTimeout = SP3.l
    ldw rxTimeout,x
    ldw x,(5,sp)
    ldw rxTimeout+2,x
    ret


;-------------------------------------------------------------------------------

    end
