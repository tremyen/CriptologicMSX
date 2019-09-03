; sortear 14 numeros aleatorios entre 1 e 14 sem repeticao
WaitChar		equ &BB06
PrintChar		equ &BB5A
NumAleatorio 		equ &9000

org &8000
	ld b,14
SortearDenovo:
	call SortearNumero
	call Validar
	call GuardarPosicao
	call ImprimirPosicao

SortearNumero:	
	ld a,r			
	ld d,0
SubtracaoSucessiva:
	sub 9 				
	inc d				
	jr nc, SubtracaoSucessiva     
	dec d			
	ld a,d
	ld (NumAleatorio),a
ret

Validar:
	ld hl,NumerosSorteados+13
	ld a,(NumAleatorio)  
	cpdr 
	jp z,SortearDeNovo
ret

GuardarPosicao:
	ld a,(NumAleatorio)
	ld (hl),a 
ret 

ImprimirPosicao:
	ld a,(NumAleatorio)
	call PrintChar
ret

Frase:
	db '1','2','3','4','5','6','7','8','9','0','1','2','3','4','5'
NumerosSorteados:
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0