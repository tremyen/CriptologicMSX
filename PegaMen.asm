; ============================================================================
; Pegar uma mensagem de no minimo 2 caracteres e no maximo 14
; Receber a mensagem
; Validar o numero de caracteres durante a digitacao
; Imprimir a mensagem vindo da memoria para teste
;=============================================================================
WaitChar	equ &BB06 	; funcao da bios que aguarda uma entrada
PrintChar	equ &BB5A	; funcao da bios que imprime um caracter
TamanhoFrase 	equ &9000	; Variavel para contar o tamanho da entrada

org &8000
	call PegarMensagem	; Obtem a mensagem do usuario
	call Novalinha		; Pula uma Linha
	call ImprimirMensagem   ; Imprime a mensagem entrada
ret

PegarMensagem:
	call LimpaString	; limpa a string a cada execucao
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
	call LimpaString	; senao limpa a string
jp LoopMensagem			; e pega a mensagem novamente

ImprimirMensagem:		; vamos imprimir a mensagem da memoria
	ld b,0			; contador de letras	
	ld hl,Frase		; carrega o endereco da frase
LoopImprime:
	ld a,(hl)		; pega o caracter no endereco
	call PrintChar		; imprime
	inc hl			; pega proximo endereco
	inc b			; aumenta o contador de letras
	ld a,(TamanhoFrase)	; pega o tamnho da frase
	ld c,a			; prepara para a comparacao
	ld a,b			; prepara para comparacao
	cp c			; compara a com c
	ret z			; se sao iguais a string acabou
	jp LoopImprime

LimpaString:
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

NovaLinha:
	ld a, 13
	call PrintChar
	ld a, 10 
	call PrintChar
ret
	

Frase:
	db 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
