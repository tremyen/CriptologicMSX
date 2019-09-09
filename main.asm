;=========================================================================================
; Criptologic para MSX 
; Versao 1.0 
; Manoel Neto 2019-09-09
;=========================================================================================
WaitChar		equ &BB06 	; Funcao => Aguarda uma entrada
PrintChar		equ &BB5A	; Funcao => Imprime um caracter
TamanhoFrase 		equ &9000	; Variavel => Tamanho da entrada Jog 1
NumAleatorio 		equ &9001	; Variavel => Numero sorteado
CharConvertido 		equ &9002	; Variavel => Caracter Convertido
NumSorteios 		equ &9003	; Variavel => Numero de sorteios realizados
DivisorIdeal 		equ &9004	; Variavel => Divisor ideal de acordo com a frase

;=========================================================================================
; INICIO DO PROGRAMA
;=========================================================================================
org &8000
	call LimpaMem		; Limpa a memoria a cada execucao
	ld hl,MsgUsuario1	; Carrega a primeira Mensagem para o usuario
	call PrintString	; Imprime a mensagem
	ld hl,Frase		; Carrega o endereco da frase
	call PegarMensagem	; Obtem a mensagem do usuario
	call NovaLinha		; Pula uma linha
	ld hl,MsgUsuario2	; Carrega a segunda mensagem para o usuario
	call PrintString	; Imprime a mensagem
	ld hl,Frase		; Carrega a frase digitada
	call PrintString	; Imprime a frase
	call SortearNumeros	; Sortear os numeros para embaralhar a frase
	call NovaLinha		; Pula uma linha
	ld hl,MsgUsuario3	; Carrega a terceira mensagem para o usuario
	call PrintString	; imprime a mensagem
	call ImprimeSorteios	; Imprime a mensagem
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
	ld (DivisorIdeal),a
	ld hl,NumSorteados		; Zera Matriz
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
; Sortear numeros aleatorios entre 1 e o tamanho da frase
; Jogar o resultado para a variavel NumAleatorio =>(9001)
; Validar se esse numero ja foi sorteado => (ValidarJaFoi)
; Jogar o resultado para a matriz de numeros sorteados =>(NumerosSorteados)
; Imprimir a matriz de numeros sorteados
; Altera => A,C,D,HL,NumSorteios,NumAleatorio
;=========================================================================================
SortearNumeros:
	ld a,0
	ld (NumSorteios),a		; Primeiro sorteio
	call AcharDivIdeal		; achar o divisor ideal para a entrada do
					; jogador 1
SortearDeNovo:
	call SortearNumero		; Sorteei o numero em NumAleatorio
	jp ValidarMaiorN		; O numero nao pode ser maior que a entrada
ValidadoMaiorN:
	jp ValidarJafoi			; O Numero nao pode se repetir
ValidadoJaFoi:
	call GravarNaMatriz		; Grava o sorteio na matriz
	call ConvNumChar 		; Converte o numero em digito 1-F
	ld a,(TamanhoFrase)		; carrega o contador de sorteios
	ld c,a				; so irei sortear de acordo com a entrada
	ld a,(NumSorteios)		; Pega o numero de sorteios
	inc a				; Aumenta numero de sorteios
	cp c				; testa se eh ultimo sorteio
	jp z,FimSorteio			; Acabou
	ld (NumSorteios),a		; Grava o numero de sorteios
	jp SortearDeNovo		; faz de novo
FimSorteio:
ret

AcharDivIdeal:
	ld a,(TamanhoFrase)		; pegar o tamanho da frase
	ld b,a				; usar o tamanho da frase como divisor			
	ld a,128			; Dividir 128 pelo tamanho da frase
	ld d,0				; contador de subtracao sucessivas
DivPorTamanho:
	sub b 				; comeca a divisao pelo tamanho da frase
	inc d				; aumenta o acumulador
	jr nc, DivPorTamanho   		; repete enquanto nao tem "vai um"
	dec d				; elimina o resto
	ld a,d				; nesse momento D tem o divisior ideal	
	ld (DivisorIdeal),a		; nesse momento A tem o divisior ideal	
ret

SortearNumero:
	ld a,(DivisorIdeal)		; carrega o divisor ideal		
	ld b,a				; carrega o divisor ideal
	ld a,r				; registrador r fornece um aleatorio entre 1 e 128
	ld d,0				; contador de subtracao sucessivas
DividirPorIdeal:
	sub b 				; comeca a divisao pelo divisor ideal
	inc d				; aumenta o acumulador
	jr nc, DividirPorIdeal 		; repete enquanto nao tem "vai um"
	dec d				; elimina o resto
	ld a,d				; prepara gravacao do numero
GravaAleatorio:
	ld (NumAleatorio),a		; grava na variavel
ret

ValidarMaiorN:
	ld a,(TamanhoFrase)
	inc a
	ld b,a
	ld a,(NumAleatorio)
	cp b
	jp ValidadoMaiorN
	jp SortearDeNovo

ValidarJaFoi:
	ld a,(TamanhoFrase)		; pega o tamnaho da entrada 	
	ld hl,NumSorteados		; pega o endereco da matriz	
AcharFimFrase:				; Comeca o loop para chegar no fim da frase	
	cp 0				; se andamos todo o tam. da entrada
	jp z,AcheiFimFrase		; achamos o endereco final da entrada
	inc hl				; proxima posicao
	dec a				; controla se chegamos no fim
	jp AcharFimFrase		; senao continuamos procurando	
AcheiFimFrase:				; nesse momento temos hl apontando para o lugar certo
	ld a,(TamanhoFrase)		; pega o tamanho da entrada 	
	inc a
	ld c,a				; prepara parte baixa do loop de CPDR 
	ld b,0				; prepara parte alta do loop de CPDR	
	ld a,(NumAleatorio)  		; pega o numero aleatorio para a pesquisa na matriz
	cpdr 				; procura a matriz ate achar A
	jp z,SortearDeNovo		; Achou! Precisamos sortear de novo!
	jp ValidadoJaFoi

GravarNaMatriz:
	ld hl,NumSorteados
	ld a,(NumSorteios)
	cp 0
	jp z,AcheiPosMat
AcharPosMat:
	inc hl
	dec a
	cp 0
	jp z,AcheiPosMat
	jp AcharPosMat
AcheiPosMat:
	ld a,(NumAleatorio)
	ld (hl),a
ret

;=========================================================================================
; Imprimir os numeros sorteados 
; Imprimir a matriz de numeros sorteados
; Altera => A,B,HL 
;=========================================================================================
ImprimeSorteios:
	ld a,(TamanhoFrase)		; Pega o tamanho da frase
	ld b,a				; Guarda como contador de loop
	ld hl,NumSorteados		; Inicia com o endereco da matriz
ProxNum:
	ld a,(hl)			; Le o primeiro numero
	call ConvNumChar		; Converte o numero no seu ascii
	call ImprimeChar		; Imprime o caracter convertido
	call ImprimeEspaco		; Imprime um espaco
	dec b				; Incrementa o contador de loop
	ld a,b				; prepara o contador para comparacao
	cp 0				; Testa se e o fim dos sorteios
	jp z,FimImpSorteio		; Finaliza
	inc hl				; Incrementa o ponteiro de endereco
	jp ProxNum			; Pega o proximo	
FimImpSorteio:	
ret	

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

; ========================================================================================
; ConvNumChar
; Converter um numero de 0 a 15 em seu digito hexadecimal
; A => Numero a ser convertido
; ALTERA => A
; ========================================================================================
ConvNumChar:
	cp 0
	jp z,Zero
	cp 1
	jp z,Um
	cp 2
	jp z,Dois
	cp 3
	jp z,Tres
	cp 4
	jp z,Quatro
	cp 5
	jp z,Cinco
	cp 6
	jp z,Seis
	cp 7
	jp z,Sete
	cp 8
	jp z,Oito
	cp 9
	jp z,Nove
	cp 10
	jp z,DezA
	cp 11
	jp z,OnzeB
	cp 12
	jp z,Dozec
	cp 13
	jp z,TrezeD
	cp 14
	jp z,QuatorzeE
	cp 15
	jp z,QuinzeF
	ret
Zero:
	ld a,'0'
	ld (CharConvertido),a
ret
Um:
	ld a,'1'
	ld (CharConvertido),a

ret
Dois:
	ld a,'2'
	ld (CharConvertido),a

ret
Tres:
	ld a,'3'
	ld (CharConvertido),a

ret
Quatro:
	ld a,'4'
	ld (CharConvertido),a

ret
Cinco:
	ld a,'5'
	ld (CharConvertido),a

ret
Seis:
	ld a,'6'
	ld (CharConvertido),a

ret
Sete:
	ld a,'7'
	ld (CharConvertido),a

ret
Oito:
	ld a,'8'
	ld (CharConvertido),a

ret
Nove:
	ld a,'9'
	ld (CharConvertido),a

ret
DezA:
	ld a,'A'
	ld (CharConvertido),a

ret
OnzeB:
	ld a,'B'
	ld (CharConvertido),a

ret
Dozec:
	ld a,'C'
	ld (CharConvertido),a

ret
TrezeD:
	ld a,'D'
	ld (CharConvertido),a

ret
QuatorzeE:
	ld a,'E'
	ld (CharConvertido),a

ret
QuinzeF:
	ld a,'F'
	ld (CharConvertido),a
ret

; ========================================================================================
; Imprime o caracter convertido
; ALTERA => A
; ========================================================================================
ImprimeChar:
	ld a,(CharConvertido)
	call PrintChar
ret
; ========================================================================================

; ========================================================================================
; ImprimeEspaco
; Imprime um espaco
; Sem Parametros
; ALTERA => A
; ========================================================================================
ImprimeEspaco:
	ld a, ' '
	call PrintChar
ret

;=========================================================================================
; FIM DAS FUNCOES GERAIS
;=========================================================================================

;=========================================================================================
; MATRIZES
;=========================================================================================
NumSorteados:
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,255

;=========================================================================================
; STRINGS
;=========================================================================================
MsgUsuario1:
	db "Entre sua mensagem: ",13
MsgUsuario2:
	db "Voce Digitou: ",13
MsgUsuario3:
	db "Ordem para embaralhar: ",13
Frase:
	db 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,13
