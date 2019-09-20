; =============================================================================
; Criptologic para Z80
; =============================================================================
; Versao 0.1 (Prototipo)
; Manoel Neto 2019-09-09
; =============================================================================
; =============================================================================
; BIBLIOTECAS
; =============================================================================
include "library/msx1bios.asm"
include "library/msx1variables.asm"
include "library/msx1hooks.asm"
; =============================================================================
; VARIAVEIS
; =============================================================================
romSize:          equ 8192                    ; o tamanho que a ROM deve ter
romArea:          equ 0x4000                  ; minha ROM começa aqui
ramArea:          equ 0xe000                  ; inicio da área de variáveis
TamanhoFrase:     equ ramArea
NumAleatorio:     equ ramArea+1
CharConvertido:   equ ramArea+2
NumSorteios:      equ ramArea+3
DivisorIdeal:     equ ramArea+4
PosSorteada:      equ ramArea+5
LetraAtual:       equ ramArea+6
ContEmbaralha:    equ ramArea+7
CaracterTestar:   equ ramArea+8
ContTeste:        equ ramArea+9
ContErros:        equ ramArea+10
Centenas:         equ ramArea+11
Dezenas:          equ ramArea+12
Unidades:         equ ramArea+13
NumSorteados:     equ ramArea+14
Frase:            equ ramArea+29
FraseEmbaralhada: equ ramArea+44
org romArea
  db "AB"
  dw Main
  db 00,00,00,00,00
; =============================================================================
; Inicio do PROGRAMA
; =============================================================================
Main:
  call LimpaMem             ; Limpa a memoria a cada execucao
  call PegarMensagem        ; Obtem a mensagem do usuario
  call NovaLinha		        ; Pula uma linha
  call SortearNumeros	      ; Sortear os numeros para embaralhar a frase
  call NovaLinha		        ; Pula uma linha
  call Embaralhar           ; Embaralha a frase
  call NovaLinha            ; Pula uma linha
  call PegarChuteJogador	  ; Pegar os chutes do jogador
ret
;==============================================================================
; INICIO DAS FUNCOES DO PROGRAMA
;==============================================================================
; =============================================================================
; Pegar uma mensagem de no minimo 2 caracteres e no maximo 14
; =============================================================================
; Nao usa parametros
; =============================================================================
; Altera => HL,B,A
; =============================================================================
PegarMensagem:
	ld hl,MsgUsuario1	       ; Carrega a primeira Mensagem para o usuario
	call PrintString	       ; Imprime a mensagem
	call LimpaString	       ; limpa a string a cada execucao
	ld hl,Frase		           ; Pegar a frase limpa
	ld b,0			             ; zera o contador de letras
LoopMensagem:
	call CHGET               ; ler um caracter
	ld (hl),a                ; guarda o ascii desse caracter
	call CHPUT               ; imprime o caracter
	inc hl                   ; proximo endereco
	inc b                    ; aumenta o contador de letras
	cp 13                    ; compara o carcter entrado com o ENTER(13)
	jp z,ValidaDuasLetras    ; se a frase terminou por enter
	ld a,b                   ; prepara o contador para comparar
	ld (TamanhoFrase),a      ; guarda o tamanho da frase digitada
	cp 14                    ; compara o contador com 14
	ret z                    ; se A-14 = 0 vc ja digitou 14 letras
	jp LoopMensagem          ; pega o proximo
ValidaDuasLetras:
	ld a,(TamanhoFrase)	     ; prepara o contador para comparar
	cp 3                     ; compara com 3, pois o enter eh um caracter
	ret nc                   ; se a >= 2 esta ok, retorna
jp PegarMensagem

; =============================================================================
; Sortear numeros aleatorios entre 1 e o tamanho da frase
; =============================================================================
; Nao usa parametros
; =============================================================================
; Altera => A,C,D,HL,NumSorteios,NumAleatorio
; =============================================================================
SortearNumeros:
	ld a,0
	ld (NumSorteios),a     ; Primeiro sorteio
	call AcharDivIdeal		 ; achar o divisor ideal para a frase
SortearDeNovo:
	call SortearNumero		 ; Sorteei o numero em NumAleatorio
	jp ValidarMaiorN       ; O numero nao pode ser maior que a entrada
ValidadoMaiorN:
	jp ValidarJaFoi			   ; O numero nao pode se repetir
ValidadoJaFoi:
	call GravarNaMatriz    ; Grava o sorteio na matriz
	call ConvNumChar       ; Converte o numero em digito 1-F
	ld a,(TamanhoFrase)    ; carrega o contador de sorteios
	ld c,a				         ; so irei sortear de acordo com a entrada
	ld a,(NumSorteios)     ; Pega o numero de sorteios
	inc a				           ; Aumenta numero de sorteios
	cp c				           ; testa se eh ultimo sorteio
	jp z,FimSorteio			   ; Acabou
	ld (NumSorteios),a		 ; Grava o numero de sorteios
	jp SortearDeNovo		   ; faz de novo
FimSorteio:
	call ImprimeSorteios		; Imprime numeros sorteados
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
	ld a,(TamanhoFrase)		; pegar o tamanho da frase
	inc a				; temos de comparar com A <
	ld b,a				; guarda tamanho frase+1
	ld a,(NumAleatorio)		; pega o numero aleatorio para comparacao
	cp b				; A < TamFrase+1 ?
	jp c,ValidadoMaiorN		; A < TamFrase+1 ?
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
; =============================================================================
; Embaralhar a Frase
; =============================================================================
; Nao usa parametros
; =============================================================================
; Altera => HL,A,B,ContaEmbaralha,PosSorteada,LetraAtual
; =============================================================================
Embaralhar:
	ld hl,MsgUsuario3		; Carrega a quarta mensagem para o usuario
	call PrintString		; imprime a mensagem
	ld a,0				; prepara primeira passada
	ld (ContEmbaralha),a		; zera o contador de embaralhamento
GravarProxima:
	call AcharPosSort		; achar a posicao sorteada
	call AcharLetra			; acha a letra dessa passada
	call GravarLetra		; gravar a letra dessa passada
	ld a,(TamanhoFrase)
	ld b,a
	ld a,(ContEmbaralha)
	cp b				; se pegamos todos
	jp z,GravouTudo			; gravamos tudo
	inc a 				; senao vamos para a proxima
	ld (ContEmbaralha),a		; e guardamos no contador
	jp GravarProxima		; pega a proxima
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
	dec a 				; enderecos comecam com 0
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
	ld hl,FraseEmbaralhada	; Carrega a frase embaralhada
	call PrintString	; imprime
ret

; =============================================================================
; Imprimir os numeros sorteados
; =============================================================================
; Nao usa parametros
; =============================================================================
; Altera => A,B,HL
; =============================================================================
ImprimeSorteios:
	ld hl,MsgUsuario2      ; Carrega mensagem para o usuario
	call PrintString       ; Imprime a mensagem
	ld a,(TamanhoFrase)    ; Pega o tamanho da frase
	ld b,a				         ; Guarda como contador de loop
	ld hl,NumSorteados     ; Inicia com o endereco da matriz
ProxNum:
	ld a,(hl)              ; Le o primeiro numero
	call ConvNumChar		   ; Converte o numero no seu ascii
	ld a,(CharConvertido)  ; Carrega o caracter convertido
	call CHPUT			       ; Imprime
	ld a, ' '              ; Carrega um espaco
	call CHPUT             ; Imprime um espaco
	dec b                  ; Incrementa o contador de loop
	ld a,b                 ; prepara o contador para comparacao
	cp 0                   ; Testa se e o fim dos sorteios
	jp z,FimImpSorteio     ; Imprimiu todos
	inc hl                 ; Prepara o proximo endereco
	jp ProxNum             ; Pega o proximo
FimImpSorteio:
ret

; =============================================================================
; Pegar os chutes do jogador 2
; =============================================================================
; Nao usa parametros
; =============================================================================
; Altera => A,ContTeste,ContErros,HL,B,CaracterTestar
; =============================================================================
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
	call CHGET
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
	call NovaLinha
	jp LoopPegaChar
ImprimirErros:
	ld hl,MsgUsuario7
	call PrintString
	call NovaLinha
	ld hl,MsgUsuario8
	call PrintString
	ld a,(ContErros)
	call PrintNumber
	call NovaLinha
ret
; =============================================================================
; INICIO DAS FUNCOES GERAIS
; =============================================================================
; =============================================================================
; Inicializar as variaveis com zero
; =============================================================================
; Nao usa parametros
; =============================================================================
; Altera => A,HL,TamanhoFrase,NumAleatorio,NumSorteios,DivisorIdeal,PosSorteada,
; 	    LetraAtual,ContEmbaralha,ContTeste,ContErros,NumSorteados,
;       CharConvertido,CaracterTestar,Frase,FraseEmbaralhada
; =============================================================================
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
; =============================================================================
; Imprime uma Nova linha
; =============================================================================
; Nao usa parametros
; =============================================================================
; Altera => A
; =============================================================================
NovaLinha:
	ld a, 13
	call CHPUT
	ld a, 10
	call CHPUT
ret
; =============================================================================

; =============================================================================
; Imprime uma string terminada em ENTER(13)
; =============================================================================
; HL => Endereco da string
; =============================================================================
; Altera => A,HL
; =============================================================================
PrintString:
	ld a,(hl)
	cp 13
	jp z,EndString
	call CHPUT
	inc hl
	jp PrintString
EndString:
ret
; =============================================================================

; =============================================================================
; Imprime um Numero
; =============================================================================
; A => Numero a ser impresso (8 bits, 255)
; =============================================================================
; Altera => A,HL,D
; =============================================================================
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
	add a,d
	ld d,&0A
	ld hl,Dezenas
ProximaDezena:
	sub d
	jr c,ContaUnidades
	inc (hl)
jr ProximaDezena

ContaUnidades:
	add a,d
	ld (Unidades),a
	ld d,0

ImprimeCentenas:
	ld a,(Centenas)
	cp &00
	jr z,ImprimeDezenas
	add a,&30
	call CHPUT
	ld d,1
ImprimeDezenas:
	ld a,(Dezenas)
	add a,d
	cp &00
	jr z,ImprimeUnidades
	sub d
	ld d,1
	add a,&30
	call CHPUT
ImprimeUnidades:
	ld a,(Unidades)
	add a,&30
	call CHPUT
ret
; =============================================================================

; =============================================================================
; Limpa uma string terminada em ENTER(13)
; =============================================================================
; HL => Endereco da string
; =============================================================================
; Altera => A, HL
; =============================================================================
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
; =============================================================================

; =============================================================================
; Zerar uma Matriz terminada em 255
; =============================================================================
; HL => Endereco da Matriz
; =============================================================================
; ALTERA => A,HL
; =============================================================================
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
; =============================================================================

; =============================================================================
; Converter um numero de 0 a 15 em seu digito hexadecimal
; =============================================================================
; A => Numero a ser convertido
; =============================================================================
; ALTERA => A,CharConvertido
; =============================================================================
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
; =============================================================================
; STRINGS
; =============================================================================
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
; ============================= PAD PARA 32k ==================================
romPad:
  ds romSize-(romPad-romArea),0
  end
; ============================= PAD PARA 32k ==================================
