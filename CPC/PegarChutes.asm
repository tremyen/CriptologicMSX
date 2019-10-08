; =========================================================================================
; Pegar os chutes do jogador 2
; Pegar chute e gravar => (CaracterTestar)
; Testar se o caracter esta na posicao atual (TestarCorreto)
; Gravar letra na frase embaralhada
; =========================================================================================
read "Bios.asm"
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
        ld a,0
	ld (ContTeste),a
	ld (ContErros),a
LoopPegaChar:
	call PegarEntrada
	jp TestarCorreto
EstaCorreto:
	ld hl,MsgUsuario5
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

PegarEntrada:
	ld hl,MsgUsuario4
	call PrintString
	call KM_WAIT_CHAR
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
	ld hl,MsgUsuario6
	call PrintString
	call Novalinha
	jp LoopPegaChar
ImprimirErros:
	ld hl,MsgUsuario7
	call PrintString
	call Novalinha
	ld hl,MsgUsuario8
	call PrintString
	ld a,(ContErros)
	call PrintNumber
	call Novalinha
ret
; =========================================================================================
; FIM DO PROGRAMA
; =========================================================================================
read "Library.asm"
	


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