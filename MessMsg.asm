PrintChar	equ &BB5A		
org &8000
	ld a,1
	call SorteiaAleatorio
	call PegarPosicao
	call printchar	
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
	ld a,(&9000)
	ld b,a
	ld a, Mensagem
	inc b
ret

Mensagem:
	db "0123456789ABCDE",0

