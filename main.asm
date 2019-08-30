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
	ld hl,Frase
	ld b,0
loopGM:
	call waitChar
	ld (hl),a
	call PrintChar
	inc hl
	inc b
	cp 13
	ret z 
	ld a,b
	cp 14		
	ret z
jp loopGM

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
	db 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255

