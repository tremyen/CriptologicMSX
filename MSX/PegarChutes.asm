; =========================================================================================
; Pegar os chutes do jogador 2
; Pegar chute e gravar => (CaracterTestar)
; Testar se o caracter esta na posicao atual (TestarCorreto)
; Gravar letra na frase embaralhada
; =========================================================================================
; =========================================================================================
; BIOS
; =========================================================================================
WaitChar		equ &BB06 	; Funcao => Aguarda uma entrada
PrintChar		equ &BB5A	; Funcao => Imprime um caracter
; =========================================================================================
; VARIAVEIS
; =========================================================================================
TamanhoFrase 		equ &9000	; Variavel => Tamanho da entrada Jog 1
CaracterTestar		equ &9008	; Variavel => Guarda o caracter para testar
ContTeste		equ &9009	; Variavel => Conta o teste atual
ContErros		equ &900A 	; Variavel => Conta os erros (Nao e 9010)!		
; =========================================================================================
; INICIO DO PROGRAMA
; =========================================================================================
Org &8000
PegarChuteJogador:
	ld a,10
	ld (TamanhoFrase),a
        ld a,0
	ld (ContTeste),a
	ld (ContErros),a
LoopPegaChar:
	call PegarEntrada
	jp TestarCorreto
EstaCorreto:
	ld hl,MsgUsuario2
	call PrintString
	call NovaLinha	
	ld a,(TamanhoFrase)
	dec a
	ld b,a
	ld a,(ContTeste)
	cp b
	jp z,Acertou
	inc a
	ld (ContTeste),a
	jp LoopPegaChar	
Acertou:
	call ImprimirErros
ret
; =========================================================================================
; FIM DO PROGRAMA
; =========================================================================================
; =========================================================================================
; INICIO DAS FUNCOES DO PROGRAMA
; =========================================================================================
PegarEntrada:
	ld hl,MsgUsuario1
	call PrintString
	call WaitChar
	ld (CaracterTestar),a
	call NovaLinha
ret

TestarCorreto:
	ld hl,Frase	
	ld a,(ContTeste)			; Conta o teste
AcharPosicaoTeste:
	cp 0
	jp z,AchouTeste
	inc hl
	dec a					; proximo teste
	jp AcharPosicaoTeste	
AchouTeste:
	ld a,(hl)
	ld b,a
	ld a,(CaracterTestar)
	cp b
	jp z,EstaCorreto	
	ld a,(ContErros)
	inc a
	ld (ContErros),a
	ld hl,MsgUsuario3
	call PrintString
	call Novalinha 
	jp LoopPegaChar
ImprimirErros:
	ld hl,MsgUsuario4
	call PrintString
	call Novalinha
	ld hl,MsgUsuario5
	call PrintString
	ld a,(ContErros)
	call PrintNumber
	call Novalinha
ret
	
; =========================================================================================
; FIM DAS FUNCOES DO PROGRAMA
; =========================================================================================
; =========================================================================================
; INICIO DAS FUNCOES GERAIS
; =========================================================================================
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

; ========================================================================================
; Imprime um Numero
; A => Numero a ser impresso (8 bits, 255)
; Altera => A,HL,D
; ========================================================================================
PrintNumber:
	ld hl,Centenas
	ld (hl),&00
	ld hl,Dezenas
	ld (hl),&00
	ld hl,Unidades
	ld (hl),&00
ContaCentenas:
	ld d,&64
	ld hl,Centenas
ProximaCentena:
	sub d
	jr c,ContarDezenas
	inc (hl)
jr ProximaCentena

ContarDezenas:
	add d
	ld d,&0a
	ld hl,Dezenas
ProximaDezena:
	sub d
	jr c,ContaUnidades
	inc (hl)
jr ProximaDezena

ContaUnidades:
	add d
	ld (Unidades),a
	ld d,0

ImprimeCentenas:
	ld a,(Centenas)
	cp &00
	jr z,ImprimeDezenas
	add a,&30		
	call PrintChar
	ld d,1
ImprimeDezenas:
	ld a,(Dezenas)
	add d
	cp &00
	jr z,ImprimeUnidades
	sub d
	ld d,1
	add a,&30		
	call PrintChar
ImprimeUnidades:
	ld a,(Unidades)
	add a,&30		
	call PrintChar
ret

; ========================================================================================
; Imprime uma Nova linha
; Nao usa parametros
; Altera => A
; ========================================================================================
NovaLinha:
	ld a, 13
	call PrintChar
	ld a, 10 
	call PrintChar
ret

; =========================================================================================
; FIM DAS FUNCOES GERAIS
; =========================================================================================

; =========================================================================================
; NUMEROS
; =========================================================================================
Centenas:
	defb &00
Dezenas:
	defb &00
Unidades:
	defb &00

; =========================================================================================
; STRINGS
; =========================================================================================
MsgUsuario4:
	db "Entre um caracter:",13
MsgUsuario5:
	db "Esta Correto!",13
MsgUsuario6:
	db "Esta Errado.",13
MsgUsuario7:
	db "Parabens! Acertou tudo!",13
MsgUsuario8:
	db "Erros:",13
Frase:
	db "1234567890",13