;================================================================
;	created by: Ricardo Kim
;     
;	Brazil, Engineer Student.	10/09/2015
;================================================================

buzzer	equ     p0.0    	;Buzzer

valA	equ	p0.6		;valve A
valB    equ     p0.5    	;valve B
valC    equ     p0.4    	;valve C

senE	equ     p1.7    	;sensor Empty
senH	equ     p1.2    	;sensor Half
senF	equ     p1.1    	;sensor Full

motor   equ     p0.3    	;Mixer Motor

 
	ORG     0000H		;┐
	jmp     preset		;┴─Define linha do preset como inicio


 	ORG     000BH		;┐
	jmp     delay0		;┴─Endereço da interrupção de M00

	ORG	001BH		;┐
	jmp	delay0		;┴─Endereço da interrupção de M10

preset:
	setb	vala		;┐
	setb	valb		;┤
	setb	valc		;┤
	setb	motor		;┤
	setb	buzzer		;┴─Define todas as saidas desligadas

	mov     IE,#10001010B	;──Habilita interrupção: EA,ET1,ET0
	mov     IP,#00000101B	;──Habilita interrupção: PX1,PX0
	mov     TMOD,#00010001B	;──Habilita timers: M10, M00

	ljmp    inicio		;──Salto para Inicio
 


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



inicio:

blocoA:	
	jnb	senF,erro	;┐
	jnb	senH,Erro	;┤
	jb	senE,BlocoA	;┴─Está vazio? [001] 
	
	clr	valA		;┐
	setb	valB		;┤
	setb	valC		;┤
	setb	motor		;┴─Abre valvula A [10000]

blocoB:
	jnb	senF,erro	;┐
        jb      senH,BlocoB	;┤
        jnb	senE,erro	;┴─Está na metade? [010]
        
	setb	valC		;┐
	setb	valA		;┤
        clr	valB		;┤
        clr	motor		;┴─Fecha A, Abre B, Liga Motor


blocoC:
	jnb	senE,erro	;┐
	jb	senH,erro	;┤
        jb      senF,blocoC	;┴─Está cheio? [110]
        
        setb	valA		;┐
       	setb	valB		;┤
        setb	motor		;┤
        clr	valC		;┴─fecha B, deliga Motor, Abre C

blocoD:
        jb      senE,blocoD	;┐
        jnb	senF,erro	;┤
	jnb	senH,erro	;┴─Esta vazio? [001]
	
	clr	buzzer		;┐
        setb	valC		;┤
        setb	valA		;┤
        setb	valB		;┴─liga alarme sonoro, fecha C

        mov	r0,#16d		;──carrega 16 voltas
seg3:	call    delay1		;┐
        djnz	r0,seg3		;┴─delay aprox 200ms por chamada

        setb	buzzer		;──desliga alarme sonoro

	jmp     inicio		;──volta inicio

 erro:
	setb	valA		;┐
	setb	valb		;┤
	setb	valC		;┤
	setb	motor		;┴─desliga tudo
	
	clr	buzzer		;┐
	call	delay1		;┤
	setb	buzzer		;┤
	call	delay1		;┴─alarme sonoro oscilante


 	jb 	senE,erro	;┐
 	jnb	senH,erro	;┤
 	jnb	senF,erro	;┴─verificado erro e está vazio? [001]
 	
 	jmp	BlocoA		;──volta para o inicio
 

	end			;──fim
