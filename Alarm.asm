;========================================
; Make by: Ricardo Kim
;
;2014
;========================================

config:	mov	r7,#0FFh	;┐
	mov	r6,#0FFh	;┴─r7,r6,r5->delay

	clr	p1.1		;┐
	clr	p1.3		;┼─para inicio [set:off]
	clr	p1.4		;┤
	clr	p1.5		;┤
	clr	p1.6		;┤
	clr	p1.7		;┘

	mov	p3,#0ffh	;──buzzer
	mov	p2,#0ffh	;──buzzer
	mov	p0,#0ffh	;──buzzer

	jmp	inicio

delay:	djnz	r7,delay	;┐
	call	chave1		;┼─delay e controle[stand:by/on]
	djnz 	r6,delay	;┤
	djnz	r5,delay	;┘
	ret

chave1:	jb	p1.0,str	;──jump not zero bit da chave
	ret			;──retorna ao roteiro do programa

chave2:	jb	p1.2,mon2	;──jump not zero bit da chave
	ret			;──retorna ao roteiro do programa

mon2:	dec	sp		;┐
	dec	sp		;┴─decrementa 2 posições stackpoint

mon:	setb	p1.4		;┐
	clr	p1.5		;┴─para saida p1 monitora

	clr	p3.4		;┐
	setb	p3.5		;┴─para saida p3 monitora

	clr	p2.4		;┐
	setb	p2.5		;┴─para saida p2 monitora

	clr	p0.4		;┐
	setb	p0.5		;┴─para saida p0 monitora

	mov	r5,#004h	;──0,5 segundos
	call	delay		;──chama delay

	clr	p1.4		;┐
	setb	p1.5		;┴─para saida monitora p1
	
	clr	p3.5		;┐
	setb	p3.4		;┴─para saida monitora p3

	clr	p2.5		;┐
	setb	p2.4		;┴─para saida monitora p2

	clr	p0.5		;┐
	setb	p0.4		;┴─para saida monitora p0

	mov	r5,#004h	;──0,5segs
	call	delay		;──chama delay
	call	chave2		;──verifica sensor da chave2
	ret			;──retorna ao roteiro do programa

alarme:	setb	p1.4		;┐
	setb	p1.5		;┼─alarme[set:on]
	setb	p1.6		;┤
	setb	p1.7		;┘

	mov	p3,#000h	;──p3 alarme[set:on]
	mov	p2,#000h	;──p2 alarme[set:on]
	mov	p0,#000h	;──p0 alarme[set:on]

alarm2:	call	chave1		;──controle[stand:by/on]
	jmp	alarm2		;──mantem verificação da chave
	ret			;──retorna ao roteiro do programa

str:	dec	sp		;┐
	dec	sp		;┴─decrementa 2 posições stackpoint

	clr	p1.4		;┐
	clr	p1.5		;┼─alarme[set:off]
	clr	p1.6		;┤
	clr	p1.7		;┘

	mov	p3,#0FFh	;──desliga saida p3
	mov	p2,#0FFh	;──desliga saida p2
	mov	p0,#0FFh	;──desliga saida p0

inicio:	call	chave1	 	;──verifica chave1
	mov	r5,#050h 	;──r5 controle p/10segundos
	call	delay		;──chama delay
	call	mon 		;──entra no estado de sinal de monitoramento
	mov	r5,#050h 	;──r5 controle p/10segundos
	call	delay		;──chama delay
	call	chave1		;──controle para desligar o alarme
	call	alarme		;──vai pro disparo

	end			;──fim
