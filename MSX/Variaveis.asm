; =============================================================================
; Variaveis.asm
; =============================================================================
; Manoel Neto 2019-09-25
; Variaveis utilizadas no Criptologic Z80
; =============================================================================
romSize           equ 8192        ; o tamanho que a ROM deve ter
romArea           equ &4000       ; minha ROM começa aqui
ramArea           equ &E000       ; inicio da área de variáveis
NumTamFrase 		  equ ramArea	    ; Variavel => Tamanho da entrada Jog 1
NumAleatorio 		  equ ramArea+1	  ; Variavel => Numero sorteado
NumSorteios 		  equ ramArea+2	  ; Variavel => Numero de sorteios realizados
NumDivIdeal 		  equ ramArea+3	  ; Variavel => Divisor ideal
MatSorteados      equ ramArea+4   ; matriz => Numeros sorteados
StrFrase          equ ramArea+19  ; string => frase digitada
NumPosSort		    equ ramArea+20  ; Variavel => PosicaoSorteada
ChaLetraAtual		  equ ramArea+21  ; Variavel => Letra na posicao sorteada
NumContEmb  		  equ ramArea+22  ; Variavel => Contador de embaralhamento
StrEmbaralhada    equ ramArea+23  ; string => frase Embaralhada
