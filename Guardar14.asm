; sortear 14 numeros aleatorios entre 1 e 14 sem repeticao
WaitChar		equ &BB06
PrintChar		equ &BB5A
NumAleatorio 		equ &9000
ContadorSorteios	equ &9001
CharGravar		equ &9002

org &8000
	ld a,1
	ld (ContadorSorteios),a
SortearDenovo:
	ld a,(ContadorSorteios)	
	call SortearNumero
	call Validar
	call GuardarPosicao
	call Embaralhar
	ld a,(ContadorSorteios)	
	cp 15
	jp z,Fim
	inc a
	ld (ContadorSorteios),a
	jp SortearDenovo
Fim: 
	call Imprimir
ret

SortearNumero:	
	ld a,r			
	ld d,0
DivPor9:
	sub 9 				
	inc d				
	jr nc, DivPor9     
	dec d			
	ld a,d
	ld (NumAleatorio),a
ret

Validar:
	ld c,d
	ld b,0
	ld hl,NumerosSorteados+13
	ld a,(NumAleatorio)  
	cpdr 
	jp z,SortearDeNovo
ret

GuardarPosicao:
	ld hl,NumerosSorteados 
	ld a,(ContadorSorteios)
	cp 1
	jp z,Achou
Procura:
	inc hl
	dec a
	cp 1
	jp z,Achou
	jp Procura
Achou:
	ld a,(NumAleatorio)
	ld (hl),a	
ret 

Embaralhar:
	ld hl,Frase
	ld a,(NumAleatorio)
	cp 1
	jp z,AchouPosPegar
ProcPosPegar:
	inc hl
	dec a
	cp 1
	jp z,AchouPosPegar
	jp ProcPosPegar:
AchouPosPegar:
	ld a,(hl)
	ld (CharGravar),a
Gravar:
	ld hl,FraseEmbaralhada
	ld a,(ContadorSorteios)
	cp 1
	jp z,AchouPosGravar
ProcPosGravar:
	inc hl
	dec a
	cp 1
	jp z,AchouPosGravar
	jp ProcPosGravar
AchouPosGravar:
	ld a,(CharGravar)
	ld (hl),a
ret 

Imprimir:
	ld b,1
	ld hl,FraseEmbaralhada
	ld a,(hl) 
ProxChar:
	call PrintChar
	inc hl
	inc b
	ld a,b
	cp 15
	jp z,Imprimiu
	jp ProxChar
Imprimiu:
ret
	
Frase:
	db '1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
FraseEmbaralhada:
	db 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
NumerosSorteados:
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0