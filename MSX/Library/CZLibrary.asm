; ======================================================================
; Funcoes Assembly para MSX
; Manoel Neto 2019-09-23
; ======================================================================
include "library/msx1bios.asm"
include "library/msx1hooks.asm"
include "library/msx1variables.asm"

; ======================================================================
; Limpar a tela
; ======================================================================
; Nao usa parametros
; ======================================================================
; Altera => Nada
; ======================================================================
ClearScreen:
    push af
      xor a
      call CLS
    pop af
ret

; ======================================================================
; Setar modo texto 32 colunas
; ======================================================================
; Nao usa parametros
; ======================================================================
; Altera => Nada
; ======================================================================
InitTxt32Col:
  push af
    call INIT32
    ld a,32
    ld (LINLEN),a
  pop af
ret

; ======================================================================
; Imprime uma Nova linha
; ======================================================================
; Nao usa parametros
; ======================================================================
; Nada
; ======================================================================
NewLine:
	push af
		ld a, 13
		call CHPUT
		ld a, 10
		call CHPUT
	pop af
ret

; ======================================================================
; Imprime uma string terminada em ENTER(13)
; ======================================================================
; HL => Endereco da string
; ======================================================================
; Altera => A,HL
; ======================================================================
PrintString:
	ld a,(hl)
	cp 13
	jp z,EndString
	call CHPUT
	inc hl
	jp PrintString
EndString:
ret

; ======================================================================
; Imprime um Numero
; ======================================================================
; A => Numero a ser impresso (8 bits, 255)
; ======================================================================
; Altera => A,HL,D
; ======================================================================
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
	ld d,&0a
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

Centenas:
	defb &00
Dezenas:
	defb &00
Unidades:
	defb &00

; ======================================================================
; Limpa uma string terminada em ENTER(13)
; ======================================================================
; HL => Endereco da string
; ======================================================================
; Altera => A, HL
; ======================================================================
ClearString:
	ld a,(hl)
	cp 13
	jp z,LimpouString
	ld a,' '
	ld (hl),a
	inc hl
	jp ClearString
LimpouString:
ret

; ======================================================================
; Zerar uma Matriz terminada em 255
; ======================================================================
; HL => Endereco da Matriz
; ======================================================================
; ALTERA => A,HL
; ======================================================================
ClearMatrix:
	ld a,(hl)
	cp 255
	jp z,ZerouMatriz
	ld a,0
	ld (hl),a
	inc hl
	jp ClearMatrix
ZerouMatriz:
ret
