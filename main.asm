;=========================================================================================
; Criptologic para MSX 
; Versao 1.0 
; Manoel Neto 2019-08-30
;=========================================================================================
WaitChar		equ &BB06 	; Funcao => Aguarda uma entrada
PrintChar		equ &BB5A	; Funcao => Imprime um caracter
TamanhoFrase 		equ &9000	; Variavel => Tamanho da entrada Jog 1
NumAleatorio 		equ &9001	; Variavel => Numero sorteado
CharConvertido 		equ &9002	; Variavel => Caracter Convertido
NumSorteios 		equ &9003	; Variavel => Numero de sorteios realizados

;=========================================================================================
; INICIO DO PROGRAMA
;=========================================================================================
org &8000
	call LimpaMem		; Limpa a memoria a cada execucao
	ld hl,MsgUsuario1	; Carrega a primeira Mensagem para o usuario
	call PrintString	; Imprime a mensagem
	ld hl,Frase		; carrega o endereco da frase
	call PegarMensagem	; Obtem a mensagem do usuario
	call NovaLinha		; Pula uma linha
	ld hl,MsgUsuario2	; Carrega a segunda mensagem para o usuario
	call PrintString	; Imprime a mensagem
	ld hl,Frase		; Carrega a frase digitada
	call PrintString	; Imprime a frase
	call NovaLinha		; Pula uma linha
ret
;=========================================================================================
; FIM DO PROGRAMA
;=========================================================================================

;=========================================================================================
; INICIO DAS FUNCOES DO PROGRAMA
;=========================================================================================

; =========================================================================================
; Inicializar as variaveis com zero
; Limpar a Matriz
; Limpar as strings
; Altera => A,HL
; =========================================================================================
LimpaMem:
	ld a, 0				; Zera Numericos
	ld (TamanhoFrase),a
	ld (NumAleatorio),a
	ld (NumSorteios),a
	ld hl,NumerosSorteados		; Zera Matriz
	call ZerarMatriz		
	ld a,' ' 			; Limpa Caracteres
	ld (CharConvertido), a		
	ld hl,Frase 			; Limpa Strings
	call LimpaString		
ret

; ============================================================================
; Pegar uma mensagem de no minimo 2 caracteres e no maximo 14
; Receber a mensagem
; Validar o numero de caracteres durante a digitacao
; HL => Endereco da Frase
; Altera => HL,B,A
;=============================================================================
PegarMensagem:
	call LimpaString	; limpa a string a cada execucao
	ld hl,Frase		; Pegar a frase limpa 
	ld b,0			; zera o contador de letras
LoopMensagem:
	call WaitChar		; ler um caracter
	ld (hl),a		; guarda o ascii desse caracter
	call PrintChar		; imprime o caracter
	inc hl			; proximo endereco
	inc b			; aumenta o contador de letras
	cp 13			; compara o carcter entrado com o ENTER(13)				
	jp z,ValidaDuasLetras	; se a frase terminou por enter 
	ld a,b			; prepara o contador para comparar
	ld (TamanhoFrase),a	; guarda o tamanho da frase digitada
	cp 14			; compara o contador com 14
	ret z			; se A-14 = 0 vc ja digitou 14 letras
	jp LoopMensagem		; pega o proximo
ValidaDuasLetras:		
	ld a,(TamanhoFrase)	; prepara o contador para comparar
	cp 3			; compara com 3, pois o enter eh um caracter
	ret nc			; se a >= 2 esta ok, retorna	
jp PegarMensagem	


;=========================================================================================
; FIM DAS FUNCOES DO PROGRAMA
;=========================================================================================

;=========================================================================================
; INICIO DAS FUNCOES GERAIS
;=========================================================================================

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
; Zerar uma Matriz terminada em 255
; HL => Endereco da Matriz
; ========================================================================================
ZerarMatriz:
	ld a,(hl)
	cp 255
	jp z,ZerouMatriz
	ld a,0
	ld (hl),a
	inc hl
	jp ZerarMatriz
ZerouMatriz:
ret

; ========================================================================================

;=========================================================================================
; FIM DAS FUNCOES GERAIS
;=========================================================================================

;=========================================================================================
; MATRIZES
;=========================================================================================
NumerosSorteados:
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,255

;=========================================================================================
; STRINGS
;=========================================================================================
MsgUsuario1:
	db "Entre sua mensagem: ",13
MsgUsuario2:
	db "Voce Digitou: ",13
Frase:
	db 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,13
