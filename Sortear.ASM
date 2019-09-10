;=========================================================================================
; Sortear X numeros aleatorios entre 1 e N 
; X deve ser igual ao tamanho da frase do jogador 1
; N deve ser igual ao tamanho da frase do jogador 1
; Validar se o numero sorteado nao eh maior que N => (ValidarMaiorN)
; Validar se o numero sorteado ja foi sorteado => (ValidarJaFoi)
; Jogar o resultado para a variavel NumAleatorio =>(9001)
; Jogar o resultado para a matriz de numeros sorteados =>(NumerosSorteados)
; Converter o numero em seu codigo Hexadeciaml =>(&9002)
; Imprimir o char convertido => ImprimeChar
;=========================================================================================
; ========================================================================================
; BIOS
; ========================================================================================
PrintChar		equ &BB5A	; Funcao que imprime um caracter

; ========================================================================================
; VARIAVEIS
; ========================================================================================
TamanhoFrase 		equ &9000	; Variavel => Tamanho da entrada Jog 1
NumAleatorio 		equ &9001	; Variavel => Numero sorteado
CharConvertido 		equ &9002	; Variavel => Caracter Convertido
NumSorteios 		equ &9003	; Variavel => Numero de sorteios realizados
DivisorIdeal 		equ &9004	; Variavel => Divisor ideal de acordo com a frase

; ========================================================================================
; INICIO PROGRAMA
; ========================================================================================
org &8000
	ld a,0
	ld (NumSorteios),a		; Primeiro sorteio
	ld a,5				; Tamanho da frase do jogador 1
	ld (TamanhoFrase),a		; 
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
	call ImprimeChar		; Imprime o caracter
	call ImprimeEspaco		; Imprime um espaco
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
	ld hl,NumerosSorteados		; pega o endereco da matriz	
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
	ld hl,NumerosSorteados
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

ConvNumChar:
	ld a,(NumAleatorio)
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

ImprimeChar:
	ld a,(CharConvertido)
	call PrintChar
ret

ImprimeEspaco:
	ld a, ' '
	call PrintChar
ret

NumerosSorteados:
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,255