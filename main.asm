; ========================================================================================
; Criptologic para Z80
; ========================================================================================
; Versao 0.1 (Prototipo)
; Manoel Neto 2019-09-09
; ========================================================================================
; ========================================================================================
; BIOS
; ========================================================================================
SCR_MODE_CLEAR  equ &BC14	; Funcao => Limpar a tela
KM_WAIT_CHAR	equ &BB06 	; Funcao => Aguarda uma entrada
TXT_OUTPUT	equ &BB5A	; Funcao => Imprime um caracter
; ========================================================================================
; VARIAVEIS
; ========================================================================================
TamanhoFrase	equ &9000	; Variavel => Tamanho da entrada Jog 1
NumAleatorio 	equ &9001	; Variavel => Numero sorteado
CharConvertido	equ &9002	; Variavel => Caracter Convertido
NumSorteios 	equ &9003	; Variavel => Numero de sorteios realizados
DivisorIdeal	equ &9004	; Variavel => Divisor ideal de acordo com a frase
PosSorteada	equ &9005	; Variavel => Posicao Sorteada
LetraAtual	equ &9006	; Variavel => Letra na posicao sorteada
ContEmbaralha	equ &9007	; Variavel => Contador de embaralhamento
CaracterTestar	equ &9008	; Variavel => Guarda o caracter para testar
ContTeste	equ &9009	; Variavel => Conta o teste atual
ContErros	equ &900A 	; Variavel => Conta os erros (Nao e 9010)!
; ========================================================================================
; INICIO DO PROGRAMA
; ========================================================================================
org &8000
	call SCR_MODE_CLEAR	; Limpa a tela
	call LimpaMem		; Limpa a memoria a cada execucao
	call PegarMensagem	; Obtem a mensagem do usuario
	call NovaLinha		; Pula uma linha
	call SortearNumeros	; Sortear os numeros para embaralhar a frase
	call NovaLinha		; Pula uma linha
	call Embaralhar		; Embaralha a frase
	call NovaLinha		; Pula uma linha
	call PegarChuteJogador	; Pegar os chutes do jogador
ret
;=========================================================================================
; INICIO DAS FUNCOES DO PROGRAMA
;=========================================================================================

; ========================================================================================
; Pegar uma mensagem de no minimo 2 caracteres e no maximo 14
; ========================================================================================
; Nao usa parametros
; ========================================================================================
; Altera => HL,B,A
; ========================================================================================
PegarMensagem:
	ld hl,MsgUsuario1	; Carrega a primeira Mensagem para o usuario
	call PrintString	; Imprime a mensagem
	call LimpaString	; limpa a string a cada execucao
	ld hl,Frase		; Pegar a frase limpa
	ld b,0			; zera o contador de letras
LoopMensagem:
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
	jp LoopMensagem		; pega o proximo
ValidaDuasLetras:
	ld a,(TamanhoFrase)	; prepara o contador para comparar
	cp 3			; compara com 3, pois o enter eh um caracter
	ret nc			; se a >= 2 esta ok, retorna
jp PegarMensagem

; ========================================================================================
; Sortear numeros aleatorios entre 1 e o tamanho da frase
; ========================================================================================
; Nao usa parametros
; ========================================================================================
; Altera => A,C,D,HL,NumSorteios,NumAleatorio
; ========================================================================================
SortearNumeros:
	ld a,0
	ld (NumSorteios),a	; Primeiro sorteio
	call AcharDivIdeal	; achar o divisor ideal para a frase
SortearDeNovo:
	call SortearNumero	; Sorteei o numero em NumAleatorio
	jp ValidarMaiorN	; O numero nao pode ser maior que a entrada
ValidadoMaiorN:
	jp ValidarJafoi		; O numero nao pode se repetir
ValidadoJaFoi:
	call GravarNaMatriz	; Grava o sorteio na matriz
	call ConvNumChar 	; Converte o numero em digito 1-F
	ld a,(TamanhoFrase)	; carrega o contador de sorteios
	ld c,a			; so irei sortear de acordo com a entrada
	ld a,(NumSorteios)	; Pega o numero de sorteios
	inc a			; Aumenta numero de sorteios
	cp c			; testa se eh ultimo sorteio
	jp z,FimSorteio		; Acabou
	ld (NumSorteios),a	; Grava o numero de sorteios
	jp SortearDeNovo	; faz de novo
FimSorteio:
	call ImprimeSorteios	; Imprime numeros sorteados
ret

AcharDivIdeal:
	ld a,(TamanhoFrase)	; pegar o tamanho da frase
	ld b,a			; usar o tamanho da frase como divisor
	ld a,128		; Dividir 128 pelo tamanho da frase
	ld d,0			; contador de subtracao sucessivas
DivPorTamanho:
	sub b 			; comeca a divisao pelo tamanho da frase
	inc d			; aumenta o acumulador
	jr nc, DivPorTamanho 	; repete enquanto nao tem "vai um"
	dec d			; elimina o resto
	ld a,d			; nesse momento D tem o divisior ideal
	ld (DivisorIdeal),a	; nesse momento A tem o divisior ideal
ret

SortearNumero:
	ld a,(DivisorIdeal)	; carrega o divisor ideal
	ld b,a			; carrega o divisor ideal
	ld a,r			; registrador r fornece um aleatorio entre 1 e 128
	ld d,0			; contador de subtracao sucessivas
DividirPorIdeal:
	sub b 			; comeca a divisao pelo divisor ideal
	inc d			; aumenta o acumulador
	jr nc,DividirPorIdeal 	; repete enquanto nao tem "vai um"
	dec d			; elimina o resto
	ld a,d			; prepara gravacao do numero
GravaAleatorio:
	ld (NumAleatorio),a	; grava na variavel
ret

ValidarMaiorN:
	ld a,(TamanhoFrase)	; pegar o tamanho da frase
	inc a			; temos de comparar com A <
	ld b,a			; guarda tamanho frase+1
	ld a,(NumAleatorio)	; pega o numero aleatorio para comparacao
	cp b			; A < TamFrase+1 ?
	jp c,ValidadoMaiorN	; A < TamFrase+1 ?
	jp SortearDeNovo
ValidarJaFoi:
	ld a,(TamanhoFrase)	; pega o tamnaho da entrada
	ld hl,NumSorteados	; pega o endereco da matriz
AcharFimFrase:			; Comeca o loop para chegar no fim da frase
	cp 0			; se andamos todo o tam. da entrada
	jp z,AcheiFimFrase	; achamos o endereco final da entrada
	inc hl			; proxima posicao
	dec a			; controla se chegamos no fim
	jp AcharFimFrase	; senao continuamos procurando
AcheiFimFrase:			; nesse momento temos hl apontando para o lugar certo
	ld a,(TamanhoFrase)	; pega o tamanho da entrada
	inc a
	ld c,a			; prepara parte baixa do loop de CPDR
	ld b,0			; prepara parte alta do loop de CPDR
	ld a,(NumAleatorio)  	; pega o numero aleatorio para a pesquisa na matriz
	cpdr 			; procura a matriz ate achar A
	jp z,SortearDeNovo	; Achou! Precisamos sortear de novo!
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

; ========================================================================================
; Embaralhar a Frase
; ========================================================================================
; Nao usa parametros
; ========================================================================================
; Altera => HL,A,B,ContaEmbaralha,PosSorteada,LetraAtual
; ========================================================================================
Embaralhar:
	ld hl,MsgUsuario3	; Carrega a quarta mensagem para o usuario
	call PrintString	; imprime a mensagem
	ld a,0			; prepara primeira passada
	ld (ContEmbaralha),a	; zera o contador de embaralhamento
GravarProxima:
	call AcharPosSort	; achar a posicao sorteada
	call AcharLetra		; acha a letra dessa passada
	call GravarLetra	; gravar a letra dessa passada
	ld a,(TamanhoFrase)
	ld b,a
	ld a,(ContEmbaralha)
	cp b			; se pegamos todos
	jp z,GravouTudo		; gravamos tudo
	inc a 			; senao vamos para a proxima
	ld (ContEmbaralha),a	; e guardamos no contador
	jp GravarProxima	; pega a proxima
GravouTudo:
	call ImprimirFraseEmbaralhada
ret

AcharPosSort:
	ld a,(ContEmbaralha)
	ld hl,NumSorteados
LoopAcharPosSort:
	cp 0
	jp z,AchouPosSort
	dec a
	inc hl
	jp LoopAcharPosSort
AchouPosSort:
	ld a,(hl)
	ld (PosSorteada),a
ret

AcharLetra:
	ld a,(PosSorteada)
	dec a 			; enderecos comecam com 0
	ld hl,Frase
LoopAcharLetra:
	cp 0
	jp z,AchouLetra
	dec a
	inc hl
	jp LoopAcharLetra
AchouLetra:
	ld a,(hl)
	ld (LetraAtual),a
ret

GravarLetra:
	ld a,(ContEmbaralha)
	ld b,a
	ld a,0
	ld hl,FraseEmbaralhada
LoopGravarLetra:
	cp b
	jp z,AchouPosGravar
	inc hl
	inc a
	jp LoopGravarLetra
AchouPosGravar:
	ld a,(LetraAtual)
	ld (hl),a
	inc hl
	ld (hl),13
ret

ImprimirFraseEmbaralhada:
	ld hl,FraseEmbaralhada		; Carrega a frase embaralhada
	call PrintString		; imprime
ret

; ========================================================================================
; Imprimir os numeros sorteados
; ========================================================================================
; Nao usa parametros
; ========================================================================================
; Altera => A,B,HL
; ========================================================================================
ImprimeSorteios:
	ld hl,MsgUsuario2		; Carrega mensagem para o usuario
	call PrintString		; Imprime a mensagem
	ld a,(TamanhoFrase)		; Pega o tamanho da frase
	ld b,a				; Guarda como contador de loop
	ld hl,NumSorteados		; Inicia com o endereco da matriz
ProxNum:
	ld a,(hl)			; Le o primeiro numero
	call ConvNumChar		; Converte o numero no seu ascii
	ld a,(CharConvertido)		; Carrega o caracter convertido
	call TXT_OUTPUT			; Imprime
	ld a, ' '			; Carrega um espaco
	call TXT_OUTPUT			; Imprime um espaco
	dec b				; Incrementa o contador de loop
	ld a,b				; prepara o contador para comparacao
	cp 0				; Testa se e o fim dos sorteios
	jp z,FimImpSorteio		; Imprimiu todos
	inc hl				; Prepara o proximo endereco
	jp ProxNum			; Pega o proximo
FimImpSorteio:
ret

; =========================================================================================
; Pegar os chutes do jogador 2
; =========================================================================================
; Nao usa parametros
; =========================================================================================
; Altera => A,ContTeste,ContErros,HL,B,CaracterTestar
; =========================================================================================
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
; FIM DAS FUNCOES DO PROGRAMA
; =========================================================================================

; =========================================================================================
; INICIO DAS FUNCOES GERAIS
; =========================================================================================

; =========================================================================================
; Limpar a tela
; =========================================================================================
; Nao usa parametros
; =========================================================================================
; Altera => A,HL,TamanhoFrase,NumAleatorio,NumSorteios,DivisorIdeal,PosSorteada,
; 	    LetraAtual,ContEmbaralha,ContTeste,ContErros,NumSorteados,CharConvertido,
;	    CaracterTestar,Frase,FraseEmbaralhada
; =========================================================================================

; =========================================================================================
; Inicializar as variaveis com zero
; =========================================================================================
; Nao usa parametros
; =========================================================================================
; Altera => A,HL,TamanhoFrase,NumAleatorio,NumSorteios,DivisorIdeal,PosSorteada,
; 	    LetraAtual,ContEmbaralha,ContTeste,ContErros,NumSorteados,CharConvertido,
;	    CaracterTestar,Frase,FraseEmbaralhada
; =========================================================================================
LimpaMem:
	; ========== Zera Numericos ==========
	ld a, 0
	ld (TamanhoFrase),a
	ld (NumAleatorio),a
	ld (NumSorteios),a
	ld (DivisorIdeal),a
	ld (PosSorteada),a
	ld (LetraAtual),a
	ld (ContEmbaralha),a
	ld (ContTeste),a
	ld (ContErros),a
	; ========== Zera Matrizes ==========
	ld hl,NumSorteados
	call ZerarMatriz
	; ========== Zera Caracteres ==========
	ld a,' '
	ld (CharConvertido),a
	ld (CaracterTestar),a
	; ========== Zera Strings ==========
	ld hl,Frase
	call LimpaString
	ld hl,FraseEmbaralhada
	call LimpaString
ret

; ========================================================================================
; Imprime uma Nova linha
; ========================================================================================
; Nao usa parametros
; ========================================================================================
; Nada
; ========================================================================================
NovaLinha:
	push af
		ld a, 13
		call TXT_OUTPUT
		ld a, 10
		call TXT_OUTPUT
	pop af
ret
; ========================================================================================

; ========================================================================================
; Imprime uma string terminada em ENTER(13)
; ========================================================================================
; HL => Endereco da string
; ========================================================================================
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

; ========================================================================================
; Imprime um Numero
; ========================================================================================
; A => Numero a ser impresso (8 bits, 255)
; ========================================================================================
; Altera => A,HL,D
; ========================================================================================
PrintNumber:
	ld hl,Centenas
	ld (hl),&00
	ld hl,Dezenas
	ld (hl),&00
	ld hl,Unidades
	ld (hl),&00
ContaCentenas:
	ld d,&64
	ld hl,Centenas
ProximaCentena:
	sub d
	jr c,ContarDezenas
	inc (hl)
jr ProximaCentena

ContarDezenas:
	add d
	ld d,&0a
	ld hl,Dezenas
ProximaDezena:
	sub d
	jr c,ContaUnidades
	inc (hl)
jr ProximaDezena

ContaUnidades:
	add d
	ld (Unidades),a
	ld d,0

ImprimeCentenas:
	ld a,(Centenas)
	cp &00
	jr z,ImprimeDezenas
	add a,&30
	call TXT_OUTPUT
	ld d,1
ImprimeDezenas:
	ld a,(Dezenas)
	add d
	cp &00
	jr z,ImprimeUnidades
	sub d
	ld d,1
	add a,&30
	call TXT_OUTPUT
ImprimeUnidades:
	ld a,(Unidades)
	add a,&30
	call TXT_OUTPUT
ret
; ========================================================================================

; ========================================================================================
; Limpa uma string terminada em ENTER(13)
; ========================================================================================
; HL => Endereco da string
; ========================================================================================
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

; ========================================================================================
; Zerar uma Matriz terminada em 255
; ========================================================================================
; HL => Endereco da Matriz
; ========================================================================================
; ALTERA => A,HL
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
; Converter um numero de 0 a 15 em seu digito hexadecimal
; ========================================================================================
; A => Numero a ser convertido
; ========================================================================================
; ALTERA => A,CharConvertido
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
; =========================================================================================
; FIM DAS FUNCOES GERAIS
; =========================================================================================

; =========================================================================================
; NUMEROS
; =========================================================================================
Centenas:
	defb &00
Dezenas:
	defb &00
Unidades:
	defb &00

; ========================================================================================
; MATRIZES
; ========================================================================================
NumSorteados:
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,255

; ========================================================================================
; STRINGS
; ========================================================================================
MsgUsuario1:
	db "Entre sua mensagem:",13
MsgUsuario2:
	db "Embaralhar:",13
MsgUsuario3:
	db "Frase Embaralhada:",13
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
	db 32,32,32,32,32,32,32,32,32,32,32,32,32,32,13
FraseEmbaralhada:
	db 32,32,32,32,32,32,32,32,32,32,32,32,32,32,13
