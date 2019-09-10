; ========================================================================================
; Pegar uma frase de no minimo 2 caracteres e no maximo 14 caracteres
; ========================================================================================
; Receber a mensagem na area de memoria frase => (PegarMensagem)
; Validar o numero de caracteres durante a digitacao => (ValidaDuasLetras)
; Guardar o tamanho da frase digitada => (TamanhoFrase)
; Imprimir a mensagem vindo da memoria para teste => (ImprimirMensagem)
; ========================================================================================
; ========================================================================================
; BIOS
; ========================================================================================
TXT_OUTPUT	equ &BB5A	; Funcao da bios que imprime um caracter
KM_WAIT_CHAR	equ &BB06 	; Funcao da bios que aguarda uma entrada

; ========================================================================================
; VARIAVEIS
; ========================================================================================
TamanhoFrase 	equ &9000	; Variavel => contar o tamanho da entrada

; ========================================================================================
; INICIO PROGRAMA
; ========================================================================================
org &8000
	call LimpaMem		; Limpa a memoria a cada execucao
	call PegarFrase		; Obtem a mensagem do usuario
	call ImprimirFrase   	; Imprime a mensagem entrada
ret

PegarFrase:
	call NovaLinha		; Pula uma Linha
	ld hl,MsgUsuario1	; Carrega a primeira Mensagem para o usuario
	call PrintString	; Imprime a mensagem
	ld hl,Frase		; Carrega o endereco da frase
	call LimpaString	; Limpar a Frase
	ld hl,Frase		; Carrega o endereco da frase
	ld b,0			; Zera o contador de letras
LoopFrase:
	call KM_WAIT_CHAR	; ler um caracter
	ld (hl),a		; guarda o ascii desse caracter
	call TXT_OUTPUT		; imprime o caracter
	inc hl			; proximo endereco
	inc b			; aumenta o contador de letras
	cp 13			; compara o carcter entrado com o ENTER(13)				
	jp z,ValidaDuasLetras	; se a frase terminou por enter 
	ld a,b			; prepara o contador para comparar
	ld (TamanhoFrase),a	; guarda o tamanho da frase digitada
	cp 14			; compara o contador com 14
	ret z			; se A-14 = 0 vc ja digitou 14 letras
	jp LoopFrase		; pega o proximo
ValidaDuasLetras:		
	ld a,(TamanhoFrase)	; prepara o contador para comparar
	cp 2			; compara com 2 letras
	ret nc			; se a >= 2 esta ok, retorna
	call LimpaString	; senao limpa a string
jp PegarFrase			; e pega a mensagem novamente

ImprimirFrase:			; vamos imprimir a mensagem da memoria
	call Novalinha		; Pula uma Linha
	ld hl,MsgUsuario2	; Carrega a segunda mensagem para o usuario
	call PrintString	; Imprime a mensagem
	ld hl,Frase		; Carrega a frase
	call PrintString	; Imprime a frase
ret

; =========================================================================================
; FUNCOES GERAIS
; =========================================================================================

; =========================================================================================
; Inicializar as variaveis com zero
; Nao tem parametros
; Altera => A,HL,(TamanhoFrase),(Frase)
; =========================================================================================
LimpaMem:
	ld a, 0				; Zera Numericos
	ld (TamanhoFrase),a
	ld hl,Frase 			; Limpa Strings
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
; Altera => A
; ========================================================================================
NovaLinha:
	ld a, 13
	call TXT_OUTPUT
	ld a, 10 
	call TXT_OUTPUT
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
	call TXT_OUTPUT
	inc hl
	jp PrintString	
EndString:
ret
; ========================================================================================

;=========================================================================================
; FIM DAS FUNCOES GERAIS
;=========================================================================================

;=========================================================================================
; STRINGS
;=========================================================================================
MsgUsuario1:
	db "Entre sua mensagem:",13
MsgUsuario2:
	db "Voce Digitou:",13
Frase:
	db 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,13
