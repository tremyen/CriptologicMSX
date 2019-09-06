; =========================================================================================
; INICIALIZAR VARIAVEIS COM ZERO
; LIMPAR A MATRIZ
; LIMPAR AS STRINGS 
; =========================================================================================
TamanhoFrase 		equ &9000	; Variavel => Tamanho da entrada Jog 1
NumAleatorio 		equ &9001	; Variavel => Numero sorteado
CharConvertido 		equ &9002	; Variavel => Caracter Convertido
NumSorteios 		equ &9003	; Variavel => Numero de sorteios realizados

org &8000
	; ================
	; Zera Numericos
	; ================
	ld a, 0
	ld (TamanhoFrase),a
	ld (NumAleatorio),a
	ld (NumSorteios),a
	; ================
	; Limpa Matriz
	; ================
	ld hl,NumerosSorteados
LimpaMatriz:
	ld a,(hl)
	cp 255
	jp z,LimpouMatriz
	ld a, 0
	ld (hl),a
	inc hl
	jp LimpaMatriz	
LimpouMatriz:
	; ================
	; Limpa Caracteres
	; ================
	ld a,' ' 
	ld (CharConvertido), a
	; ================
	; Limpa Strings
	; ================
	ld hl,Frase
LimpaFrase:
	ld a,(hl)
	cp 255
	jp z,LimpouFrase
	ld a,' '
	ld (hl),a
	inc hl
	jp LimpaFrase	
LimpouFrase:

Frase:
	db "0123456789ABCDE",255
NumerosSorteados:
	db 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,255


