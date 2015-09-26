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

	ORG	001BH
	jmp	delay0

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

        mov     IE,#10001010B
        mov     IP,#00000101B

        mov     TMOD,#00010001B

        ljmp    inicio
 


delay0:

        clr     tr0
        clr	tr1
        setb    00
        setb	01
        reti

delay1:
	mov     th0,#0ffH
        mov     tl0,#000H
        mov     th1,#0ffH
        mov     tl1,#0ffH
        
	setb    tr0
	clr	00
        jnb     00,$
        
        setb    tr1
        clr	01
        jnb     01,$
        
	
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

blocoA:	
	jnb	senF,erro
	jnb	senH,Erro
	jb	senE,BlocoA
	clr	valA

blocoB:
	jnb	senF,erro
        jb      senH,BlocoB
        jnb	senE,erro
	setb	valA
        clr	valB
        clr	motor

blocoC:
	jnb	senE,erro
	jb	senH,erro
        jb      senF,blocoC
       	setb	valB
        setb	motor
        clr	valC

blocoD:
        jb      senE,blocoD
        jnb	senF,erro
	jnb	senH,erro
	clr	buzzer
        setb	valC
        call    delay1
        setb	buzzer

	jmp     inicio

 erro:

	clr	buzzer
	call	delay1
	setb	buzzer
	call	delay1


 	jb 	senE,erro
 	jnb	senH,erro
 	jnb	senF,erro
 	jmp	BlocoA
 

	end
