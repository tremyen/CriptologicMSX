;=========================================================================================
; Sortear 14 numeros aleatorios entre 1 e 15 
; Jogar o resultado para a variavel NumAleatorio =>(9001)
; Validar se esse numero ja foi sorteado
; Jogar o resultado para a matriz de numeros sorteados =>(NumerosSorteados)
; Converter o numero em seu codigo Hexadeciaml =>(&9002)
; Imprimir o char convertido
; Fazer 14 lancamentos para teste dos limites 
;=========================================================================================
PrintChar		equ &BB5A	; Funcao que imprime um caracter
TamanhoFrase 		equ &9000	; Variavel => Tamanho da entrada Jog 1
NumAleatorio 		equ &9001	; Variavel => Numero sorteado
CharConvertido 		equ &9002	; Variavel => Caracter Convertido
NumSorteios 		equ &9003	; Variavel => Numero de sorteios realizados

org &8000
	ld a,0
	ld (NumSorteios),a		; Primeiro sorteio
	ld a,14				; serao 14 sorteios sem repeticao
	ld (TamanhoFrase),a		; para nosso teste a frase tem 14 letras

SortearDeNovo:
	call SortearNumero		; Sorteei o numero em NumAleatorio
	jp ValidarJaFoi			; Valida se ja foi sorteado
ValidadoJaFoi:
	call GravarNaMatriz		; Grava o sorteio na matriz
	call ConvNumChar 		; Converte o numero em digito 1-F
	call ImprimeChar		; Imprime o caracter
	call ImprimeEspaco		; Imprime um espaco
	ld a,(TamanhoFrase)		; carrga o contador de sorteios
	ld c,a				; so irei sortear de acordo com a entrada
	ld a,(NumSorteios)		; Pega o numero de sorteios
	inc a				; Aumenta numero de sorteios
	cp c				; testa se eh ultimo sorteio
	jp z,Fim			; Acabou
	ld (NumSorteios),a		; Grava o numero de sorteios
	jp SortearDeNovo		; faz de novo
:Fim
ret

SortearNumero:	
	ld a,r				; registrador r fornece um aleatorio entre 1 e 128
	ld d,0				; contador de subtracao sucessivas
DivPor9:
	sub 9 				; comeca a divisao por nove
	inc d				; aumenta o acumulador
	jr nc, DivPor9     		; repete enquanto nao tem "vai um"
	dec d				; elimina o resto
	ld a,d				; prepara a comparacao
	cp 0				; verifica se o numero sorteado foi zero
	jp nz,GravaAleatorio		; se nao foi grava o numero
	ld a,15				; o zero sera tratado como 15
GravaAleatorio:
	ld (NumAleatorio),a		; grava na variavel
ret

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
	ld a,(TamanhoFrase)		; pega o tamnaho da entrada 	
	ld c,a				; prepara parte baixa do loop de CPDR 
	ld b,0				; prepara parte alta do loop de CPDR	
	ld a,(NumAleatorio)  		; pega o numero aleatorio para a pesquisa na matriz
	cpdr 				; procura a matriz ate achar A
	jp z,SortearDeNovo		; Achou! Precisamos sortear de novo!
	jp ValidadoJaFoi		; Nao achou, podemos continuar.

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
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0