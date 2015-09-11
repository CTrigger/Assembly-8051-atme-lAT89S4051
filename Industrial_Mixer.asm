;================================================================
;	created by: Ricardo Kim
;     
;	Brazil, Engineer Student.	10/09/2015
;================================================================

valA    equ     p0.0    ;valve A
valB    equ     p0.1    ;valve B
valC    equ     p0.2    ;valve C
senE    equ     p0.3    ;sensor Empty
senH    equ     p0.4    ;sensor Half
senF    equ     p0.5    ;sensor Full
motor   equ     p0.6    ;Motor
buzzer  equ     p0.7    ;Sound Alarm
 
        ORG     0000H
        jmp     preset
 
        ORG     000BH
        jmp     delay0
 
preset:
        clr     vala
        clr     valb
        clr     valc
        clr     motor
        clr     buzzer
 
        mov     IE,#10000010B
        mov     IP,#00000001B
        mov     TMOD,#01h
        ljmp    inicio
 
delay0:
        clr     tr0
        setb    00
        reti
 
delay1:
        mov     th0,#0FFH
        mov     tl0,#0E0H
        setb    tr0
        jnb     00,$
        clr     00
        ret
 
inicio:
        setb    valA
        jb      senH,$
 
        clr     valA
        setb    valB
        setb    motor
        jb      senF,$
 
        clr     valB
        clr     motor
        setb    valC
        jb      senE,$
 
        setb    buzzer
        clr     valC
        call    delay1
        clr     buzzer
 
        jmp     inicio
 
 
end
