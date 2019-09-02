;==========================================================================
; Criptologic para MSX 
; Versao 1.0 
; Manoel Neto 2019-08-30
;==========================================================================
WaitChar	equ &BB06
PrintChar	equ &BB5A

org &8000
	call GetMsg 		; obtem a mensagem do usuario
	call NewLine		; pula uma linha
	call MessMsg		; troca a mensagem
	;call NewLine
	;call WaitPlayer
	;call ShowErroCount
ret

GetMsg:
	ld hl,Frase		; carrega o endereco de memoria onde
				; a frase sera armazenada
	ld b,0			; zera o contador de letras
loopGM:
	call WaitChar		; chama rotina da bios para ler um 
				; caracter
	ld (hl),a		; guarda o ascii esse caracter no 
				; enrececo hl
	call PrintChar		; chama a rotina da bios que imprime um 
				; caracter
	inc hl			; adiciona um ao endereco no registrador 
				; hl, para guardar o proximo caracter na 
				; proxima posicao de memoria
	inc b			; aumenta o contador de letras
	cp 13			; compara o carcter entrado com o ENTER(13)
				; se o usuario apertou enter, a frase acabou	
	jp z,ValidaDuasLetras	; se a frase terminou por enter precisamos 
				; validar se temos pelo menos duas letras
Validado:	
	cp 14			; compara o contador com 14
	ret z			; se A-14 = 0 vc ja digitou 14 letras
jp loopGM

ValidaDuasLetras:
	ld a,b			; coloca o contador de letras no acumulador
				; para a comparacao
	cp 3			; compara com 3, pois o enter eh um caracter
	ret nc			; se a>=2 esta ok, retorna
	jp Validado		; senao volta para o loop de recebimento

MessMsg:
	ld hl, Frase+13
	ld b,0
loopMM:
	ld a,(hl)
	call PrintChar
	inc b
	ld a,b
	cp 14
	ret z
	dec hl
jp loopMM

WaitPlayer:
ret

ShowErroCount:
ret

NewLine:
	ld a, 13
	call PrintChar
	ld a, 10 
	call PrintChar
ret

Frase:
	db 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32

