; =============================================================================
; PegarChutes.asm
; =============================================================================
; Manoel Neto 2019-09-25
; Pegar chute e gravar 												=> (CaracterTestar)
; Testar se o caracter esta na posicao atual 	=> (TestarCorreto)
; Imprimir os erros 													=> (ImprimirErros)
; =============================================================================
PegarChute:
	ld h,NumPosXEntradas
	ld l,NumPosYEntrada2
	call POSIT
	xor a
	ld (NumContTeste),a
	ld (NumContErros),a
LoopPegaChar:
	call PegarEntrada
	jp TestarCorreto
EstaCorreto:
	call CursorCorreto
	ld a,(NumContTeste)
	add a,NumPosXEntradas
	ld h,a
	ld l,NumPosYEntrada2
	call POSIT
	ld a,(ChaTestar)
	call CHPUT
	ld a,(NumTamFrase)
	dec a
	ld b,a
	ld a,(NumContTeste)
	cp b
	jp z,Acertou
	inc a
	ld (NumContTeste),a
	jp LoopPegaChar
Acertou:
	call ImprimirErros
ret

PegarEntrada:
	ld a,(NumContTeste)
	add a,NumPosXEntradas
	ld h,a
	ld l,NumPosYEntrada2
	call POSIT
	call CHGET
	ld (ChaTestar),a
ret

TestarCorreto:
	ld hl,StrFrase
	ld a,(NumContTeste)						; Conta o teste
AcharPosicaoTeste:
	cp 0
	jp z,AchouTeste
	inc hl
	dec a													; proximo teste
	jp AcharPosicaoTeste
AchouTeste:
	ld a,(hl)
	ld b,a
	ld a,(ChaTestar)
	cp b
	jp z,EstaCorreto
	ld a,(NumContErros)
	inc a
	ld (NumContErros),a
	call CursorErrado
	jp LoopPegaChar

ImprimirErros:
	ld a,6
	call LimparLinha
	ld h,NumPosXMensagens
	ld l,6
	call POSIT
	ld hl,MsgUsuario8
	call PrintString
	ld a,7
	call LimparLinha
	ld h,NumPosXMensagens
	ld l,7
	call POSIT
	ld hl,MsgUsuario9
	call PrintString
	ld a,(NumContErros)
	call PrintNumber
ret

CursorCorreto:
		ld a,4
		call LimparLinha
		ld h,NumPosXMensagens
		ld l,4
		call POSIT
		ld hl,MsgUsuario6
		call PrintString
ret

CursorErrado:
		ld a,4
		call LimparLinha
		ld h,NumPosXMensagens
		ld l,4
		call POSIT
		ld hl,MsgUsuario7
		call PrintString
ret
