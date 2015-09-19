;================================================================
;	created by: Ricardo Kim
;     
;	Brazil, Engineer Student.	10/09/2015
;================================================================

buzzer	equ     p0.0    ;Buzzer

valA	equ	p0.6	;valve A
valB    equ     p0.5    ;valve B
valC    equ     p0.4    ;valve C

senE	equ     p1.7    ;sensor Empty
senH	equ     p1.2    ;sensor Half
senF	equ     p1.1    ;sensor Full

motor   equ     p0.3    ;Mixer Motor

 
	ORG     0000H	
	jmp     preset


 	ORG     000BH
	jmp     delay0



preset:


	setb	vala
	setb	valb
	setb	valc
	setb	motor
	setb	buzzer
;	clr	vala
;	clr	valb
;	clr	valc
;	clr	motor
;	clr	buzzer

        mov     IE,#10000010B
        mov     IP,#00000001B

        mov     TMOD,#01h

        ljmp    inicio
 


delay0:

        clr     tr0
        setb    00
        reti

delay1:
	mov     th0,#000H
        mov     tl0,#000H
	setb    tr0
        jnb     00,$
        setb	00
	
       	ret


delay2:
	mov 	r0,#0FFh
	mov 	r1,#0FFh
	mov	r2,#017h

AS:	djnz 	r0,$
	djnz	r1,AS
	djnz	r2,AS

	ret

inicio:

	clr	valA

        jb      senH,$
	setb	valA
        clr	valB
        clr	motor

        jb      senF,$
	setb	valB
        setb	motor
        clr	valC

        jb      senE,$
	clr	buzzer
        setb	valC
        call    delay2
        setb	buzzer

	jmp     inicio

 
 

	end
