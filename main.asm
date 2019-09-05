;=========================================================================================
; Criptologic para MSX 
; Versao 1.0 
; Manoel Neto 2019-08-30
;=========================================================================================
WaitChar	equ &BB06 	; funcao da bios que aguarda uma entrada
PrintChar	equ &BB5A	; funcao que imprime um caracter
TamanhoFrase 	equ &9000	; Variavel => contar o tamanho da entrada

org &8000
	call PegarMensagem	; obtem a mensagem do usuario
	call NovaLinha		; pula uma linha
ret

;=================================== SUBFUNCOES ==========================================

PegarMensagem:
	call LimpaFrase		; limpa a string a cada execucao
	ld hl,Frase		; carrega o endereco da frase
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
	call LimpaFrase		; senao limpa a string
jp LoopMensagem			; e pega a mensagem novamente


;================================== FUNCOES GERAIS =======================================

NovaLinha:
	ld a, 13
	call PrintChar
	ld a, 10 
	call PrintChar
ret

LimpaFrase:
	ld hl,Frase 		; carrega o endereco de memoria da frase
	ld c,0			; carrega o contador do loop
InicioLimpeza:	
	ld (hl),32		; bota um espaco na posicao
	inc hl			; prepara proxima posicao
	ld a,c			; bota o contador no acumulador
	cp 14			; testa se ja limpou 14 letras
	inc c			; incrementa contador do loop
	jp z,FimLimpeza		; se sim termina a limpeza
	jp InicioLimpeza	; senao limpa a proxima posicao
FimLimpeza:
	ld hl,Frase		; prepara HL com o endereco da frase
	ld b,0			; zera o contador de letras
ret


;====================================== STRINGS =========================================
Frase:
	db 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,255
