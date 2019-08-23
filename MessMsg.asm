org &8000
	ld a,r
	call DivByNine
ret

DivByNine:				
	LD B,9			
	LD D,0
MATHDIVAGAIN:
	SUB B 			; diminuimos b
	INC D			; somamos o contador de divisoes
	JR NC, MATHDIVAGAIN     ; se nao teve carry
	DEC D			
	LD A,D			; carrega o numemero de divisoes no resultado 
	LD (&9000),A
ret
