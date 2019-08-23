WaitChar	equ &BB06
PrintChar	equ &BB5A		
org &8000

	ld hl,Frase
loop:
	call waitChar
	ld (hl),a
	call PrintChar
	inc hl
	cp 13
	jp z, EndFrase
jp loop

Frase:
db 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255

NewLine:
	LD A, 13
	CALL PrintChar
	LD A, 10 
	CALL PrintChar
ret

EndFrase:
	call NewLine