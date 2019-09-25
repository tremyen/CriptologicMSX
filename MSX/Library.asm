; =============================================================================
; Library.asm
; =============================================================================
; Manoel Neto 2019-09-25
; Funcoes ASM de uso geral para o MSX
; =============================================================================

; =============================================================================
; Colocar o cursor na posicao inicial.
; =============================================================================
; Nao tem parametros
; =============================================================================
; Altera => Nada
; =============================================================================
Home:
	push hl
		ld h,1
		ld l,1
		call POSIT
	pop hl
ret
; =============================================================================
; Limpar a tela
; =============================================================================
; Nao tem parametros
; =============================================================================
; Altera => Nada
; =============================================================================
LimparTela:
	push af
		xor a
		call CLS
	pop af
ret

; =============================================================================
; Inicializar as variaveis com zero
; =============================================================================
; Nao tem parametros
; =============================================================================
; Altera => A,HL,(NumTamFrase),(NumAleatorio),(NumSorteios),(NumDivIdeal)
; =============================================================================
LimpaMem:
	; ========== Zera Numericos ==========
	xor a
	ld (NumTamFrase),a
	ld (NumAleatorio),a
	ld (NumSorteios),a
	ld (NumDivIdeal),a
	; ========== Zera Strings ==========
	ld hl,StrFrase
	call LimpaString
	; ========== Zera Matrizes ==========
	ld hl,MatSorteados
	call ZerarMatriz
ret

; =============================================================================
; Limpa uma string terminada em ENTER(13)
; =============================================================================
; HL => Endereco da string
; =============================================================================
; Altera => A, HL
; =============================================================================
LimpaString:
	ld b,0
LoopLimpaString:
	ld a,32
	ld (hl),a
	ld a,b
	cp 13
	jp z,LimpouString
	inc hl
	inc b
	jp LoopLimpaString
LimpouString:
	inc hl
	ld a,13
	ld (hl),a
ret

; =============================================================================
; Imprime uma Nova linha
; =============================================================================
; Nao usa parametros
; =============================================================================
; Altera => Nada
; =============================================================================
NovaLinha:
	push af
		ld a, 13
		call CHPUT
		ld a, 10
		call CHPUT
	pop af
ret

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
; Zerar uma Matriz terminada em 255
; =============================================================================
; HL => Endereco da Matriz
; =============================================================================
; ALTERA => A,HL
; =============================================================================
ZerarMatriz:
	ld b,0
LoopZerarMatriz:
	ld a,255
	ld (hl),a
	ld a,b
	cp 13
	jp z,ZerouMatriz
	inc hl
	inc b
	jp LoopZerarMatriz
ZerouMatriz:
	inc hl
	ld a,255
	ld (hl),a
ret

; =============================================================================
; Imprimir um espaco
; =============================================================================
; Nao usa parametros
; =============================================================================
; ALTERA => nada
; =============================================================================
ImprimeEspaco:
	push af
		ld a, ' '
		call CHPUT
	pop af
ret

; =============================================================================
; Converter um numero de 0 a 15 em seu digito hexadecimal
; =============================================================================
; A => Numero a ser convertido
; =============================================================================
; ALTERA => A
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
ret

Um:
	ld a,'1'
ret

Dois:
	ld a,'2'
ret

Tres:
	ld a,'3'
ret

Quatro:
	ld a,'4'
ret

Cinco:
	ld a,'5'
ret

Seis:
	ld a,'6'
ret

Sete:
	ld a,'7'
ret

Oito:
	ld a,'8'
ret

Nove:
	ld a,'9'
ret

DezA:
	ld a,'A'
ret

OnzeB:
	ld a,'B'
ret

Dozec:
	ld a,'C'
ret

TrezeD:
	ld a,'D'
ret

QuatorzeE:
	ld a,'E'
ret

QuinzeF:
	ld a,'F'
ret