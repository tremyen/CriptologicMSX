WaitChar	equ &BB06
PrintChar	equ &BB5A

org &8000
	call GetMsg 
	call NewLine
	call MessMsg
	;call NewLine
	;call WaitPlayer
	;call ShowErroCount
ret

GetMsg:
	ld hl,Frase
loopGM:
	call waitChar
	ld (hl),a
	call PrintChar
	inc hl
	cp 13
	ret z 
jp loopGM

MessMsg:
	ld hl, Frase+13
loopMM:
	ld a,(hl)
	call PrintChar
	cp Frase-1
	ret z
	dec hl
jp loopMM

WaitPlayer:
ret

ShowErroCount:
ret

NewLine:
	LD A, 13
	CALL PrintChar
	LD A, 10 
	CALL PrintChar
ret

Frase:
	db 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255

