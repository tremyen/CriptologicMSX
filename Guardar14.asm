; ============================================================================
; Sortear 14 numeros aleatorios entre 1 e 14 sem repeticao
; ============================================================================
WaitChar		equ &BB06
PrintChar		equ &BB5A
NumAleatorio 		equ &B110
ContadorSorteios	equ &B111
CharGravar		equ &B112
TamanhoFrase		equ &B113

org &8000
	ld a,15
	ld (TamanhoFrase),a
	ld a,1	
	ld (ContadorSorteios),a	
SortearDenovo:
	ld a,(ContadorSorteios)	
	call SortearNumero
	call Validar
	call GuardarPosicao
	call Embaralhar
	ld a,(TamanhoFrase)
	ld b,a
	ld a,(ContadorSorteios)	
	cp b
	jp z,Fim
	inc a
	ld (ContadorSorteios),a
	jp SortearDenovo
Fim: 
	call ImpEmbaralhada
	call NovaLinha
	call ImpFrase
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
	cp 0
	jp nz,GravaAleatorio
	ld a,15
GravaAleatorio:
	ld (NumAleatorio),a
ret

Validar:
	ld a,(TamanhoFrase)
	ld c,a
	ld b,0
	ld hl,NumerosSorteados+14
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

ImpFrase:
	ld b,1
	ld hl,Frase
	ld a,(TamanhoFrase)
	ld c,a
ProxCharFrase:
	ld a,(hl) 
	call PrintChar
	inc hl
	inc b
	ld a,b
	cp c
	ret z
	jp ProxCharFrase

ImpEmbaralhada:
	ld b,1
	ld hl,FraseEmbaralhada
	ld a,(TamanhoFrase)
	ld c,a
ProxCharEmb:
	ld a,(hl) 
	call PrintChar
	inc hl
	inc b
	ld a,b
	cp c
	ret z
	jp ProxCharEmb

NovaLinha:
	ld a, 13
	call PrintChar
	ld a, 10 
	call PrintChar
ret
	
Frase:
	db '1','2','3','4','5','6','7','8','9','A','B','C','D','E','F',255
FraseEmbaralhada:
	db 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,255
NumerosSorteados:
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0