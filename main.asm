;==========================================================================
; Criptologic para MSX 
; Versao 1.0 
; Manoel Neto 2019-08-30
;==========================================================================
WaitChar	equ &BB06 	; funcao da bios que aguarda uma entrada
PrintChar	equ &BB5A	; funcao que imprime um caracter
NumAleatorio 	equ &9000	; Variavel para o numero sorteado
SorteioAtual 	equ &9001	; Variavel para contar o sorteio
TamanhoFrase 	equ &9002	; Variavel para contar o tamanho da entrada
CharDigitado	equ &9003	; Variavel para Caracter digitado

org &8000
	call GetMsg 		; obtem a mensagem do usuario
	call NovaLinha		; pula uma linha
	call ZoaMSG		; bagunca a mensagem
	call ImprimeBagunca	; imprime a mensagem baguncada	
ret

GetMsg:
	call LimpaString	; limpa a string a cada execucao
	ld hl,Frase		; carrega o endereco de memoria onde
				; a frase sera armazenada
	ld b,0			; zera o contador de letras
loopGM:
	call WaitChar		; chama rotina da bios para ler um 
				; caracter
	ld (hl),a		; guarda o ascii desse caracter no 
				; enrececo hl
	call PrintChar		; chama a rotina da bios que imprime um 
				; caracter
	inc hl			; adiciona um ao endereco no registrador 
				; hl, para guardar o proximo caracter na 
				; proxima posicao de memoria
	inc b			; aumenta o contador de letras
	cp 13			; compara o carcter entrado com o ENTER(13)
				; se o usuario apertou enter, a frase acabou	
	jp z,ValidaDuasLetras	; se a frase terminou por enter precisamos 
				; validar se temos pelo menos duas letras
	ld a,b			; prepara o contador para comparar
	ld (TamanhoFrase),a	; guarda o tamanho da frase digitada
	cp 14			; compara o contador com 14
	ret z			; se A-14 = 0 vc ja digitou 14 letras
	jp loopGM

ValidaDuasLetras:		
	ld a,b			; prepara o contador para comparar
	ld (TamanhoFrase),a	; guarda o tamanho da frase digitada
	cp 3			; compara com 3, pois o enter eh um caracter
	ret nc			; se a>=2 esta ok, retorna
	call LimpaString	; senao limpa a string
jp loopGM			; volta para receber a string novamente

ZoaMSG:
	ld b,1			; inicia o contador de sorteio
SorteiaPosicao:
	ld a,b		
	ld (SorteioAtual), a	; guarda em que sorteio estamos
	call SorteiaAleatorio	; sorteia um numero entre 1 e 14
	call ValidarJaFoi	; testa se esse numero ja foi sorteado
	call GuardarPosicao	; guarda esse numero na matriz de sorteios
	inc b			; aumenta o contador do sorteio
	ld a,b		
	cp (TamanhoFrase)	; testa se eh o ultimo sorteio
	ret z			; se sim terminou de embaralhar
jp SorteiaPosicao

SorteiaAleatorio:	
	ld a,r			; chama registrador r (retorna de 1 a 128)
	ld d,0			; prepara o contador de divisao
DividePorNove:
	sub 9 			; estamos dividindo por 9 	
	inc d			; aumenta contador	
	jr nc,DividePorNove     ; nao acabou, subtrai de novo
	dec d			; elimina o resto
	ld a,d			; guarda o numero aleatorio
	ld (NumAleatorio),a	; guarda o numero aleatorio
ret

ValidarJaFoi:
	ld c,d			; CPDR usa BC para controlar seu loop
	ld b,0			; precismos preparar esses regs
	ld hl,NumSorteados+13	; pega a ultima posicao da matrix de sort.
	ld a,(NumAleatorio)  	; prepara a comparacao
	cpdr 			; compara,decrementa e repete
	jp z,ZoaMSG		; se encontrou repete o processo
ret

GuardarPosicao:
	ld hl,NumSorteados 	; pega o endereco da matriz de sorteio
	ld a,(SorteioAtual)	; pega a posicao do sorteio
	cp 1			; testa se eh o primeiro sorteio
	jp z,AchouEndereco	; Ja temos o endereco
TentaDenovo:
	inc hl			; tenta o proximo
	dec a			; controla o loop
	cp 0			; testa se ja estamos na posicao
	jp z,AchouEndereco	; esta eh a posicao
	jp TentaDenovo		; tente ate achar a posicao
AchouEndereco:
	ld a,(NumAleatorio)	; pega o numero sorteado 
	ld (hl),a		; hl agora tem a posicao correta da matriz
Embaralha:
	ld hl,Frase		; pega o endereco da frase 
	ld a,(NumAleatorio)	; pega o numero sorteado
	cp 1			; se for a primeira posicao ja salva
	jp z,SalvarChar
ProcuraPosicao:
	inc hl			; testa a proxima
	dec a			; controla o loop
	cp 0			; esta eh a posicao
	jp z,SalvarChar		; achou a posicao, pegue o caracter
	jp ProcuraPosicao	; procura ate encontrar
SalvarChar:
	ld a,(hl)		; nesse momento hl tem a posicao do char.
	ld (CharDigitado),a	; salvamos o char para usar depois
	ld hl,FraseEmbaralhada	; aqui salvaremos a frase zoada
	ld a,(SorteioAtual)	; grava o char na posicao do sorteio
	cp 1			; se eh o primeiro sorteio grava em 1
	jp z,EscreveChar	; escreve na frase embaralhada
PosicaoEmbaralhada:
	inc hl			; testa a proxima
	dec a 			; controla o loop
	cp 0			; esta eh a posicao
	jp z,EscreveChar	; achou a posicao, pegue o caracter
	jp PosicaoEmbaralhada	; procura ate encontrar
EscreveChar:
	ld a,(CharDigitado)	; pega o char digitado
	ld (hl),a		; escreve um char. da frase embaralhada
ret

ImprimeBagunca:
	ld hl,FraseEmbaralhada
	ld b,0
ProximoCaracter:
	ld a,(hl)
	call PrintChar
	inc hl
	inc b
	ld a,b
	cp 14
	ret z
	jp ProximoCaracter
ret 

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

NumSorteados:
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

