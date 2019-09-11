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
ContPosicao		equ &9009	; Variavel => Conta a posicao a ser testada
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
;=========================================================================================
; INICIO DAS FUNCOES DO PROGRAMA
;=========================================================================================
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
	ld b,a
	cp 0
	jp z,AchouTeste
AcharPosicaoTeste:
	inc hl
	inc a
	cp b
	jp z,AchouTeste
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
	ld a,(ContErros)
	call PrintChar
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
; ========================================================================================


; =========================================================================================
; FIM DAS FUNCOES GERAIS
; =========================================================================================
; =========================================================================================
; STRINGS
; =========================================================================================
MsgUsuario1:
	db "Entre um caracter:",13
MsgUsuario2:
	db "Esta Correto!",13
MsgUsuario3:
	db "Esta Errado.",13
MsgUsuario4:
	db "Contador de erro:",13
Frase:
	db "1234567890",13
