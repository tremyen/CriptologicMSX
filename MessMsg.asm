PrintChar	equ &BB5A		
org &8000
	ld a,r
	call SorteiaAleatorio
	call PegarPosicao
ret

SorteiaAleatorio:				
	ld d,0
SubtracaoSucessiva:
	sub 9 				
	inc d				
	jr nc, SubtracaoSucessiva     
	dec d			
	ld a,d
	ld (&9000),a
ret

PegarPosicao:

