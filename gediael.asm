;================================================================
;	created by: Ricardo Kim
;     
;	Brazil, Engineer Student.	10/09/2015
;================================================================
til78	equ	p1.3
ledA	equ	p2.4
ledV	equ	p2.6

 
	ORG     0000H		;┐
	jmp     preset		;┴─Define linha do preset como inicio


 	ORG     000BH		;┐
	jmp     delay0		;┴─Endereço da interrupção de M00

	ORG	001BH		;┐
	jmp	delay0		;┴─Endereço da interrupção de M10

preset:
	clr	ledA
	clr	ledV
	
	mov     IE,#10001010B	;──Habilita interrupção: EA,ET1,ET0
	mov     IP,#00000101B	;──Habilita interrupção: PX1,PX0
	mov     TMOD,#00010001B	;──Habilita timers: M10, M00
	;mov     TMOD,#00000001B	;──Habilita timers: M10, M00
	ljmp    lampON		;──Salto para Inicio
 


delay0:

	clr	tr0		;┐
	clr	tr1		;┴─Limpa TR
	setb	00		;┤
	setb	01		;┴─Desabilita funcionamento do t0 e t1
	reti			;──Retorna da Interrupção

delay1:
	mov	th0,#000H	;┐
	mov	tl0,#000H	;┤
	mov	th1,#000H	;┤
	mov	tl1,#000H	;┴─Define contador dos timers M10, e M00

	setb    tr0		;┐
	clr	00		;┤
        jnb     00,$		;┴─Ativa contagem de M00

        setb    tr1		;┐
        clr	01		;┤
        jnb     01,$		;┴─Ativa contagem de M10


       	ret			;──Retorna do chamado

lampON:
	setb	ledA
	clr	ledV

	jnb	til78,$
	jb	til78,$
	mov	r0,#113d
time1:	call	delay1
	djnz	r0,time1




lampOFF:
	clr	ledA
	setb	ledV


	jnb	til78,$
	jb	til78,$
	mov	r0,#113d
time2:	call	delay1
	djnz	r0,time2


	jmp 	lampON

	end
