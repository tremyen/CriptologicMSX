;=========================================================================================
; Embaralhar Frase
; Pegar o numero sorteado 
; Pegar letra relativa ao numero sorteado
; Gravar letra na frase embaralhada
;=========================================================================================
; ========================================================================================
; BIOS
; ========================================================================================
PrintChar	equ &BB5A		

; ========================================================================================
; VARIAVEIS
; ========================================================================================
TamanhoFrase 		equ &9000	; Variavel => Tamanho da entrada Jog 1
PosSorteada		equ &9005	; Variavel => PosicaoSorteada
LetraAtual		equ &9006	; Variavel => Letra na posicao sorteada
ContEmbaralha		equ &9007	; Variavel => Contador de embaralhamento

org &8000
	call LimpaMem
	ld a,14
	ld (TamanhoFrase),a
	ld a,0				; prepara primeira passada
	ld (ContEmbaralha),a		; zera o contador de embaralhamento
GravarProxima:	
	call AcharPosSort		; achar a posicao sorteada 
	call AcharLetra			; acha a letra dessa passada
	call GravarLetra		; gravar a letra dessa passada
	ld a,(TamanhoFrase)
	ld b,a
	ld a,(ContEmbaralha)		
	cp b				; se pegamos todos
	jp z,GravouTudo			; gravamos tudo 
	inc a 				; senao vamos para a proxima
	ld (ContEmbaralha),a		; e guardamos no contador
	jp GravarProxima		; pega a proxima
GravouTudo:
	call NovaLinha			; pula linha
	ld hl,MsgUsuario1
	call PrintString	
	ld hl,Frase			; imprime a frase
	call PrintString	
	call NovaLinha			; pula linha
	ld hl,MsgUsuario2
	call PrintString	
	ld hl,FraseEmbaralhada		; imprime a frase embaralhada
	call PrintString
	call NovaLinha	
ret

AcharPosSort:
	ld a,(ContEmbaralha)
	ld hl,NumerosSorteados
LoopAcharPosSort:
	cp 0
	jp z,AchouPosSort
	dec a
	inc hl
	jp LoopAcharPosSort
AchouPosSort:
	ld a,(hl)
	ld (PosSorteada),a
ret

AcharLetra:
	ld a,(PosSorteada)
	dec a 				; enderecos comecam com 0
	ld hl,Frase
LoopAcharLetra:
	cp 0
	jp z,AchouLetra			
	dec a
	inc hl
	jp LoopAcharLetra
AchouLetra:
	ld a,(hl)
	ld (LetraAtual),a
ret

GravarLetra:
	ld a,(ContEmbaralha)
	ld b,a
	ld a,0
	ld hl,FraseEmbaralhada
LoopGravarLetra:
	cp b
	jp z,AchouPosGravar			
	inc hl
	inc a	
	jp LoopGravarLetra
AchouPosGravar:
	ld a,(LetraAtual)
	ld (hl),a
	inc hl
	ld (hl),13
ret

; =========================================================================================
; Inicializar as variaveis com zero
; Nao usa parametros
; Altera => A,HL,TamanhoFrase,NumAleatorio,NumSorteios,DivisorIdeal,CharConvertido
; =========================================================================================
LimpaMem:
	ld a,0				
	ld (TamanhoFrase),a
	ld (PosSorteada),a
	ld (LetraAtual),a
	ld (ContEmbaralha),a
	ld hl,FraseEmbaralhada
	call LimpaString		
ret

; ========================================================================================
; Limpa uma string terminada em ENTER(13)
; HL => Endereco da string
; Altera => A, HL
; ========================================================================================
LimpaString:
	ld a,(hl)
	cp 13
	jp z,LimpouString
	ld a,' '
	ld (hl),a
	inc hl
	jp LimpaString
LimpouString:
ret

; ========================================================================================
; Imprime uma Nova linha
; Nao usa parametros
; ========================================================================================
NovaLinha:
	ld a, 13
	call PrintChar
	ld a, 10 
	call PrintChar
ret

; ========================================================================================
; Imprime uma string terminada em ENTER(13)
; HL => Endereco da string
; Altera => A,HL
; ========================================================================================
PrintString:
	ld a,(hl)
	cp 13
	jp z,EndString
	call PrintChar
	inc hl
	jp PrintString	
EndString:
ret

;=========================================================================================
; STRINGS
;=========================================================================================	
Frase:
	db "123456789ABCDE",13
FraseEmbaralhada:
	db 32,32,32,32,32,32,32,32,32,32,32,32,32,32,13
NumerosSorteados:
	db 1,7,9,2,5,4,10,11,13,3,6,8,12,14,255
MsgUsuario1:
	db "Frase 1:",13
MsgUsuario2:
	db "Frase 2:",13