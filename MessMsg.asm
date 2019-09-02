PrintChar	equ &BB5A		
org &8000
	ld a,9
	call SorteiaAleatorio
	ld a,(Resultado) 
	call PrintChar	
ret

SorteiaAleatorio:				
	ld d,0
SubtracaoSucessiva:
	sub 9 				
	inc d				
	jr nc, SubtracaoSucessiva     
	dec d			
	ld a,d
	ld (Resultado),a
ret

Resultado:
	db  0


