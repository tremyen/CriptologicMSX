WaitChar	equ &BB06
PrintChar	equ &BB5A		
org &8000

Begin:
	ld hl,Frase
	ld b,0 		; contador de caracteres da frase
loop:
	call waitChar
	ld (hl),a
	call PrintChar
	inc b		; incremeta o contador
	inc hl
	cp 13		; se o caracter entrado for um enter
			; termina a frase
	jp z, EndFrase
	ld a,b
	cp 14		; a frase pode ter no maximo 14 caracteres
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
	endp